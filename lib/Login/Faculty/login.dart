import 'package:flutter/material.dart';
import 'package:girls_grivince/Home/FacultyHome/facultyHome.dart';
import 'package:girls_grivince/widgets/button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FLogin extends StatefulWidget {
  @override
  _FLoginState createState() => _FLoginState();
}

class _FLoginState extends State<FLogin> {
  bool isPasswordVisible = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String? phoneError;
  String? passwordError;

  void validateFields() {
    setState(() {
      phoneError = phoneController.text.isEmpty ? 'Enter username' : null;
      passwordError = passwordController.text.isEmpty ? 'Enter password' : null;
    });
  }

  // Function to store token
  Future<void> storeToken(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token_faculty', token);
    await prefs.setString('role', role);
  }

  // Function to validate mobile number
  bool isValidMobile(String mobile) {
    final mobileRegex = RegExp(r"^\d{10}");
    return mobileRegex.hasMatch(mobile);
  }

  // Function to display Snackbar
  void showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> loginUser() async {
    final mobile = phoneController.text.trim();
    final password = passwordController.text.trim();

    validateFields();

    if (mobile.isEmpty || password.isEmpty) {
      showSnackbar("Mobile number and Password cannot be empty.");
      return;
    }

    if (!isValidMobile(mobile)) {
      showSnackbar("Please enter a valid 10-digit mobile number.");
      setState(() {
        phoneError = 'm';
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        'https://tech-hackathon-glowhive.onrender.com/api/support/login');
    final body = {
      "phno": mobile,
      "password": password,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "origin": 'http://localhost:8080',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['faculty'] != null && data['token'] != null) {
          await storeToken(data['token'], data['role']);
          final faculty = data['faculty'];
          final name = faculty['name'];
          final phone = faculty['phno'];
          final position = faculty['position'];
          final fId = faculty['_id'];

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Facultyhome(
                name: name,
                phone: phone,
                position: position,
                fId: fId,
              ),
            ),
          );
        } else {
          showSnackbar("Unexpected response format. Please try again.");
        }
      } else {
        showSnackbar("Login failed. Enter valid credentials");
      }
    } catch (e) {
      print("Error: \$e");
      showSnackbar("An error occurred. Check your connection and try again.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/img/head.png'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Faculty Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: phoneError != null ? Colors.red : Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: phoneError != null ? Colors.red : Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      hintText: 'Mobile Number',
                      prefixIcon: Icon(Icons.call),
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color:
                              passwordError != null ? Colors.red : Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color:
                              passwordError != null ? Colors.red : Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color.fromARGB(255, 30, 123, 179),
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Button(
                    text: isLoading ? 'Loading...' : 'Login',
                    function: () {
                      loginUser();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
