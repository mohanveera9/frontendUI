import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:girls_grivince/Home/Chat/chatInterface.dart';
import 'package:girls_grivince/Home/StudentHome/youtubePlayer.dart';
import 'package:girls_grivince/Models/DataProvider.dart';
import 'package:girls_grivince/Models/SupportStaffModel.dart';
import 'package:girls_grivince/Models/UserModel/UserProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class Communitysupport extends StatefulWidget {
  @override
  _CommunitysupportState createState() => _CommunitysupportState();
}

class _CommunitysupportState extends State<Communitysupport> {
  List<dynamic> supportStaffff = [];
  List<String> safetyVideos = [
    'https://youtu.be/KVpxP3ZZtAc?si=uCrtshNTu6dPWs4X',
    'https://youtu.be/cHwdNwGV_-I?si=xCOfINNMNhhothja',
    'https://youtu.be/0-d0btVJnNA?si=iO-YaNVJ9vQyWFRl',
  ];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    dataProvider.fetchData();
    fetchSupportData();
  }

  Future<void> fetchSupportData() async {
    try {
      final response = await http.get(
        Uri.parse('https://tech-hackathon-glowhive.onrender.com/api/support'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          supportStaffff = data['supportStaff'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print(
            'Failed to load support data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  @override
  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section
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
              // Image.asset(
              //   'assets/img/home2.png',
              //   width: double.infinity,
              //   height: 150,
              //   fit: BoxFit.cover,
              // ),
              Positioned(
                top: 50,
                left: 20,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        'assets/img/arrow2.png',
                        width: 41,
                        height: 33,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Support',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Support Contacts",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          isLoading
              ? _buildProviderData(dataProvider.supportStaff, user!.id)
              : _buildApiData(user!.id), // Removed Expanded here
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Women safety tips",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: safetyVideos.length,
              itemBuilder: (context, index) {
                final videoId =
                    YoutubePlayer.convertUrlToId(safetyVideos[index]);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (builder) => Player(videoId: videoId),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        YoutubePlayer.getThumbnail(videoId: videoId!),
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderData(
      List<SupportStaffModel> supportStaff, String userId) {
    return ListView.builder(
      shrinkWrap: true, // Ensures it only takes up needed space
      physics: NeverScrollableScrollPhysics(),
      itemCount: supportStaff.length,
      itemBuilder: (context, index) {
        final staff = supportStaff[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              staff.name,
              style: TextStyle(
                color: Color(0xFF0C3F9E),
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              staff.position,
              style: TextStyle(fontSize: 16),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.chat, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (builder) => Chatinterface(
                          name: staff.name,
                          role: staff.position,
                          userId: userId,
                          supportId: staff.id,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.call, color: Colors.black),
                  onPressed: () {
                    final phoneNumber = staff.phno;
                    if (phoneNumber.isNotEmpty) {
                      launch('tel:$phoneNumber');
                    } else {
                      print('Phone number not available');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildApiData(String userId) {
    return ListView.builder(
      shrinkWrap: true, // Ensures it only takes up needed space
      physics: NeverScrollableScrollPhysics(),
      itemCount: supportStaffff.length,
      itemBuilder: (context, index) {
        final staff = supportStaffff[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            title: Text(
              staff['name'] ?? 'No Name',
              style: TextStyle(
                color: Color(0xFF0C3F9E),
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              staff['position'] ?? 'No Position',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.chat, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (builder) => Chatinterface(
                          name: staff['name'],
                          role: staff['position'],
                          userId: userId,
                          supportId: staff['_id'],
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.call, color: Colors.black),
                  onPressed: () {
                    final phoneNumber = staff['phno'] ?? '';
                    if (phoneNumber.isNotEmpty) {
                      launch('tel:$phoneNumber');
                    } else {
                      print('Phone number not available');
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
