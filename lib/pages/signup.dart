import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackwave/pages/login.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  String? usernameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  void validateFields() {
    setState(() {
      usernameError =
          usernameController.text.isEmpty ? 'Enter a valid username' : null;

      emailError = emailController.text.isEmpty
          ? 'Enter a valid email'
          : !RegExp(r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                  .hasMatch(emailController.text)
              ? 'Enter a valid email'
              : null;

      passwordError = passwordController.text.isEmpty
          ? 'Enter a password'
          : passwordController.text.length < 6
              ? 'Password must be at least 6 characters'
              : null;

      confirmPasswordError = confirmPasswordController.text.isEmpty
          ? 'Confirm your password'
          : confirmPasswordController.text != passwordController.text
              ? 'Passwords do not match'
              : null;
    });
  }

  Future<void> _SendSignUpApi(
    String name,
    String email,
    String password,
  ) async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('https://gvmc.onrender.com/api/auth/signup');
    final body = {
      "username": name,
      "email": email,
      "password": password,
      "role": 'user',
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
      print(response.body);
      if (response.statusCode == 201) {
        setState(() {
          isLoading = false;
        });
        showSnackbar('Sign-up successful!', Colors.green);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (builder) => LoginPage(),
          ),
        );
      } else {
        showSnackbar("Sign Up failed. Enter valid username", Colors.red);
      }
    } catch (e) {
      showSnackbar(
        "An error occurred. Check your connection and try again.",
        Colors.red,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAFBF1),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/recycle.png',
                      height: 100,
                      width: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'USER SIGN UP',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Username Field
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: usernameError ?? 'Username',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: usernameError != null
                                ? Colors.red
                                : Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: usernameError != null
                                ? Colors.red
                                : Colors.green,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email Field
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: emailError ?? 'Email',
                        labelStyle:const TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color:
                                emailError != null ? Colors.red : Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color:
                                emailError != null ? Colors.red : Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: passwordError ?? 'Password',
                        labelStyle:const TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: passwordError != null
                                ? Colors.red
                                : Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: passwordError != null
                                ? Colors.red
                                : Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password Field
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: confirmPasswordError ?? 'Confirm Password',
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: confirmPasswordError != null
                                ? Colors.red
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: confirmPasswordError != null
                                ? Colors.red
                                : Colors.grey,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: confirmPasswordError != null
                                ? Colors.red
                                : Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Sign Up Button
                    ElevatedButton(
                      onPressed: () {
                        validateFields();
                        if (usernameError == null &&
                            emailError == null &&
                            passwordError == null &&
                            confirmPasswordError == null) {
                          // Perform sign-up logic
                          _SendSignUpApi(usernameController.text,
                              emailController.text, passwordController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        isLoading ? ' Signup..' : ' Sign Up',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Login Link
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (builder) => LoginPage(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}