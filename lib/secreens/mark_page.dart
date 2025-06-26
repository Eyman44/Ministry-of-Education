import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_eyman/constant/color.dart';
import 'package:flutter_application_eyman/constant/image.dart';
import 'package:flutter_application_eyman/secreens/student_profile.dart';
import 'package:flutter_application_eyman/secreens/result_page.dart';
import '../services/auth_service.dart';
import '../services/student_service.dart';
import '../utils/global.dart';

class Mark_page extends StatefulWidget {
  final int certTypeId;
  final int eYearId;
  final String number;

  const Mark_page({
    super.key,
    required this.certTypeId,
    required this.eYearId,
    required this.number,
  });

  @override
  State<Mark_page> createState() => _MarkPageState();
}

class _MarkPageState extends State<Mark_page> {
  List<Map<String, dynamic>> subjects = [];
  int totalMark = 0;
  String fullName = '';
  String school = '';
  String result = '-';
  String year = '';
  String certificate = '';
  String motherName = '';
  int studentId = 0;

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
        subjects = List<Map<String, dynamic>>.from(
          data['studentMarks'].map((mark) => {
            'id': mark['id'],
            'name': mark['subject']['name'],
            'score': TextEditingController(text: mark['mark'].toString()),
            'max': mark['subject']['maxMark'],
          }),
        );
        totalMark = data['totalMark'];
        fullName = data['fullName'];
        school = data['school'];
        result = data['result'];
        year = data['eYear']['value'];
        certificate = data['certType']['name'];
        motherName = data['motherName'];
        studentId = data['id'];
      });
    } catch (e) {
      print('Error loading student marks: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e'), backgroundColor: Colors.red),
      );
    }
  }

  int get totalScore => subjects.fold(0, (sum, subject) {
    final value = int.tryParse(subject['score'].text) ?? 0;
    return sum + value;
  });

  Future<void> _submitAllScores() async {
    try {
      await AuthService.loadToken();
      final token = Global.token;
      final baseUrl = Global.baseUrl;
      final studentService = StudentService(baseUrl: baseUrl, token: token);

      for (var subject in subjects) {
        final int markId = subject['id'];
        final int newMark = int.tryParse(subject['score'].text) ?? 0;

        await studentService.updateMark(
          id: markId,
          mark: newMark,
          studentId: studentId,
          token: token,
          baseUrl: baseUrl,
        );
      }
      setState(() {
        totalMark = totalScore;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('All marks updated successfully!'),
            backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error updating marks: $e'),
            backgroundColor: Colors.red),
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
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage(AppImageAsset.logo),
                          radius: 24),
                      SizedBox(width: 8),
                      Text('Ministry of Education',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.purple)),
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
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _submitAllScores,
                  icon: const Icon(Icons.save_rounded, color: Colors.white),
                  label: const Text('Submit All Scores',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14)),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  label: const Text('Back to Search',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.purple,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14)),
                ),
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
      child: Column(
        children: [
          Row(
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
                    _tableRow('Full Name:', fullName),
                    _tableRow('School:', school),
                    _tableRow('Mother Name:', motherName),
                    TableRow(children: [
                      const Padding(
                        padding: EdgeInsets.all(4),
                        child: Text('Result:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Icon(
                                result == 'Passed'
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: result == 'Passed'
                                    ? Colors.green
                                    : Colors.red,
                                size: 18),
                            const SizedBox(width: 6),
                            Text(result, style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              const Icon(Icons.perm_contact_calendar_sharp,
                  color: Color.fromARGB(255, 170, 175, 219), size: 180),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentProfilePage(
                    studentId: studentId,
                    fullName: fullName,
                    motherName: motherName,
                    number: widget.number,
                    school: school,
                    eYearId: widget.eYearId,
                    certTypeId: widget.certTypeId,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text('Edit Student',
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.orange),
          ),
        ],
      ),
    );
  }

  TableRow _tableRow(String label, String value) {
    return TableRow(children: [
      Padding(
          padding: const EdgeInsets.all(4),
          child: Text(label,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
      Padding(
          padding: const EdgeInsets.all(4),
          child: Text(value, style: const TextStyle(fontSize: 18))),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(subject['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: subject['score'],
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                    labelText: 'Score', border: OutlineInputBorder()),
                onChanged: (value) {
                  final maxMark = subject['max'] as int;
                  final entered = int.tryParse(value) ?? 0;
                  if (entered > maxMark) {
                    subject['score'].text = maxMark.toString();
                    subject['score'].selection = TextSelection.fromPosition(
                      TextPosition(offset: subject['score'].text.length),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Score cannot exceed $maxMark'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  setState(() {});
                },              ),
              const SizedBox(height: 6),
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
