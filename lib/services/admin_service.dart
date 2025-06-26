// // services/admin_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/year_model.dart';
// import '../utils/global.dart';

// class AdminService {
//   final String _baseUrl = Global.baseUrl;
//   final String _token = Global.token;

//   Future<List<YearModel>> fetchYears() async {
//     final url = Uri.parse('$_baseUrl/admin/years');

//     final res = await http.get(
//       url,
//       // headers: {
//       //   //'Authorization': _token,
//       //   'Content-Type': 'application/json',
//       // },
//     );

//     if (res.statusCode == 200) {
//       final List data = jsonDecode(res.body)['data'];
//       return data.map((e) => YearModel.fromJson(e)).toList();
//       print(
//           "Successsssssssss--------------------------------------------------");
//       print("$data");
//     } else {
//       throw Exception('Failed to load years: ${res.body}');
//     }
//   }

//   Future<void> addCertificate(String name) async {
//     final url = Uri.parse('$_baseUrl/cert');

//     final response = await http.post(
//       url,
//       headers: {
//         //'Content-Type': 'application/json',
//         'Authorization': _token,
//       },
//       body: jsonEncode({'name': name}),
//     );

//     if (response.statusCode == 200) {
//       print(response.body);
//     } else {
//       print('Failed to add certificate: ${response.body}');
//     }
//   }
// }
