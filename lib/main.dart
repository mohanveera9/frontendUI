import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:girls_grivince/Home/FacultyHome/facultyHome.dart';
import 'package:girls_grivince/Home/StudentHome/home.dart';
import 'package:girls_grivince/Login/loginMain.dart';
import 'package:girls_grivince/Models/DataProvider.dart';
import 'package:girls_grivince/Models/UserModel.dart';
import 'package:girls_grivince/Models/UserModel/UserProvider.dart';
import 'package:girls_grivince/Models/UserModel/user.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => DataProvider()),
      ChangeNotifierProvider(create: (context) => UserModel()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        primaryColor: Colors.purple,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashHandler(), // Splash logic handler
    );
  }
}

class SplashHandler extends StatefulWidget {
  const SplashHandler({super.key});

  @override
  State<SplashHandler> createState() => _SplashHandlerState();
}

class _SplashHandlerState extends State<SplashHandler> {
  @override
  void initState() {
    super.initState();
    _showSplash();
  }

  Future<void> _showSplash() async {
    // Show splash screen for a minimum of 2 seconds
    await Future.delayed(Duration(seconds: 2));

    // Proceed with checking the token and navigation after the delay
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    try {
      String? token = await _getToken();
      String? facultyToken = await _getFacultyToken();

      if (token == null && facultyToken == null) {
        _navigateToLogin();
        return;
      }

      if (facultyToken == null) {
        final response = await http.get(
          Uri.parse('https://tech-hackathon-glowhive.onrender.com/api/user/'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final userJson = data['user'];

          // Parse user data and store it in UserProvider
          User user = User.fromJson(userJson);
          Provider.of<UserProvider>(context, listen: false).setUser(user);

          _navigateToHome();
        } else {
          _navigateToLogin();
        }
      } else {
        final response = await http.get(
          Uri.parse(
              'https://tech-hackathon-glowhive.onrender.com/api/support/login'),
          headers: {
            'Authorization': 'Bearer $facultyToken',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final facultyJson = data['user'];
          final name = facultyJson['name'];
          final phone = facultyJson['phno'];
          final position = facultyJson['position'];
          final fId = facultyJson['_id'];

          _navigateToFacultyHome(
            name,
            position,
            phone,
            fId,
          );
        } else {
          _navigateToLogin();
        }
      }
    } catch (e) {
      print('Error verifying token: $e');
      _navigateToLogin();
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<String?> _getFacultyToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token_faculty');
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Loginmain()),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  void _navigateToFacultyHome(
      String name, String position, String phone, String fId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Facultyhome(
          name: name,
          position: position,
          phone: phone,
          fId: fId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6BF3DD), // Start color
              Color(0xFF39D0D1), // Midpoint color
              Color(0xFF0C3F9E), // End color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Image.asset('assets/img/mainicon.png'),
        ),
      ),
    );
  }
}
