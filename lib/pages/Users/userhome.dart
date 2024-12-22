import 'package:flutter/material.dart';
import 'package:hackwave/pages/Users/usercomplaints.dart';
import 'package:hackwave/pages/Users/userfeedback.dart';
import 'package:hackwave/pages/Users/userreport.dart';
import 'package:hackwave/widgets/Bottom.dart';

class Userhome extends StatefulWidget {
  final String name;
  const Userhome({super.key, required this.name});
  @override
  _UserhomeState createState() => _UserhomeState();
}

class _UserhomeState extends State<Userhome> {
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
            ' Home',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFEAFBF1),
      body:Column(
        children: [
          const SizedBox(height: 30),
          // Containers Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Userreport(name: widget.name,)),
                      );
                    },
                    child: buildCard('Emergency Reporting', Icons.warning),
                  ),
                  const SizedBox(height: 20),

                  // Complaints Container
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>UserComplaintsPage())
                      );
                    },
                    child: buildCard('Complaints', Icons.report),
                  ),
                  const SizedBox(height: 20),

                  // Feedback Container
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>UserFeedbackPage() )
                      );
                    },
                    child: buildCard('Feedback', Icons.feedback),
                  ),
                  const Spacer(),
                  Bottom(),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
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
        ));
  }
}
