import 'package:flutter/material.dart';

class ComplaintsPage extends StatefulWidget {
  @override
  _ComplaintsPageState createState() => _ComplaintsPageState();
}

class _ComplaintsPageState extends State<ComplaintsPage> {
  // Mock data for complaints
  List<Map<String, String>> complaints = [
    {
      "area": "Area 1",
      "supervisor": "John Doe",
      "date": "2024-12-20",
      "description": "The supervisor is not responsive and does not follow up on complaints."
    },
    {
      "area": "Area 2",
      "supervisor": "Jane Smith",
      "date": "2024-12-18",
      "description": "Supervisor is frequently absent and work is delayed."
    },
    {
      "area": "Area 3",
      "supervisor": "Mike Johnson",
      "date": "2024-12-15",
      "description": "Improper waste management in the area for the past week."
    },
  ];

  // Function to show the popup dialog
  void _showComplaintDialog(Map<String, String> complaint, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Complaint Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            complaint["description"]!,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Ignore action
                setState(() {
                  complaints.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "Ignore",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                // Accept action
                setState(() {
                  complaints.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "Accept",
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complaints"),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      backgroundColor: const Color(0xFFEAFBF1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: complaints.isEmpty
            ? const Center(
                child: Text(
                  "No complaints available.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  final complaint = complaints[index];
                  return GestureDetector(
                    onTap: () {
                      // Show the popup dialog with details
                      _showComplaintDialog(complaint, index);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Area: ${complaint['area']}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Supervisor: ${complaint['supervisor']}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Date: ${complaint['date']}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
