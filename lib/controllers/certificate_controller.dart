import 'dart:convert';
import 'package:flutter_application_eyman/models/cert-model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CertificateController extends GetxController {
  var isLoading = true.obs;
  var certificates = <GeneralCertificate>[].obs;

  Future<void> fetchCertificates() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      String? token1 = prefs.getString('auth');
      if (token1 == null) {
        throw Exception('Token is null');
      }

      final response = await http.get(
        Uri.parse('https://project2-e2k6.onrender.com/cert'),
        headers: {
          "Authorization": token1,
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final certResponse = CertificateResponse.fromJson(data);
        certificates.value = certResponse.data;
        print('Sucessssssssss');
        print(data);
      } else {
        print(
            'Failed to load certificates ${response.statusCode} $response.body}');
      }
    } catch (e) {
      print('Error fetching certificates: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> createCertificate(String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');
      if (token == null) throw Exception('Token is null');

      final response = await http.post(
        Uri.parse('https://project2-e2k6.onrender.com/cert'),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: ({"name": name}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar("Success", "Certificate created");
        fetchCertificates();
        print(response.body);
      } else {
        Get.snackbar("Error", "Failed to create certificate $response.body ");
        print(response.body);
      }
    } catch (e) {
      print("Create cert error: $e");
      Get.snackbar("Error", "Exception occurred");
    }
  }

  Future<void> updateCertificate(int id, String name) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');
      if (token == null) throw Exception('Token is null');

      final response = await http.put(
        Uri.parse('https://project2-e2k6.onrender.com/cert'),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: ({
          "id": id.toString(),
          "name": name,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Certificate updated");
        fetchCertificates();

        print(response.body);
      } else {
        Get.snackbar("Error",
            "Failed to update certificate $response.statusCode $response.body");
        print(response.body);
      }
    } catch (e) {
      print("Update cert error: $e");
      Get.snackbar("Error", "Exception occurred");
    }
  }

  Future<void> createCertificateType(
      String name, int certId, int cityId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');
      if (token == null) throw Exception('Token is null');

      final response = await http.post(
        Uri.parse('https://project2-e2k6.onrender.com/certType'),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          "name": name,
          "certId": certId.toString(),
          "cityId": cityId.toString(),
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar("Success", "Certificate type created");
        fetchCertificates(); // reload
      } else {
        Get.snackbar("Error", "Failed to create type: ${response.body}");
      }
    } catch (e) {
      print("Create type error: $e");
      Get.snackbar("Error", "Exception occurred");
    }
  }

  Future<void> updateCertificateType(
      int id, String name, int certId, int cityId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth');
      if (token == null) throw Exception('Token is null');

      final response = await http.put(
        Uri.parse('https://project2-e2k6.onrender.com/certType'),
        headers: {
          "Authorization": token,
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          "id": id.toString(),
          "name": name,
          " CertId": certId.toString(),
          "cityId": cityId.toString(),
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Certificate type updated");
        fetchCertificates(); // reload
      } else {
        Get.snackbar("Error", "Failed to update type: ${response.body}");
      }
    } catch (e) {
      print("Update type error: $e");
      Get.snackbar("Error", "Exception occurred");
    }
  }
Future<void> addSubject({
  required String name,
  required int maxMark,
  required int minMark,
  required int certTypeId,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth');
    if (token == null) throw Exception('Token is null');

    final response = await http.post(
      Uri.parse('https://project2-e2k6.onrender.com/subject'),
      headers: {
        "Authorization": token,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'name': name,
        'maxMark': maxMark.toString(),
        'minMark': minMark.toString(),
        'certTypeId': certTypeId.toString(),
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar("Success", "Subject added");
      fetchCertificates(); // تحديث الشهادات بعد الإضافة
    } else {
      Get.snackbar("Error", "Failed to add subject");
      print(response.body);
    }
  } catch (e) {
    print("Add subject error: $e");
    Get.snackbar("Error", "Exception occurred while adding subject");
  }
}

Future<void> editSubject({
  required int id,
  String? name,
  int? maxMark,
  int? minMark,
}) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth');
    if (token == null) throw Exception('Token is null');

    final Map<String, String> body = {'id': id.toString()};
    if (name != null) body['name'] = name;
    if (maxMark != null) body['maxMark'] = maxMark.toString();
    if (minMark != null) body['minMark'] = minMark.toString();

    final response = await http.put(
      Uri.parse('https://project2-e2k6.onrender.com/subject'),
      headers: {
        "Authorization": token,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      Get.snackbar("Success", "Subject updated");
      fetchCertificates(); // تحديث الشهادات بعد التعديل
    } else {
      Get.snackbar("Error", "Failed to update subject");
      print(response.body);
    }
  } catch (e) {
    print("Edit subject error: $e");
    Get.snackbar("Error", "Exception occurred while editing subject");
  }
}

  @override
  void onInit() {
    super.onInit();
    fetchCertificates();
  }
}
