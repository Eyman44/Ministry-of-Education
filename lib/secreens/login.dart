import 'package:flutter/material.dart';
import 'package:flutter_application_eyman/constant/color.dart';
import 'package:flutter_application_eyman/constant/image.dart';
import 'package:flutter_application_eyman/secreens/minister_page.dart';
import 'package:flutter_application_eyman/services/auth_service.dart';
import 'package:flutter_application_eyman/utils/global.dart';
import 'data_entry_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
   final _usernameController = TextEditingController(text: "dataEntry1");
   final _passwordController = TextEditingController(text: "password");
  //final _usernameController = TextEditingController(text: "admin");
  //final _passwordController = TextEditingController(text: "admin");
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
              child: Opacity(
            opacity: 0.5,
            child: Image.asset(
              AppImageAsset.s,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          )),
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: 400,
                  decoration: BoxDecoration(
                    color: AppColor.backgroundcolor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length < 5 || value.length > 25) {
                            return 'Password must be between 8 and 25 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.orange,
                            minimumSize: const Size(200, 50),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final result = await AuthService.login(
                                  _usernameController.text.trim(),
                                  _passwordController.text.trim(),
                                );

                                Global.token = result['token'];
                                Global.isAdmin = result['isAdmin'] ?? false;

                                print('  Global.token: ${Global.token}');

                                if (Global.isAdmin) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                           CertificateDashboard()),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const DataEntryPage()),
                                  );
                                }
                              } catch (e) {
                                print("Login error: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Login error: $e')),
                                );
                              }
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
