import 'package:flutter/material.dart';
import 'package:girls_grivince/Home/StudentHome/home.dart';
import 'package:girls_grivince/Login/Student/ForgetPassord/forgetPassword.dart';
import 'package:girls_grivince/Login/Student/signup.dart';
import 'package:girls_grivince/Models/UserModel/UserProvider.dart';
import 'package:girls_grivince/Models/UserModel/user.dart';
import 'package:girls_grivince/widgets/otheroptions.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isPasswordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  String? emailError;
  String? passwordError;

  void validateFields() {
    setState(() {
      emailError = emailController.text.isEmpty ? 'Enter username' : null;
      passwordError = passwordController.text.isEmpty ? 'Enter password' : null;
    });
  }

  // Function to store token
  Future<void> storeToken(String token, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('role', role);
  }

  // Function to validate email
  bool isValidEmail(String email) {
    final rguktRegex = RegExp(r"^[nsro]\d{6}@rguktn\.ac\.in$");
    return rguktRegex.hasMatch(email);
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
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    validateFields();
    if (email.isEmpty || password.isEmpty) {
      showSnackbar("Email and Password cannot be empty.");
      return;
    }

    if (!isValidEmail(email)) {
      showSnackbar("Please use a valid RGUKT email.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse(
        'https://tech-hackathon-glowhive.onrender.com/api/user/login');
    final body = {
      "email": email,
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

        if (data['user'] != null && data['token'] != null) {
          await storeToken(data['token'], data['role']);


          final userJson = data['user'];

          // Parse user data and store it in UserProvider
          User user = User.fromJson(userJson);
          Provider.of<UserProvider>(context, listen: false).setUser(user);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Home(),
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
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Image.asset('assets/img/head.png', fit: BoxFit.cover,width: double.infinity,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 30, 123, 179),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: emailError != null
                                    ? Colors.red
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: emailError != null
                                    ? Colors.red
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: passwordError != null
                                    ? Colors.red
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: passwordError != null
                                    ? Colors.red
                                    : Colors.grey,
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
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (builder) => ForgetPassword(),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color.fromARGB(255, 30, 123, 179),
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 30, 123, 179),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Center(
                            child: Text(
                              isLoading ? 'Loading...' : 'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text('Or'),
                            ),
                            Expanded(child: Divider()),
                          ],
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/img/google_logo.png',
                                height: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Continue with Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Otheroptions(
                          text1: 'Don\'t have an account? ',
                          text2: 'Sign Up',
                          function: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Signup(),
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
          ),
        ),
      );
    });
  }
}
