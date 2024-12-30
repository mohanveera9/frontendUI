import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:girls_grivince/widgets/button.dart';
import 'package:http/http.dart' as http;

class Step3 extends StatefulWidget {
  final String email;
  final VoidCallback onNext;

  const Step3({super.key, required this.email, required this.onNext});

  @override
  State<Step3> createState() => _Step3State();
}

class _Step3State extends State<Step3> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool isConfirmPasswordVisible = false;
  bool isPasswordVisible = false;
  String? passwordError;
  String? confirmPasswordError;

  void validateFields() {
    setState(() {
      passwordError = passwordController.text.isEmpty
          ? 'Please enter a new password'
          : null;
      confirmPasswordError = confirmPasswordController.text.isEmpty
          ? 'Please confirm your password'
          : null;

      if (passwordError == null &&
          confirmPasswordError == null &&
          passwordController.text != confirmPasswordController.text) {
        confirmPasswordError = 'Passwords do not match';
      }
    });
  }

  void showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> resetPassword() async {
    validateFields();

    if (passwordError != null || confirmPasswordError != null) {
      showSnackbar('Please fix the errors above', Colors.red);
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        'https://tech-hackathon-glowhive.onrender.com/api/user/reset/password');
    final body = {
      "email": widget.email, // Use email passed from Step2
      "password": passwordController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        showSnackbar('Password reset successfully!', Colors.green);
        widget.onNext(); // Proceed to the next step
      } else {
        final responseBody = json.decode(response.body);
        showSnackbar(
            responseBody['message'] ?? 'Failed to reset password', Colors.red);
      }
    } catch (e) {
      showSnackbar('Check your internet connection', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Step 3: Set Password",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextField(
                    obscureText: !isPasswordVisible,
                    controller: passwordController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: passwordError != null
                              ? Colors.red
                              : Colors.grey,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: passwordError != null
                              ? Colors.red
                              : Colors.grey,
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
                          color: Color.fromARGB(255,30,123,179),
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
                          color: Color.fromARGB(255,30,123,179),
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
        const SizedBox(height: 30),
        Button(
          text: isLoading ? 'Resetting...' : 'Confirm',
          function: () {
            resetPassword();
          },
        ),
      ],
    );
  }
}
