import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:girls_grivince/Login/Student/login.dart';
import 'package:girls_grivince/Login/Student/password.dart';
import 'package:girls_grivince/widgets/button.dart';
import 'package:girls_grivince/widgets/otheroptions.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool isResendEnabled = false;
  int resendCountdown = 60;
  Timer? resendTimer;
  bool isSending = false;
  String? emailError;
  String? usernameError;
  String? phoneError;

  void validateFields() {
    setState(() {
      emailError = emailController.text.isEmpty ? 'Enter Email' : null;
      usernameError = usernameController.text.isEmpty ? 'Enter name' : null;
      phoneError = phoneController.text.isEmpty ? 'Enter phone number' : null;
    });
  }

  Future<void> sendOtp(String email) async {
    final url = Uri.parse(
        "https://tech-hackathon-glowhive.onrender.com/api/user/send/otp/");
    try {
      final response = await http.post(
        url,
        body: jsonEncode({"email": email}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        showOtpDialog(email);
      } else {
        final data = jsonDecode(response.body);
        showSnackbar(data['message'] ?? "Email already exists.");
      }
    } catch (error) {
      showSnackbar("Failed to send OTP. Please try again later.");
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    setState(() {
      isSending = true;
    });
    final url = Uri.parse(
        "https://tech-hackathon-glowhive.onrender.com/api/user/verify/otp");
    try {
      final response = await http.post(
        url,
        body: jsonEncode({"email": email, "otp": otp}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Password(
              name: usernameController.text.trim(),
              email: email,
              phone: phoneController.text.trim(),
            ),
          ),
        );
      } else {
        final data = jsonDecode(response.body);
        showSnackbar(data['message'] ?? "Invalid OTP. Please try again.");
      }
    } catch (error) {
      showSnackbar("Failed to verify OTP. Please try again later.");
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showOtpDialog(String email) {
    final List<TextEditingController> otpControllers =
        List.generate(6, (index) => TextEditingController());
    final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Enter OTP"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => Expanded(
                  // Use Expanded to make each TextField take equal width
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4.0), // Add padding between the fields
                    child: TextField(
                      controller: otpControllers[index],
                      focusNode: focusNodes[index],
                      maxLength: 1,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: "",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index - 1]);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              String otp = otpControllers.map((e) => e.text).join();
              if (otp.length == 6) {
                verifyOtp(email, otp);
              } else {
                showSnackbar("Please enter a valid 6-digit OTP.");
              }
            },
            child: Text(isLoading ? 'Verifying..' : "Verify"),
          ),
        ],
      ),
    );
  }

  void validateAndSubmit() async {
    final List<String> errors = [];
    validateFields();
    // Validate username
    if (usernameController.text.trim().isEmpty) {
      errors.add('Name is required');
    }

    // Validate email
    final email = emailController.text.trim();
    if (email.isEmpty) {
      errors.add('Email is required');
    } else if (!RegExp(r"^[nsro]\d{6}@rguktn\.ac\.in$").hasMatch(email)) {
      errors.add('Enter a valid RGUKT email (e.g., n123456@rguktn.ac.in)');
      setState(() {
        emailError = 'Rgukt';
      });
    }

    // Validate phone number
    final phone = phoneController.text.trim();
    if (phone.isEmpty) {
      errors.add('Phone number is required');
    } else if (!RegExp(r"^\d{10}$").hasMatch(phone)) {
      errors.add('Enter a valid phone number');
      setState(() {
        phoneError ='Phone';
      });
    }

    if (errors.isNotEmpty) {
      // Show all errors in a Snackbar
      showSnackbar(errors.join('\n'));
      return;
    }

    setState(() {
      isLoading = true;
    });

    await sendOtp(email);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/img/head.png', fit: BoxFit.cover, width: double.infinity,),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30),
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 30),
                        TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: usernameError != null
                                    ? Colors.red
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: usernameError != null
                                    ? Colors.red
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            hintText: 'Username',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 25),
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
                        SizedBox(height: 25),
                        TextField(
                          keyboardType: TextInputType.number,
                          controller: phoneController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: phoneError != null
                                    ? Colors.red
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: phoneError != null
                                    ? Colors.red
                                    : Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            hintText: 'Mobile Number',
                            prefixIcon: Icon(Icons.call),
                          ),
                        ),
                        SizedBox(height: 30),
                        Button(
                          text: isLoading ? 'Loading..' : 'Next',
                          function: validateAndSubmit,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Otheroptions(
                          text1: 'Already have an account? ',
                          text2: 'Log In',
                          function: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
