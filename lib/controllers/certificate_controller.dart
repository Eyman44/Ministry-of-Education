import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_eyman/constant/image.dart';
import 'package:flutter_application_eyman/models/education_model.dart';
import 'package:flutter_application_eyman/utils/global.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CertificatesController extends GetxController {
  final String _baseUrl = Global.baseUrl;
  final String _token = Global.token;

  var years = <String>[].obs;
  var isLoading = false.obs;

  var certificates = <Certificate>[
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

  Future<void> fetchYears() async {
    try {
      isLoading(true);
      final res = await http.get(Uri.parse("$_baseUrl/admin/years"));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['status'] == 'Success') {
          years.assignAll(
              List<String>.from(data['data'].map((e) => e['value'])));
        } else {
          print('Backend message: ${data['message']}');
          Get.snackbar('Error', data['message'] ?? 'Unknown error');
        }
      } else {
        print('Server error: ${res.statusCode}');
        Get.snackbar('Error', 'Server error: ${res.statusCode}');
      }
    } catch (e) {
      print('Exception while fetching years: $e');
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<bool> addCertificate(String name) async {
    try {
      final res = await http.post(
        Uri.parse("$_baseUrl/cert"),
        headers: {
          "Authorization": _token,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: jsonEncode({"name": name}),
      );

      final data = json.decode(res.body);
      if (res.statusCode == 200 && data['status'] == 'Success') {
        print("Certificate added successfully: $name");
        Get.snackbar('Success', 'Certificate added successfully');

        certificates.add(Certificate(
          name: name,
          subjects: [],
          icon: Icons.school,
          imageAsset: AppImageAsset.basic,
        ));
        return true;
      } else {
        print(data['status']);
        print(data);
        print("Error from backend: ${data['message']}");
        Get.snackbar('Error', data['message'] ?? 'Failed to add certificate');
        return false;
      }
    } catch (e) {
      print("Exception while adding certificate: $e");
      Get.snackbar('Error', e.toString());
      return false;
    }
  }
}
