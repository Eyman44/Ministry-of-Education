// services/student_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/year_model.dart';
import '../utils/global.dart';

class StudentService {
  final baseUrl = Global.baseUrl;
  final token = Global.token;


  StudentService({required baseUrl, required token});

  Future<void> addStudent({
    required String fullName,
    required String motherName,
    required String number,
    required String school,
    required int eYearId,
    required int certTypeId,
  }) async {
    final url = Uri.parse('$baseUrl/student');

    final response = await http.post(
      url,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: {
        'fullName': fullName,
        'motherName': motherName,
        'number': number,
        'school': school,
        'eYearId': eYearId.toString(),
        'certTypeId': certTypeId.toString(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed creating student: ${response.body}');
    }
  }

  Future<void> updateStudent({
    required int id,
    required String fullName,
    required String motherName,
    required String number,
    required String school,
    required int eYearId,
  }) async {
    final url = Uri.parse('$baseUrl/student');
    final response = await http.put(
      url,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'id': id.toString(),
        'fullName': fullName,
        'motherName': motherName,
        'number': number,
        'school': school,
        'eYearId': eYearId.toString(),
      },
    );

    if (response.statusCode != 200) {
      print('Response body: ${response.body}');
      throw Exception('Failed updating student: ${response.body}');

    }
  }

  Future<Map<String, dynamic>> getStudentById({
    required int certTypeId,
    required int eYearId,
    required String number,
  }) async {
    final url = Uri.parse('$baseUrl/student/$certTypeId/$eYearId/$number');

    final response = await http.get(
      url,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['data'] != null) {
        return json['data'];
      } else {
        throw Exception('No data found for this student');
      }
    } else {
      throw Exception('Failed to fetch student: ${response.body}');
    }
  }

  Future<void> updateMark({
    required int id,
    required int mark,
    required int studentId,
    required String token,
    required String baseUrl,
  }) async {
    final url = Uri.parse('$baseUrl/student/mark');
    final response = await http.put(
      url,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'id': id.toString(),
        'mark': mark.toString(),
        'studentId': studentId.toString(),

      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed editing mark: ${response.body}');
    }
  }

  Future<List<YearModel>> fetchYears() async {
    final url = Uri.parse('$baseUrl/admin/years');
    final response = await http.get(url, headers: {
      'Authorization': token,
    });

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((e) => YearModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed in fetching year');
    }
  }

  Future<Map<String, dynamic>> fetchStudentMarks({
    required int certTypeId,
    required int eYearId,
    required String number,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/student/$eYearId/$certTypeId/$number');

    final response = await http.get(
      url,
      headers: {
        'Authorization':  token,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['data'] != null) {
        return json['data'];
      } else {
        throw Exception('No data field for this student');
      }
    } else {
      throw Exception('Failed fetch marks: ${response.body}');
    }
  }
}
