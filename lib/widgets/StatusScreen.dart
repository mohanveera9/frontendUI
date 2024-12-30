
import 'package:flutter/material.dart';
import 'package:girls_grivince/Models/ComplaintModel.dart';

class ComplaintDetailScreen extends StatelessWidget {
  final ComplaintModel complaint;

  const ComplaintDetailScreen({required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with background image and title
          Stack(
            children: [
              Image.asset(
                'assets/img/home2.png',
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 20,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        'assets/img/arrow2.png',
                        height: 35,
                        width: 43,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Complaint Details',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                detailItem('Statement', complaint.statement),
                detailItem('Description', complaint.description),
                detailItem('Category', complaint.category),
                detailItem('Status', complaint.status),
                detailItem('Location', complaint.location),
                detailItem('Type', complaint.typeOfComplaint),
                detailItem('Anonymous', complaint.isAnonymus ? 'Yes' : 'No'),
                detailItem('Critical', complaint.isCritical ? 'Yes' : 'No'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget detailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
