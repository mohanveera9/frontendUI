import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:girls_grivince/widgets/button.dart';
import 'package:http/http.dart' as http;

class Soscontacts extends StatefulWidget {
  @override
  _SoscontactsState createState() => _SoscontactsState();
}

class _SoscontactsState extends State<Soscontacts> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  List<dynamic> globalSOS = [];
  bool isLoading = true;
  String? emailError;
  String? phoneError;
  String? usernameError;

  @override
  void initState() {
    super.initState();
    fetchSOSData();
  }

  void fetchSOSData() async {
    // Try fetching API data
    try {
      final response = await http.get(
        Uri.parse('https://tech-hackathon-glowhive.onrender.com/api/sos/user'),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          globalSOS = data['sos'] ?? [];
        });
      } else {
        print('Failed to fetch SOS data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching API data: $e');
    } finally {
      setState(() {
        isLoading = false; // Data loading complete
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with Back Button
          _buildHeader(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddContactSheet();
        },
        backgroundColor: Color.fromARGB(255, 30, 123, 179),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
          'Add Contact',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 153,
          child: SvgPicture.asset(
            'assets/img/header1.svg',
            height: 153,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 50,
          left: 20,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  'assets/img/arrow2.png',
                  width: 41,
                  height: 33,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'SOS Contacts',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddContactSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 7,
                width: 80,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: usernameError != null ? Colors.red : Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: usernameError != null ? Colors.red : Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  hintText: 'Username',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: emailError != null ? Colors.red : Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: emailError != null ? Colors.red : Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              SizedBox(height: 15),
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
              SizedBox(height: 20),
              Button(
                text: 'Confirm',
                function: () {},
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        );
      },
    );
  }
}
