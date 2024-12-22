import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // Mock data for feedback
  List<Map<String, dynamic>> feedbacks = [
  {
    "area": "MVP Colony",
    "supervisor": "manoj",
    "rating": 4.5,
    "description": "The supervisor is very responsive and handles complaints efficiently."
  },
  {
    "area": "Gajuwaka",
    "supervisor": "mohan",
    "rating": 3.0,
    "description": "The supervisor is good but often delays responding to complaints."
  },
  {
    "area": "Dwaraka Nagar",
    "supervisor": "sneha",
    "rating": 5.0,
    "description": "Excellent supervisor. Very efficient and punctual."
  },
  {
    "area": "RK Beach",
    "supervisor": "farhana",
    "rating": 2.5,
    "description": "Needs improvement in communication and timely action."
  },
  {
    "area": "Seethammadhara",
    "supervisor": "rahul",
    "rating": 4.0,
    "description": "Good supervisor with minor issues in coordinating tasks."
  },
  {
    "area": "Kailasagiri",
    "supervisor": "geeta",
    "rating": 3.5,
    "description": "Average performance but is willing to improve."
  },
  {
    "area": "Arilova",
    "supervisor": "priya",
    "rating": 4.8,
    "description": "Highly professional and responsive supervisor."
  },
  {
    "area": "Pendurthi",
    "supervisor": "arun",
    "rating": 2.0,
    "description": "Fails to address complaints and lacks proper communication skills."
  },
  {
    "area": "Bheemunipatnam",
    "supervisor": "divya",
    "rating": 4.3,
    "description": "A reliable supervisor with a good track record."
  },
  {
    "area": "Anakapalle",
    "supervisor": "vishal",
    "rating": 3.8,
    "description": "Overall good but needs improvement in timely follow-ups."
  },
];

  // Function to show popup dialog with detailed feedback
  void _showFeedbackDialog(Map<String, dynamic> feedback) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Feedback Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            feedback["description"]!,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
        title: const Text("Feedback"),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      backgroundColor: const Color(0xFFEAFBF1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: feedbacks.isEmpty
            ? const Center(
                child: Text(
                  "No feedback available.",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: feedbacks.length,
                itemBuilder: (context, index) {
                  final feedback = feedbacks[index];
                  return GestureDetector(
                    onTap: () {
                      // Show the popup dialog with feedback details
                      _showFeedbackDialog(feedback);
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
                            "Area: ${feedback['area']}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Supervisor: ${feedback['supervisor']}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text(
                                "Rating: ",
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                              ...List.generate(5, (starIndex) {
                                return Icon(
                                  starIndex < feedback['rating'].floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: const Color(0xFFFFD700),
                                  size: 20,
                                );
                              }),
                            ],
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
