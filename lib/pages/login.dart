import 'package:flutter/material.dart';
import 'package:hackwave/pages/Users/userhome.dart';
import 'package:hackwave/pages/signup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hackwave/pages/Admin/AdminHome.dart';
import 'package:hackwave/pages/Supervisor/supervisor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String selectedRole = 'User';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  String? usernameError;
  String? passwordError;

  void validateFields() {
    setState(() {
      usernameError = usernameController.text.isEmpty ? 'Enter username' : null;
      passwordError = passwordController.text.isEmpty ? 'Enter password' : null;
    });
  }

   Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _SendLoginApi(String name, String password) async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('https://gvmc.onrender.com/api/auth/login');
    final body = {
      "username": name,
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
      print(response.body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['token'] != null && data['role'] != null) {
          await storeToken(data['token']);
          final role = data['role'];
          final username = data['username'];
           if (role == 'admin') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Adminhome(name: username,), // Replace with your Admin page widget
            ),
          );
        } else if (role == 'supervisor') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Supervisor(name: username,), // Replace with your Supervisor page widget
            ),
          );
        } else if (role == 'user') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Userhome(name: username,), // Replace with your User page widget
            ),
          );
        } else {
          showSnackbar("Unknown role. Please contact support.");
        }
        }
        else {
          showSnackbar("Unexpected response format. Please try again.");
        }
      }else {
        showSnackbar("Login failed. Enter valid credentials");
      }
    } catch (e) {
      showSnackbar("An error occurred. Check your connection and try again.");
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  void showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
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
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(height: 30),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Role',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      items: ['User', 'Supervisor', 'Admin']
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    // Username Field
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: usernameError ?? 'Username',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: usernameError != null
                                ? Colors.red
                                : Colors.grey,
                            width: 2.0,
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
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password Field
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: passwordError ?? 'Password',
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: passwordError != null
                                ? Colors.red
                                : Colors.grey,
                          ),
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
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        validateFields();
                        if (usernameError == null && passwordError == null) {
                          _SendLoginApi(usernameController.text, passwordController.text);
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
                        isLoading ? 'Login..' : 'Login',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (builder) => SignupPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register as New User',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4CAF50),
                          decoration: TextDecoration.underline,
                        ),
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