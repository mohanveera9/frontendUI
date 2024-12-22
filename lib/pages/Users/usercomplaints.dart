import 'package:flutter/material.dart';
import 'package:hackwave/pages/Users/userhome.dart';

class UserComplaintsPage extends StatefulWidget {
  @override
  _UserComplaintsPageState createState() => _UserComplaintsPageState();
}

class _UserComplaintsPageState extends State<UserComplaintsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _complaintController = TextEditingController();

  String? selectedLocation; // Selected location
  final List<String> locations = [
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

  void _submitComplaint() {
    if (_formKey.currentState?.validate() ?? false) {
      final String location = selectedLocation ?? '';
      final String complaint = _complaintController.text;

      // Simulate sending data to backend
      print("Complaint Location: $location");
      print("Complaint Description: $complaint");

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Complaint Submitted"),
            content: Text(
                "Your complaint has been submitted for location: $location.\nDescription: $complaint"),
            actions: [
              TextButton(
                onPressed: () => {Navigator.pop(context)},
                child: const Text("Close"),
              ),
            ],
          );
        },
      );

      // Clear the form
      setState(() {
        selectedLocation = null;
        _complaintController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit a Complaint"),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      backgroundColor: const Color(0xFFEAFBF1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Location",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedLocation,
                  hint: const Text("Select Location"),
                  items: locations.map((String area) {
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
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Complaint Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _complaintController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Enter your complaint here...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a complaint description";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitComplaint,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Submit Complaint",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
