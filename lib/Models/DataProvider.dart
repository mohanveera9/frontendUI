import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:girls_grivince/Models/ComplaintModel.dart';
import 'package:girls_grivince/Models/NotificationModel.dart';
import 'package:girls_grivince/Models/S0SContactsModel.dart';
import 'package:girls_grivince/Models/SupportStaffModel.dart';
import 'package:http/http.dart' as http;

class DataProvider extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  // Set token directly
  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  List<NotificationModel> _notifications = [];
  List<SupportStaffModel> _supportStaff = [];
  List<ComplaintModel> _complaints = [];
  List<SosParentModel> _sosData = [];

  bool _isLoading = false;

  List<NotificationModel> get notifications => _notifications;
  List<SupportStaffModel> get supportStaff => _supportStaff;
  List<ComplaintModel> get complaints => _complaints;
  List<SosParentModel> get sosContacts => _sosData;
  bool get isLoading => _isLoading;

  // Method to update complaints
  void updateComplaints(List<ComplaintModel> newComplaints) {
    _complaints = newComplaints;
    notifyListeners(); // Notify listeners about the change
  }

  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch Notifications
      final notificationResponse = await http.get(
        Uri.parse(
            'https://tech-hackathon-glowhive.onrender.com/api/notifications'),
        headers: {
          'Authorization': 'Bearer $token', // Add the token directly in the header
        },
      );

      if (notificationResponse.statusCode == 200) {
        List<dynamic> notificationData =
            json.decode(notificationResponse.body)['notifications'];
        _notifications = notificationData
            .map((json) => NotificationModel.fromJson(json))
            .toList();
        notifyListeners(); // Update listeners when notifications data is updated
      } else {
        print('Failed to load notifications: ${notificationResponse.statusCode}');
      }

      // Fetch Support Staff
      final supportResponse = await http.get(
        Uri.parse('https://tech-hackathon-glowhive.onrender.com/api/support'),
      );

      if (supportResponse.statusCode == 200) {
        List<dynamic> supportData =
            json.decode(supportResponse.body)['supportStaff'];
        _supportStaff = supportData
            .map((json) => SupportStaffModel.fromJson(json))
            .toList();
      }

      // Fetch Complaints
      final complaintsResponse = await http.get(
        Uri.parse(
            'https://tech-hackathon-glowhive.onrender.com/api/complaints/user'),
        headers: {
          'Authorization': 'Bearer $token', // Add the token directly in the header
        },
      );
      print('Complaints Response Status: ${complaintsResponse.statusCode}');
      print('Complaints Response Body: ${complaintsResponse.body}');

      if (complaintsResponse.statusCode == 200) {
        List<dynamic> complaintsData =
            json.decode(complaintsResponse.body)['complaints'];
        _complaints = complaintsData
            .map((json) => ComplaintModel.fromJson(json))
            .toList();
      }

      // Fetch Soscotacts
      final response = await http.get(
        Uri.parse('https://tech-hackathon-glowhive.onrender.com/api/sos/user'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['sos'] as List;
        _sosData = data.map((json) => SosParentModel.fromJson(json)).toList();
        notifyListeners();
      } else {
        print('Failed to fetch SOS data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners after the data fetch is complete
    }
  }
}
