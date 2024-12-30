import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:girls_grivince/Models/ComplaintModel.dart';
import 'package:girls_grivince/Models/DataProvider.dart';
import 'package:girls_grivince/widgets/ComplaintCard.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; // For jsonDecode
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  void initState() {
    super.initState();
    // Fetch data in the background if not already fetched
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    if (dataProvider.complaints.isEmpty) {
      _fetchData(dataProvider);
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _fetchData(DataProvider dataProvider) async {
    const apiUrl =
        'https://tech-hackathon-glowhive.onrender.com/api/complaints/user';
    final token = await getToken(); // Replace with your token logic
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Parse the response as a Map
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Extract the complaints list
        final List<dynamic> complaintsData = responseData['complaints'];

        // Map the list to ComplaintModel
        final List<ComplaintModel> complaints = complaintsData
            .map((json) => ComplaintModel.fromJson(json))
            .toList();

        // Update the complaints in the DataProvider
        dataProvider.updateComplaints(complaints);
      } else {
        throw Exception(
            'Failed to fetch complaints. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching complaints: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header with background image and title
          Stack(
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
                top: 60,
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
                      'Complaint Status',
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
          // Title and refresh button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Text(
                  'List of All Complaints',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          // Complaints list with pull-to-refresh
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _fetchData(dataProvider),
              child: dataProvider.complaints.isEmpty
                  ? Center(child: Text('No complaints available'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: dataProvider.complaints.length,
                      itemBuilder: (context, index) {
                        final complaint = dataProvider.complaints[index];
                        if (complaint.statement.isEmpty ||
                            complaint.description.isEmpty) {
                          return SizedBox.shrink();
                        }
                        return ComplaintCard(
                          complaint: complaint,
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         ComplaintDetailScreen(complaint: complaint),
                            //   ),
                            // );
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
