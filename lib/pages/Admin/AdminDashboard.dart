import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  List<Map<String, dynamic>> dashboardData = [];
  bool isLoading = false;

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _GetLocations() async {
    setState(() {
      isLoading = true;
    });

    final token = await getToken();
    final url = Uri.parse('https://gvmc-1.onrender.com/locations');

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "origin": 'http://localhost:8080',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          dashboardData = data.map((item) {
            return {
              "location": item['loc_name'],
              "percentage": item['currentPercentWaste'],
              "nextOverflowDate": item['nextOverflowDate'],
            };
          }).toList();
        });

        showSnackbar('Data fetched successfully!', Colors.green);
      } else {
        showSnackbar('Error occurred while fetching data.', Colors.red);
      }
    } catch (e) {
      showSnackbar('Check your connection.', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
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
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF4CAF50),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _GetLocations,
          ),
        ],
      ),
      backgroundColor: const Color(0xFFEAFBF1),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dashboardData.isEmpty
              ? const Center(
                  child: Text(
                    'No data available. Press refresh to load data.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 containers per row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.0, // Adjust aspect ratio to reduce height
                    ),
                    itemCount: dashboardData.length,
                    itemBuilder: (context, index) {
                      final item = dashboardData[index];
                      final percentage = item['percentage'] as int;

                      // Determine color based on percentage
                      Color progressColor;
                      if (percentage > 75) {
                        progressColor = Colors.red;
                      } else if (percentage > 50) {
                        progressColor = Colors.orange;
                      } else {
                        progressColor = Colors.green;
                      }

                      return Container(
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
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              item['location'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4CAF50),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            CircularPercentIndicator(
                              radius: 40,
                              lineWidth: 8,
                              percent: percentage / 100,
                              center: Text(
                                "$percentage%",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              progressColor: progressColor,
                              backgroundColor: Colors.grey.shade200,
                            ),
                            Text(
                              "Next Overflow: ${item['nextOverflowDate']}",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
