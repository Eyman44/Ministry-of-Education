import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_eyman/constant/color.dart';
import 'package:flutter_application_eyman/constant/image.dart';
import 'package:flutter_application_eyman/secreens/mark_page.dart';
import 'package:flutter_application_eyman/secreens/result_page.dart';
import 'package:http/http.dart' as http;
import '../models/education_model.dart';
import '../models/year_model.dart';
import '../utils/global.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<CertTypeModel> certTypes = [];
  List<String> certifications = [];
  String? selectedCertification;
  bool isCertLoading = true;

  List<YearModel> years = [];
  YearModel? selectedYear;
  bool isLoading = true;

  int? certTypeId;
  int? eYearId;
  final TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadYears();
    loadCertTypes();
  }
  void loadCertTypes() async {
    try {
      final baseUrl = Global.baseUrl;
      final url = Uri.parse('$baseUrl/certType/');
      final response = await http.get(url, headers: {
      });

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        final types = data.map((e) => CertTypeModel.fromJson(e)).toList();
        setState(() {
          certTypes = types;
          certifications =
              types.map((e) => e.certificationName).toSet().toList();
          isCertLoading = false;
        });
      } else {
        print(response.statusCode);
        throw Exception('Failed fetching certificate types');
      }
    } catch (e) {
      setState(() => isCertLoading = false);
    }
  }

  void loadYears() async {
    try {
      final baseUrl = Global.baseUrl;
      final token= Global.token;
      final url = Uri.parse('$baseUrl/admin/years');
      final response = await http.get(url, headers: {
        'Authorization': token,
      });

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        setState(() {
          years = data.map((e) => YearModel.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed fetching years');
      }
    } catch (e) {
      print('Error fetching years: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                AppImageAsset.s,
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(AppImageAsset.logo),
                        radius: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Ministry of Education',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.purple,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.school, color: AppColor.purple, size: 20),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '/');
                      },
                      icon: const Icon(Icons.login, color: AppColor.purple),
                      label: const Text(
                        'Administration Page',
                        style: TextStyle(color: AppColor.purple, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                const Spacer(),
                Center(
                  child: Card(
                    color: AppColor.backgroundcolor,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            ' Choose Education Type',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColor.title,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // نوع الشهادة

                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.school),
                              labelText: "Certificate",
                              border: OutlineInputBorder(),
                            ),


                            value: selectedCertification,
                            items: certifications
                                .map((name) => DropdownMenuItem<String>(
                              value: name,
                              child: Text(name),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCertification = value;
                               // certTypeId = null; // reset branch selection
                              });
                            },
                          ),

                          const SizedBox(height: 12),

                          // قائمة
                          DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.school_outlined),
                              labelText: "Branch",
                              border: OutlineInputBorder(),
                            ),
                            value: certTypeId,
                            items: certTypes
                                .where((c) =>
                            c.certificationName == selectedCertification)
                                .map((c) => DropdownMenuItem<int>(
                              value: c.id,
                              child: Text(c.name),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                certTypeId = value;
                              });
                            },
                          ),

                          const SizedBox(height: 12),

                          // السنة
                               DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today),
                              labelText: "Academic Year",
                              border: OutlineInputBorder(),
                            ),
                            value: eYearId,
                            items: years.map((year) {
                              return DropdownMenuItem<int>(
                                value: year.id,
                                child: Text(year.value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                eYearId = value;
                              });
                            },
                          ),

                          const SizedBox(height: 12),

                          // رقم الاكتتاب
                          TextField(
                            controller: numberController,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.confirmation_number),
                              labelText: 'Registration Number',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(height: 20),

                          // زر البحث
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (certTypeId != null &&
                                    eYearId != null &&
                                    numberController.text.isNotEmpty) {
                                  final bool loggedIn = Global.token.isNotEmpty;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => loggedIn
                                          ? Mark_page(
                                        certTypeId: certTypeId!,
                                        eYearId: eYearId!,
                                        number: numberController.text,
                                      )
                                          : ResultPage(
                                        certTypeId: certTypeId!,
                                        eYearId: eYearId!,
                                        number: numberController.text,),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please fill all fields"),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.search,
                                color: AppColor.backgroundcolor,
                              ),
                              label: const Text(
                                'Search',
                                style:
                                TextStyle(color: AppColor.backgroundcolor),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.purple,
                                textStyle: const TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
