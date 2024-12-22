import 'package:flutter/material.dart';
import 'package:hackwave/pages/Users/userhome.dart';

class UserFeedbackPage extends StatefulWidget {
  @override
  _UserFeedbackPageState createState() => _UserFeedbackPageState();
}

class _UserFeedbackPageState extends State<UserFeedbackPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _feedbackController = TextEditingController();

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

  int selectedStars = 0; // Star rating

  void _submitFeedback() {
    if (_formKey.currentState?.validate() ?? false) {
      final String location = selectedLocation ?? '';
      final String feedback = _feedbackController.text;

      // Simulate sending data to backend
      print("Feedback Location: $location");
      print("Stars: $selectedStars");
      print("Feedback Description: $feedback");

      // Show a confirmation dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Feedback Submitted"),
            content: Text(
              "Your feedback has been submitted for location: $location.\n"
              "Stars: $selectedStars\nDescription: $feedback",
            ),
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
        selectedStars = 0;
        _feedbackController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Feedback"),
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
                  "Rate Your Experience (Out of 5 Stars)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(5, (index) {
                    return IconButton(
                      onPressed: () {
                        setState(() {
                          selectedStars = index + 1;
                        });
                      },
                      icon: Icon(
                        Icons.star,
                        color:
                            index < selectedStars ? Colors.orange : Colors.grey,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Feedback Description",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _feedbackController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Enter your feedback here...",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a feedback description";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitFeedback,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Submit Feedback",
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
