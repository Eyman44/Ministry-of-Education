import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_eyman/constant/color.dart';
import 'package:flutter_application_eyman/constant/image.dart';
import 'package:flutter_application_eyman/services/student_service.dart';
import 'package:flutter_application_eyman/utils/global.dart';

import '../models/education_model.dart';
import '../models/year_model.dart';

class StudentProfilePage extends StatefulWidget {
  final int? certTypeId;
  final int? eYearId;
  final String? number;
  final String? fullName;
  final String? motherName;
  final String? school;
  final int? studentId;

  const StudentProfilePage({
    super.key,
    this.certTypeId,
    this.eYearId,
    this.number,
    this.fullName,
    this.motherName,
    this.school,
    this.studentId,
  });

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController registrationNoController =
      TextEditingController();
  final TextEditingController certificateController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();

  List<YearModel> years = [];
  List<String> certifications = [];
  String? selectedCertification;
  YearModel? selectedYear;
  List<CertTypeModel> certTypes = [];
  CertTypeModel? selectedCertType;

  String resultStatus = 'Passed';
  bool isLoading = true;
  bool isCertLoading = true;
  int? studentId;

  bool get isEditMode =>
      widget.certTypeId != null &&
      widget.eYearId != null &&
      widget.number != null;

  late StudentService studentService;

  @override
  void initState() {
    super.initState();
    studentService =
        StudentService(baseUrl: Global.baseUrl, token: Global.token);

    if (isEditMode) {
      studentId = widget.studentId;
      fullNameController.text = widget.fullName ?? '';
      motherNameController.text = widget.motherName ?? '';
      registrationNoController.text = widget.number ?? '';
      schoolController.text = widget.school ?? '';
      yearController.text = widget.eYearId?.toString() ?? '';
      certificateController.text = widget.certTypeId?.toString() ?? '';
    }

    loadYears();
    loadCertTypes();
  }

  void loadYears() async {
    try {
      final url = Uri.parse('${Global.baseUrl}/admin/years');
      final response =
          await http.get(url, headers: {'Authorization': Global.token});
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        setState(() {
          years = data.map((e) => YearModel.fromJson(e)).toList();
        });
      }
    } catch (e) {
      print('Error fetching years: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void loadCertTypes() async {
    try {
      final url = Uri.parse('${Global.baseUrl}/certType/');
      final response =
          await http.get(url, headers: {'Authorization': Global.token});
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        final types = data.map((e) => CertTypeModel.fromJson(e)).toList();
        setState(() {
          certTypes = types;
          certifications =
              types.map((e) => e.certificationName).toSet().toList();
        });
      }
    } catch (e) {
      print('Error fetching certificate types: $e');
    } finally {
      setState(() => isCertLoading = false);
    }
  }

  void _resetForm() {
    registrationNoController.clear();
    certificateController.clear();
    yearController.clear();
    motherNameController.clear();
    fullNameController.clear();
    schoolController.clear();
    setState(() {
      selectedCertification = null;
      selectedCertType = null;
      selectedYear = null;
      resultStatus = 'Passed';
    });
  }

  void _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (isEditMode && studentId != null) {
          await studentService.updateStudent(
            id: studentId!,
            fullName: fullNameController.text.trim(),
            motherName: motherNameController.text.trim(),
            number: registrationNoController.text.trim(),
            school: schoolController.text.trim(),
            eYearId: selectedYear!.id,
          );
        } else {
          await studentService.addStudent(
            fullName: fullNameController.text.trim(),
            motherName: motherNameController.text.trim(),
            number: registrationNoController.text.trim(),
            school: schoolController.text.trim(),
            eYearId: selectedYear!.id,
            certTypeId: selectedCertType!.id,
          );
          _resetForm();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditMode
                ? 'Student updated successfully'
                : 'Student saved successfully'),
            backgroundColor: AppColor.purple,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed saving student $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundcolor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SizedBox.expand(
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(AppImageAsset.s, fit: BoxFit.cover),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(AppImageAsset.logo),
                              radius: 26,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Ministry of Education',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColor.purple,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(Icons.school,
                                color: AppColor.purple, size: 22),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: AppColor.purple, width: 1.2),
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white.withOpacity(0.95),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Table(
                                          columnWidths: const {
                                            0: IntrinsicColumnWidth(),
                                            1: FlexColumnWidth(),
                                          },
                                          defaultVerticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          children: [
                                            _buildRow('Registration No:',
                                                registrationNoController),
                                            if (!isEditMode) ...[
                                              TableRow(children: [
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Text('Certification:',
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                ),
                                                DropdownButtonFormField<String>(
                                                  value: selectedCertification,
                                                  decoration: const InputDecoration(
                                                      border:
                                                          OutlineInputBorder()),
                                                  hint: const Text(
                                                      "Select Certification"),
                                                  items: certifications
                                                      .map((cert) =>
                                                          DropdownMenuItem(
                                                              value: cert,
                                                              child:
                                                                  Text(cert)))
                                                      .toList(),
                                                  onChanged: isEditMode
                                                      ? null
                                                      : (value) {
                                                          setState(() {
                                                            selectedCertification =
                                                                value;
                                                            selectedCertType =
                                                                null;
                                                          });
                                                        },
                                                ),
                                              ]),
                                            ],
                                            if (selectedCertification != null)
                                              TableRow(children: [
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 10),
                                                  child: Text('Type:',
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                ),
                                                DropdownButtonFormField<
                                                    CertTypeModel>(
                                                  value: selectedCertType,
                                                  decoration: const InputDecoration(
                                                      border:
                                                          OutlineInputBorder()),
                                                  hint:
                                                      const Text("Select Type"),
                                                  items: certTypes
                                                      .where((type) =>
                                                          type.certificationName ==
                                                          selectedCertification)
                                                      .map((type) =>
                                                          DropdownMenuItem(
                                                              value: type,
                                                              child: Text(
                                                                  type.name)))
                                                      .toList(),
                                                  onChanged: isEditMode
                                                      ? null
                                                      : (value) {
                                                          setState(() {
                                                            selectedCertType =
                                                                value;
                                                          });
                                                        },
                                                ),
                                              ]),
                                            TableRow(children: [
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10),
                                                child: Text('Year:',
                                                    style: TextStyle(
                                                        fontSize: 16)),
                                              ),
                                              DropdownButtonFormField<
                                                  YearModel>(
                                                value: selectedYear,
                                                decoration: const InputDecoration(
                                                    border:
                                                        OutlineInputBorder()),
                                                hint: const Text("Select Year"),
                                                items: years.map((year) {
                                                  return DropdownMenuItem(
                                                    value: year,
                                                    child: Text(year.value),
                                                  );
                                                }).toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedYear = value;
                                                  });
                                                },
                                              ),
                                            ]),
                                            _buildRow('Full Name:',
                                                fullNameController),
                                            _buildRow('Mother Name:',
                                                motherNameController),
                                            _buildRow(
                                                'School:', schoolController),
                                          ],
                                        ),
                                      ),
                                      if (constraints.maxWidth > 600)
                                        const Padding(
                                          padding: EdgeInsets.only(left: 16),
                                          child: Icon(
                                              Icons.perm_contact_calendar_sharp,
                                              color: Color.fromARGB(
                                                  255, 170, 175, 219),
                                              size: 100),
                                        ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: _saveStudent,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.purple,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              isEditMode ? 'Update' : 'Save',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  TableRow _buildRow(String label, TextEditingController controller) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: TextFormField(
          controller: controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          validator: (value) =>
              value == null || value.isEmpty ? 'Required' : null,
        ),
      ),
    ]);
  }
}
