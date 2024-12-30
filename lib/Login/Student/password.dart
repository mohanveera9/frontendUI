import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:girls_grivince/Models/UserModel/UserProvider.dart';
import 'package:girls_grivince/Models/UserModel/user.dart';
import 'package:http/http.dart' as http;
import 'package:girls_grivince/Home/StudentHome/home.dart';
import 'package:girls_grivince/Login/Student/login.dart';
import 'package:girls_grivince/widgets/button.dart';
import 'package:girls_grivince/widgets/otheroptions.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Password extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  const Password({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<Password> createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;
  String? confirmPasswordError;
  String? passwordError;
  String? phoneError;

  Future<void> storeToken(String token, String role)async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('role', role);
  }

  String extractCollegeId(String email) {
    return email.substring(0, 7); // First 7 characters of the email
  }

  void validateFields() {
    setState(() {
      passwordError = passwordController.text.isEmpty ? 'Enter Password' : null;
      confirmPasswordError = confirmPasswordController.text.isEmpty
          ? 'Enter confirm password'
          : null;
      phoneError = phoneController.text.isEmpty ? 'Enter phone number' : null;
    });
  }

  Future<void> registerUser({
    required String username,
    required String email,
    required String phno,
    required String password,
    required String primartPhone,
  }) async {
    final url = Uri.parse(
        'https://tech-hackathon-glowhive.onrender.com/api/user/register');

    final collegeId = extractCollegeId(email);

    final body = {
      "username": username,
      "collegeId": collegeId,
      "phno": phno,
      "email": email,
      "password": password,
      "primary_sos": primartPhone
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "origin": 'http:\\localhost:8080'
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );
        final data = json.decode(response.body);
        await storeToken(data['token'], data['role']);

        final userJson = data['user'];

        // Parse user data and store it in UserProvider
        User user = User.fromJson(userJson);
        Provider.of<UserProvider>(context, listen: false).setUser(user);

        // Store the token in SharedPreferences
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      } else {
        final responseBody = jsonDecode(response.body);
        final errorMessage = responseBody['message'] ?? 'Registration failed.';
        throw Exception(errorMessage);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/img/head.png', fit: BoxFit.cover,width: double.infinity,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    obscureText: !isPasswordVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color:
                              passwordError != null ? Colors.red : Colors.grey,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color:
                              passwordError != null ? Colors.red : Colors.grey,
                          width: 2,
                        ),
                      ),
                      hintText: 'Enter password',
                      prefixIcon: const Icon(Icons.lock),
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
                  SizedBox(height: 25),
                  TextField(
                    obscureText: !isConfirmPasswordVisible,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: confirmPasswordError != null
                              ? Colors.red
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: confirmPasswordError != null
                              ? Colors.red
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      hintText: 'Confirm password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color.fromARGB(255, 30, 123, 179),
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Primary Number:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Primary Number'),
                              content: Text(
                                'The primary number is the phone number that will be used for important communications, including SOS alerts.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
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
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: phoneError != null ? Colors.red : Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      hintText: 'Mobile Number',
                      prefixIcon: Icon(Icons.call),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Confirm Button
                  Button(
                    text: isLoading ? 'Loading...' : 'Confirm',
                    function: () async {
                      if (isLoading) return;

                      setState(() {
                        isLoading = true;
                      });

                      try {
                        final username = widget.name;
                        final email = widget.email;
                        final phno = widget.phone;
                        final password = passwordController.text;
                        final confirmPassword = confirmPasswordController.text;

                        validateFields(); // Validate fields before proceeding

                        if (password.isEmpty || confirmPassword.isEmpty) {
                          throw Exception('Please fill in all fields.');
                        }
                        if (password != confirmPassword) {
                          throw Exception('Passwords do not match.');
                        }

                        await registerUser(
                            username: username,
                            email: email,
                            phno: phno,
                            password: password,
                            primartPhone: phoneController.text);
                      } catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                  ),

                  SizedBox(height: 20),

                  // Other Options
                  Otheroptions(
                    text1: 'Already have an account? ',
                    text2: 'Log In',
                    function: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (builder) => Login(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
