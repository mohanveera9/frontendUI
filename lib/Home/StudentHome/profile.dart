import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:girls_grivince/Login/loginMain.dart';
import 'package:girls_grivince/Models/UserModel.dart';
import 'package:girls_grivince/Models/UserModel/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _isEditingName = false;
  bool _isEditingSos = false;
  bool _isLoadingName = false;
  bool _isLoadingSos = false;
  late TextEditingController _nameController;
  late TextEditingController _primaryController;

  @override
  void initState() {
    super.initState();
    final userModel = Provider.of<UserModel>(context, listen: false);
    _nameController = TextEditingController(text: userModel.name);
    _primaryController = TextEditingController(text: userModel.primary);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _primaryController.dispose();
    super.dispose();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> editName({required String name}) async {
    if (name.isEmpty) {
      showSnackbar('Username cannot be empty.', Colors.red);
      return;
    }

    final token = await getToken();
    final url = Uri.parse(
        'https://tech-hackathon-glowhive.onrender.com/api/user/edit/username');
    final body = {"username": name};

    setState(() {
      _isLoadingName = true;
    });

    try {
      final response = await http.patch(
        url,
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(body),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 &&
          responseData['message'] == "User Updated Successfully") {
        final userModel = Provider.of<UserModel>(context, listen: false);
        userModel.updateName(name);
        _nameController.text = name; // Update the text controller
        showSnackbar('Name updated successfully.', Colors.green);
      } else {
        showSnackbar('Failed to update name.', Colors.red);
      }
    } catch (e) {
      showSnackbar('An error occurred. Check your connection and try again.',
          Colors.red);
    } finally {
      setState(() {
        _isLoadingName = false;
      });
    }
  }

  Future<void> editPrimaryNumber({required String number}) async {
    if (number.isEmpty) {
      showSnackbar('Primary Number cannot be empty.', Colors.red);
      return;
    }

    final token = await getToken();
    final url = Uri.parse(
        'https://tech-hackathon-glowhive.onrender.com/api/user/edit/primary');
    final body = {"primary_sos": number};

    setState(() {
      _isLoadingSos = true;
    });

    try {
      final response = await http.patch(
        url,
        headers: {
          "Content-type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(body),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final userModel = Provider.of<UserModel>(context, listen: false);
        userModel.updateNumber(number);
        _primaryController.text = number; // Update the text controller
        showSnackbar('Primary SOS updated successfully.', Colors.green);
      } else {
        showSnackbar('Failed to update Primary SOS.', Colors.red);
      }
    } catch (e) {
      showSnackbar('An error occurred. Check your connection and try again.',
          Colors.red);
    } finally {
      setState(() {
        _isLoadingSos = false;
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
    final userModel = Provider.of<UserModel>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final name = userModel.name;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 150,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF0C3F9E), // Start color
                              Color(0xFF39D0D1), // Midpoint color
                              Color(0xFF0C3F9E), // End color
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 10,
                        right: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pop(); // This will pop the current screen
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: const Icon(Icons.arrow_back,
                                    size: 30, color: Colors.white),
                              ),
                            ),
                            const Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                                width: 30), // Placeholder for spacing
                          ],
                        ),
                      ),
                      Positioned(
                        top: 100,
                        left: MediaQuery.of(context).size.width / 2 - 50,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.primaries[
                                  name.hashCode % Colors.primaries.length],
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : '',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF6BF3DD), // Start color
                                      Color(0xFF39D0D1), // Midpoint color
                                      Color(0xFF0C3F9E), // End color
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 90),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        _buildEditableProfileField(
                          icon: Icons.person,
                          label: 'Name',
                          controller: _nameController,
                          isEditable: _isEditingName,
                          isLoading: _isLoadingName,
                          onEditPressed: () {
                            if (_isEditingName && !_isLoadingName) {
                              editName(name: _nameController.text);
                            }
                            setState(() {
                              _isEditingName = !_isEditingName;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        _buildEditableProfileField(
                          icon: Icons.sos,
                          label: 'Primary SOS',
                          controller: _primaryController,
                          isEditable: _isEditingSos,
                          isLoading: _isLoadingSos,
                          onEditPressed: () {
                            if (_isEditingSos && !_isLoadingSos) {
                              editPrimaryNumber(
                                  number: _primaryController.text);
                            }
                            setState(() {
                              _isEditingSos = !_isEditingSos;
                            });
                          },
                        ),
                        const SizedBox(height: 30),
                        _buildProfileField(
                          icon: Icons.email,
                          label: 'Email',
                          value: user != null
                              ? user.email
                              : '', // Add email to UserModel
                        ),
                        const SizedBox(height: 30),
                        _buildProfileField(
                          icon: Icons.call,
                          label: 'Mobile Number',
                          value: user != null
                              ? user.phone
                              : '', // Add phone to UserModel
                        ),
                        const SizedBox(height: 30),
                        _buildSignOutButton(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableProfileField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool isEditable,
    required bool isLoading,
    required VoidCallback onEditPressed,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color.fromARGB(255, 30, 123, 179),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
              isEditable
                  ? TextField(
                      controller: controller,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      controller.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onEditPressed,
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color.fromARGB(255, 30, 123, 179),
                  ),
                )
              : Icon(
                  isEditable ? Icons.check : Icons.edit,
                  color: Color.fromARGB(255, 30, 123, 179),
                ),
        ),
      ],
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color.fromARGB(255, 30, 123, 179),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 30, 123, 179),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () async {
          // Clear the token from SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('auth_token');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Loginmain()),
            (route) => false,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.logout, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Sign Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
