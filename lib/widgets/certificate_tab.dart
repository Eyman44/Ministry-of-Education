import 'package:flutter/material.dart';
import 'package:flutter_application_eyman/constant/color.dart';
import 'package:flutter_application_eyman/models/education_model.dart';
import 'package:flutter_application_eyman/widgets/subject_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter_application_eyman/controllers/certificate_controller.dart';

class CertificateTab extends StatelessWidget {
  final Certificate certificate;
  final int certTypeId; // أضفت هذا لتمرير معرف نوع الشهادة
  final Function() onRefresh; 

  CertificateTab({
    super.key,
    required this.certificate,
    required this.certTypeId,
    required this.onRefresh,
  });

  final CertificateController controller = Get.find();

  int get totalMarks =>
      certificate.subjects.fold(0, (sum, subj) => sum + subj.maxMark);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Opacity(
            opacity: 0.5,
            child: Image.asset(
              certificate.imageAsset,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: certificate.subjects.length,
                itemBuilder: (context, index) {
                  final subject = certificate.subjects[index];
                  return Card(
                    elevation: 7,
                    color: AppColor.backgroundcolor,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(subject.name),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildMarkCircle(
                            icon: Icons.arrow_downward,
                            value: subject.minMark,
                          ),
                          const SizedBox(width: 6),
                          _buildMarkCircle(
                            icon: Icons.arrow_upward,
                            value: subject.maxMark,
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final edited = await showDialog<Subject>(
                            context: context,
                            builder: (context) =>
                                SubjectDialog(subject: subject),
                          );
                          if (edited != null) {
                            await controller.editSubject(
                              id: subject.id,
                              name: edited.name,
                              maxMark: edited.maxMark,
                              minMark: edited.minMark,
                            );
                            onRefresh();
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final newSubject = await showDialog<Subject>(
                        context: context,
                        builder: (context) => const SubjectDialog(),
                      );
                      if (newSubject != null) {
                        await controller.addSubject(
                          name: newSubject.name,
                          maxMark: newSubject.maxMark,
                          minMark: newSubject.minMark,
                          certTypeId: certTypeId,
                        );
                        onRefresh(); // إعادة تحميل البيانات من الخارج
                      }
                    },
                    icon: const Icon(Icons.add_circle_outline,
                        size: 28, color: AppColor.backgroundcolor),
                    label: const Text(
                      "Add Subject",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.backgroundcolor),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 8,
                      shadowColor: AppColor.purple.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Total Marks: $totalMarks",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildMarkCircle({
    required IconData icon,
    required int value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColor.orange),
          const SizedBox(width: 1),
          Text(
            '$value',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
