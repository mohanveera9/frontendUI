import 'package:flutter/material.dart';
import 'package:hackwave/pages/Admin/AdminDashboard.dart';
import 'package:hackwave/pages/Admin/AdminComplaints.dart';
import 'package:hackwave/pages/Admin/Adminfeedback.dart';
import 'package:hackwave/widgets/Bottom.dart';

class Adminhome extends StatefulWidget {
  final String name;
  const Adminhome({super.key, required this.name});
  @override
  _AdminhomeState createState() => _AdminhomeState();
}

class _AdminhomeState extends State<Adminhome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        backgroundColor: const Color(0xFF4CAF50),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 30.0),
          )
        ],
        title: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Admin Home',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFEAFBF1),
      body: Column(
        children: [
          const SizedBox(height: 30),
          // Containers Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Dashboard Container
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminDashboardPage()),
                      );
                    },
                    child: buildCard('Dashboard', Icons.dashboard),
                  ),
                  const SizedBox(height: 20),

                  // Complaints Container
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComplaintsPage(),
                          ));
                    },
                    child: buildCard('Complaints', Icons.report),
                  ),
                  const SizedBox(height: 20),

                  // Feedback Container
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedbackPage()));
                    },
                    child: buildCard('Feedback', Icons.feedback),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Bottom(),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  // Method to Build a Card
  Widget buildCard(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF4CAF50),
                size: 30,
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }
}
