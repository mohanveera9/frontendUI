import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hackwave/pages/Supervisor/notifications.dart';
import 'package:hackwave/widgets/Bottom.dart';
import 'package:hackwave/widgets/button.dart';
import 'package:http/http.dart' as http;

class Supervisor extends StatefulWidget {
  final String name;
  const Supervisor({super.key, required this.name});

  @override
  State<Supervisor> createState() => _SupervisorState();
}

class _SupervisorState extends State<Supervisor> {
  String? assignedLocation; // Variable to store the selected location
  bool isLoading = false;
  final TextEditingController usernameController = TextEditingController();

  static const Map<String, String> locations = {
    "MVP Colony": "manoj",
    "Gajuwaka": "mohan",
    "Dwaraka Nagar": "sneha",
    "RK Beach": "farhana",
    "Seethammadhara": "rahul",
    "Kailasagiri": "geeta",
    "Arilova": "priya",
    "Pendurthi": "arun",
    "Bheemunipatnam": "divya",
    "Anakapalle": "vishal",
  };

  @override
  void initState() {
    super.initState();
    // Retrieve the location based on the name and store it in assignedLocation
    assignedLocation = locations.entries
        .firstWhere(
          (entry) => entry.value == widget.name,
          orElse: () => MapEntry('', ''),
        )
        .key;

    if (assignedLocation != null && assignedLocation!.isNotEmpty) {
      // Print the assigned location to the debug console
      debugPrint('Assigned Location: $assignedLocation');
    } else {
      debugPrint('No location assigned for the user: ${widget.name}');
    }
  }

  Future<void> _SendSupervisorApi(String location, int percentage) async {
    setState(() {
      isLoading = true;
    });
    final url = Uri.parse('https://gvmc-1.onrender.com/api/supervisor/submit');
    final body = {
      "loc_name": location,
      "lastReportedDate" : '2024-12-20',
      "currentPercentWaste": percentage,
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
      if (response.statusCode == 201) {
        showSnackbar('Submit successfully!', Colors.green);
        usernameController.clear();
      }else{
        showSnackbar('Error occured', Colors.red);
      }
    } catch (e) {
      showSnackbar('Check your interent conection', Colors.red);
    }finally{
      setState(() {
        isLoading=false;
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
      body: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF4CAF50),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (builder) => Notifications(name: widget.name,location: assignedLocation!,),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
            title: const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Supervisor',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Report daily waste percentage',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                Text(
                  'Assigned Location: $assignedLocation', // Display the assigned location
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Waste Percentage (1-100)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Button(text:isLoading ? 'Submit...': 'Submit', funtion: () {
                  _SendSupervisorApi(assignedLocation!, usernameController as int);
                }),
              ],
            ),
          ),
          const Spacer(),
          Bottom(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
