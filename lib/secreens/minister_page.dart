import 'package:flutter/material.dart';
import 'package:flutter_application_eyman/constant/color.dart';
import 'package:flutter_application_eyman/constant/image.dart';
import 'package:flutter_application_eyman/controllers/certificate_controller.dart';
import 'package:flutter_application_eyman/models/education_model.dart';
import 'package:flutter_application_eyman/widgets/certificate_tab.dart';
import 'package:get/get.dart';

class CertificateDashboard extends StatelessWidget {
  CertificateDashboard({super.key});
  final CertificateController controller = Get.put(CertificateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: AppColor.title,
          flexibleSpace: const SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(AppImageAsset.logo),
                    radius: 30,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "\ud83c\udf93 Ministry of Education",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColor.iconColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return DefaultTabController(
          length: controller.certificates.length + 1,
          child: Column(
            children: [
              Container(
                color: AppColor.title,
                child: TabBar(
                  isScrollable: true,
                  labelColor: AppColor.orange,
                  unselectedLabelColor: AppColor.backgroundcolor,
                  tabs: [
                    ...controller.certificates.map((cert) {
                      return Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(cert.name),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () async {
                                final TextEditingController editController =
                                    TextEditingController(text: cert.name);
                                final name = await showDialog<String>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Edit Certificate"),
                                      content: TextField(
                                        decoration: const InputDecoration(
                                            labelText: "New Name"),
                                        controller: editController,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pop(
                                              context, editController.text),
                                          child: const Text("Save"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (name != null && name.trim().isNotEmpty) {
                                  controller.updateCertificate(
                                      cert.id, name.trim());
                                }
                              },
                              child: const Icon(Icons.edit,
                                  size: 16, color: Colors.white),
                            )
                          ],
                        ),
                      );
                    }),
                    Tab(
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () async {
                          final TextEditingController nameController =
                              TextEditingController();
                          final name = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("New Certificate"),
                                content: TextField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                      labelText: "Certificate Name"),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(
                                        context, nameController.text),
                                    child: const Text("Create"),
                                  ),
                                ],
                              );
                            },
                          );
                          if (name != null && name.trim().isNotEmpty) {
                            controller.createCertificate(name.trim());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ...controller.certificates.map((cert) {
                      return DefaultTabController(
                        length: cert.certTypes.length + 1,
                        child: Column(
                          children: [
                            Container(
                              color: AppColor.title,
                              child: TabBar(
                                isScrollable: true,
                                labelColor: AppColor.orange,
                                unselectedLabelColor: AppColor.backgroundcolor,
                                tabs: [
                                  ...cert.certTypes.map((type) {
                                    return Tab(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              "${type.name} - ${type.city.name}",
                                              style: const TextStyle(
                                                  fontSize: 13)),
                                          const SizedBox(width: 4),
                                          GestureDetector(
                                            onTap: () async {
                                              final TextEditingController
                                                  nameController =
                                                  TextEditingController(
                                                      text: type.name);
                                              final name =
                                                  await showDialog<String>(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Edit Certificate Type"),
                                                    content: TextField(
                                                      controller:
                                                          nameController,
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  "New Name"),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: const Text(
                                                              "Cancel")),
                                                      ElevatedButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                nameController
                                                                    .text),
                                                        child:
                                                            const Text("Save"),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                              if (name != null &&
                                                  name.trim().isNotEmpty) {
                                                controller
                                                    .updateCertificateType(
                                                  type.id,
                                                  name.trim(),
                                                  cert.id,
                                                  type.city.id,
                                                );
                                              }
                                            },
                                            child: const Icon(Icons.edit,
                                                size: 14, color: Colors.white),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                                  Tab(
                                    child: IconButton(
                                      icon: const Icon(Icons.add,
                                          color: Colors.white),
                                      onPressed: () async {
                                        final TextEditingController
                                            nameController =
                                            TextEditingController();
                                        final name = await showDialog<String>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "New Certificate Type"),
                                              content: TextField(
                                                controller: nameController,
                                                decoration:
                                                    const InputDecoration(
                                                        labelText: "Type Name"),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child:
                                                        const Text("Cancel")),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context,
                                                          nameController.text),
                                                  child: const Text("Create"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if (name != null &&
                                            name.trim().isNotEmpty) {
                                          int cityId = cert.certTypes.isNotEmpty
                                              ? cert.certTypes.first.city.id
                                              : 1;
                                          controller.createCertificateType(
                                              name.trim(), cert.id, cityId);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  ...cert.certTypes.map((type) {
                                    return CertificateTab(
                                      certificate: Certificate(
                                        name:
                                            "${type.name} - ${type.city.name}",
                                        subjects: type.subjects
                                            .map((subj) => Subject(
                                              id: subj.id,
                                                name: subj.name,
                                                maxMark: subj.maxMark,
                                                minMark: subj.minMark))
                                            .toList(),
                                        icon: Icons.school,
                                        imageAsset: AppImageAsset.basic,
                                      ), certTypeId: type.id, 
                                      onRefresh: () => controller.fetchCertificates(),
                                    );
                                  }),
                                  const Center(
                                    child: Text(
                                        "Create a new certificate type using ➕ above"),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                    const Center(
                      child: Text("Create a new certificate using ➕ above"),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
