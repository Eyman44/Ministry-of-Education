import 'package:flutter/material.dart';
import 'package:flutter_application_eyman/constant/color.dart';
import 'package:flutter_application_eyman/constant/image.dart';
import '../services/auth_service.dart';
import '../services/student_service.dart';
import '../utils/global.dart';

class ResultPage extends StatefulWidget {
  final int certTypeId;
  final int eYearId;
  final String number;

  const ResultPage({super.key, required this.certTypeId, required this.eYearId, required this.number});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Map<String, dynamic>> subjects = [];
  int totalMark = 0;
  String fullName = '';
  String school = '';
  String result = '-';
  String year = '';
  String certificate = '';
  String motherName = '';
  String city = '';

  @override
  void initState() {
    super.initState();
    _loadStudentMarks();
  }

  Future<void> _loadStudentMarks() async {
    try {
      await AuthService.loadToken();
      final token = Global.token;
      final baseUrl = Global.baseUrl;

      final data = await StudentService(baseUrl: baseUrl, token: token)
          .fetchStudentMarks(
        certTypeId: widget.certTypeId,
        eYearId: widget.eYearId,
        number: widget.number,
        token: token,
      );

      setState(() {
        final marks = data['studentMarks'] ?? [];
        subjects = List<Map<String, dynamic>>.from(
          marks.map((mark) {
            final subject = mark['subject'] ?? {};
            return {
              'name': subject['name'] ?? 'Unknown',
              'score': mark['mark'] ?? 0,
              'max': subject['maxMark'] ?? 0,
            };
          }),
        );

        totalMark = data['totalMark'] ?? 0;
        fullName = data['fullName'] ?? '-';
        motherName = data['motherName'] ?? '-';
        school = data['school'] ?? '-';
        result = data['result'] ?? '-';
        year = data['eYear']?['value'] ?? '-';
        certificate = data['certType']?['name'] ?? '-';
        city = data['certType']?['city']?['name'] ?? '-';
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'), backgroundColor: Colors.red),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(AppImageAsset.s, fit: BoxFit.cover),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
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
                _buildStudentInfo(),
                const SizedBox(height: 16),
                _buildSubjectsGrid(),
                const SizedBox(height: 24),
                _buildTotalBox(),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text(
                    'Back to Search',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purple,
                      padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 14)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.purple),
        borderRadius: BorderRadius.circular(12),
        color: AppColor.backgroundcolor,
      ),
      child: Row(
        children: [
          Expanded(
            child: Table(
              columnWidths: const {
                0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(),
              },
              children: [
                _tableRow('Registration No:', widget.number),
                _tableRow('Certificate:', certificate),
                _tableRow('Year:', year),
                //_tableRow('Governorate:', city),
                _tableRow('Full Name:', fullName),
                _tableRow('Mother Name:', motherName),
                _tableRow('School:', school),
                TableRow(children: [
                  const Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      'Result:',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Icon(
                          result == 'Passed' ? Icons.check_circle : Icons.cancel,
                          color: result == 'Passed' ? Colors.green : Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(result, style: const TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ])
              ],
            ),
          ),
          const Icon(Icons.perm_contact_calendar_sharp,
              color: Color.fromARGB(255, 170, 175, 219), size: 180),
        ],
      ),
    );
  }

  TableRow _tableRow(String label, String value) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(4),
        child: Text(label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      Padding(
        padding: const EdgeInsets.all(4),
        child: Text(value, style: const TextStyle(fontSize: 18)),
      ),
    ]);
  }

  Widget _buildSubjectsGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: subjects.map((subject) {
        return Container(
          width: 180,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.purple),
            borderRadius: BorderRadius.circular(10),
            color: AppColor.backgroundcolor,
          ),
          child: Column(
            children: [
              Text(subject['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Score: ${subject['score']}',
                  style: const TextStyle(fontSize: 14)),
              Text('Max: ${subject['max']}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTotalBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.orange),
        borderRadius: BorderRadius.circular(12),
        color: AppColor.backgroundcolor,
      ),
      child: Text('Total: $totalMark',
          style: const TextStyle(
              color: AppColor.orange,
              fontSize: 20,
              fontWeight: FontWeight.bold)),
    );
  }
}
