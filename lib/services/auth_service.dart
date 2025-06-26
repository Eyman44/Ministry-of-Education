import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/global.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
      String username, String password) async {
    final url = Uri.parse('${Global.baseUrl}/dataEntry/login');
    final response = await http.post(url, headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    }, body: {
      'username': username,
      'password': password,
    });
    late var token1;
    var response1 = jsonDecode(response.body);
    if (response.statusCode == 200) {
      token1 = response1["token"];
      final decoded = jsonDecode(response.body);
      final userData = decoded['data'];
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('auth', token1);

      return {
        'token': token1,
        'isAdmin': userData['isAdmin'] ?? false,
      };
    } else {
      throw Exception('Login failed');
    }
  }

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    Global.token = prefs.getString('auth') ?? '';
  }
}
