import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Userreport extends StatefulWidget {
  final String name;
  const Userreport({super.key, required this.name});

  @override
  _UserreportState createState() => _UserreportState();
}

class _UserreportState extends State<Userreport> {
  bool isEvent = false;
  String? selectedLocation;
  DateTime? eventDate;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _statementController = TextEditingController();

  final List<String> areas = [
    "MVP Colony",
    "Gajuwaka",
    "Dwaraka Nagar",
    "RK Beach",
    "Seethammadhara",
    "Kailasagiri",
    "Arilova",
    "Pendurthi",
    "Bheemunipatnam",
    "Anakapalle",
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        eventDate = pickedDate;
      });
    }
  }

  Future<String?> getToken () async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _sendReportApi(String location, String statement,
      String description, String name) async {
        final token = await getToken();
    final url = Uri.parse('https://gvmc-1.onrender.com/api/userRequest/create');
    final body = {
      "userLocation": location,
      "requestStatement": statement,
      "requestDescription": description,
      "createdBy": name,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "origin": 'http://localhost:8080',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );
      print(response.body);
      if (response.statusCode == 200) {
        showSnackbar('Report submitted successfully!', Colors.green);
        setState(() {
          isEvent = false;
        });
      } else {
        showSnackbar('Failed to submit report. Please try again.', Colors.red);
      }
    } catch (e) {
      showSnackbar(
          'An error occurred. Please check your connection.', Colors.red);
    }
  }

  void showSnackbar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _submitReport() {
    if (_formKey.currentState?.validate() ?? false) {
      final String description = _descriptionController.text;
      final String statement = _statementController.text;
      final String date = eventDate?.toLocal().toString().split(' ')[0] ?? '';
      final String location = selectedLocation ?? '';

      _sendReportApi(location, statement, description, widget.name);

      setState(() {
        isEvent = false;
        selectedLocation = null;
        eventDate = null;
        _descriptionController.clear();
        _statementController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Report"),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      backgroundColor: const Color(0xFFEAFBF1),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Is there an event?",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      SwitchListTile(
                        title: Text(isEvent ? "Yes" : "No"),
                        value: isEvent,
                        onChanged: (bool value) {
                          setState(() {
                            isEvent = value;
                          });
                        },
                        activeColor: const Color(0xFF4CAF50),
                      ),
                      if (isEvent) ...[
                        const SizedBox(height: 20),
                        const Text(
                          "Statement",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _statementController,
                          decoration: InputDecoration(
                            hintText: "Enter event statement",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a statement";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Event Description",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            hintText: "Enter event description",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a description";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Event Date",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              eventDate == null
                                  ? "Select Date"
                                  : eventDate!
                                      .toLocal()
                                      .toString()
                                      .split(' ')[0],
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black87),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Event Location",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: selectedLocation,
                          hint: const Text("Select Location"),
                          items: areas.map((String area) {
                            return DropdownMenuItem<String>(
                              value: area,
                              child: Text(area),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedLocation = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select a location";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: _submitReport,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text("Submit Report",
                                style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
