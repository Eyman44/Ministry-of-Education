import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_eyman/controllers/certificate_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_application_eyman/constant/color.dart';
import 'package:flutter_application_eyman/constant/image.dart';
import 'package:flutter_application_eyman/models/education_model.dart';
import 'package:flutter_application_eyman/widgets/certificate_tab.dart';
import 'package:flutter_application_eyman/utils/global.dart';

class CertificateDashboard extends StatefulWidget {
  const CertificateDashboard({super.key});

  @override
  State<CertificateDashboard> createState() => _CertificateDashboardState();
}

class _CertificateDashboardState extends State<CertificateDashboard>
    with TickerProviderStateMixin {
  final CertificatesController controller = Get.put(CertificatesController());

  String? selectedYear;
  late TabController _tabController;

  final RxList<Certificate> certificates = <Certificate>[
    Certificate(
      name: "Intermediate Certificate",
      subjects: [
        Subject(name: "Arabic Language", maxMark: 600),
        Subject(name: "Mathematics", maxMark: 400),
        Subject(name: "Biology", maxMark: 200),
        Subject(name: "English Language", maxMark: 200),
        Subject(name: "History science", maxMark: 100),
        Subject(name: "geography", maxMark: 100),
      ],
      icon: Icons.school,
      imageAsset: AppImageAsset.basic,
    ),
    Certificate(
      name: "Religious Intermediate",
      subjects: [
        Subject(name: "Fiqh", maxMark: 200),
        Subject(name: "Hadith", maxMark: 200),
      ],
      icon: Icons.book_online,
      imageAsset: AppImageAsset.religious,
    ),
    Certificate(
      name: "Scientific Secondary",
      subjects: [
        Subject(name: "Physics", maxMark: 90),
        Subject(name: "Chemistry", maxMark: 90),
      ],
      icon: Icons.science,
      imageAsset: AppImageAsset.scientific,
    ),
    Certificate(
      name: "Literary Secondary",
      subjects: [
        Subject(name: "Philosophy", maxMark: 400),
        Subject(name: "French Language", maxMark: 300),
      ],
      icon: Icons.menu_book,
      imageAsset: AppImageAsset.literary,
    ),
    Certificate(
      name: "Vocational Secondary",
      subjects: [
        Subject(name: "Carpentry", maxMark: 200),
        Subject(name: "Mechanics", maxMark: 300),
      ],
      icon: Icons.handyman,
      imageAsset: AppImageAsset.vocational,
    ),
  ].obs;

  @override
  void initState() {
    super.initState();
    controller.fetchYears().then((_) {
      if (controller.years.isNotEmpty) {
        selectedYear = controller.years.first;
      }
    });
    _tabController = TabController(length: certificates.length, vsync: this);
    ever(certificates, (_) {
      _tabController.dispose();
      _tabController = TabController(length: certificates.length, vsync: this);
      setState(() {});
    });
  }

 Future<void> _showAddCertificateDialog() async {
  final TextEditingController ctrl = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final name = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Add Certificate'),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Certificate Name'),
          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.pop(ctx, ctrl.text.trim());
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );

  if (name != null) {
    try {
      bool success = await controller.addCertificate(name);
      if (success) {
        certificates.add(
          Certificate(
            name: name,
            subjects: [],
            icon: Icons.school,
            imageAsset: AppImageAsset.basic,
          ),
        );
      } else {
        // مثلاً يمكن إظهار رسالة للمستخدم أو تجاهلها بصمت
        print("API responded with failure. Certificate not added.");
      }
    } catch (e) {
      print("Error while adding certificate: $e");
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DefaultTabController(
        length: certificates.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(145),
            child: AppBar(
              backgroundColor: AppColor.title,
              flexibleSpace: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 2, top: 10),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage(AppImageAsset.logo),
                        radius: 30,
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "🎓 Ministry of Education",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.iconColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Obx(() {
                                if (controller.isLoading.value) {
                                  return const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColor.iconColor,
                                    ),
                                  );
                                }
                                return DropdownButton<String>(
                                  value: selectedYear,
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: AppColor.iconColor),
                                  underline: Container(
                                      height: 1,
                                      color: AppColor.backgroundcolor),
                                  onChanged: (v) => selectedYear = v,
                                  items: controller.years
                                      .map(
                                        (y) => DropdownMenuItem(
                                          value: y,
                                          child: Text(y,
                                              style: const TextStyle(
                                                  color: AppColor.purple)),
                                        ),
                                      )
                                      .toList(),
                                );
                              }),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColor.orange,
                unselectedLabelColor: AppColor.backgroundcolor,
                tabs: certificates
                    .map(
                      (cert) => Tab(
                        child: Row(
                          children: [
                            Icon(cert.icon, size: 20),
                            const SizedBox(width: 5),
                            Text(cert.name),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddCertificateDialog,
            backgroundColor: AppColor.purple,
            child: const Icon(Icons.add),
          ),
          body: TabBarView(
            controller: _tabController,
            children: certificates.asMap().entries.map((entry) {
              final index = entry.key;
              final cert = entry.value;
              return CertificateTab(
                certificate: cert,
                onAddSubject: (subject) =>
                    certificates[index].subjects.add(subject),
                onEditSubject: (i, subject) =>
                    certificates[index].subjects[i] = subject,
              );
            }).toList(),
          ),
        ),
      );
    });
  }
}
