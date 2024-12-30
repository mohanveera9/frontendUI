import 'package:flutter/material.dart';
import 'package:girls_grivince/Login/loginMain.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Facultyhome extends StatefulWidget {
  final String name;
  final String phone;
  final String position;
  final String fId;

  const Facultyhome({
    super.key,
    required this.name,
    required this.phone,
    required this.position,
    required this.fId,
  });

  @override
  State<Facultyhome> createState() => _FacultyhomeState();
}

class _FacultyhomeState extends State<Facultyhome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6BF3DD), // Start color
                Color(0xFF39D0D1), // Midpoint color
                Color(0xFF0C3F9E), // End color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Girls Grievance',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(30, 40),
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              if (value == 'logout') {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('auth_token_faculty');
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (builder) => Loginmain(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: const [
                      Icon(Icons.logout, color: Colors.black),
                      SizedBox(width: 10),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 5, // Example count of chat items
        itemBuilder: (context, index) {
          String username = "User $index";
          String lastMessage = "This is the last message from";
          String date = "12:00 PM";
          bool hasNewMessage =
              index % 2 == 0; // Alternate new message indicator

          return ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  Colors.primaries[username.hashCode % Colors.primaries.length],
              child: Text(
                username[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(username),
            subtitle: Text(lastMessage),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasNewMessage)
                  const Icon(
                    Icons.circle,
                    color: Colors.green,
                    size: 10,
                  ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            onTap: () {
              // Navigate to chat or perform an action
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on $username')),
              );
            },
          );
        },
      ),
    );
  }
}
