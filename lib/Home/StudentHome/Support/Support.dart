import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:girls_grivince/Home/StudentHome/Support/communitySupport.dart';
import 'package:girls_grivince/Home/StudentHome/Support/selfDefense.dart';
import 'package:girls_grivince/Home/StudentHome/home.dart';

class Support extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          // Content Section
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                supportContainer(
                  funtion: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (builder) => Communitysupport(),
                      ),
                    );
                  },
                  img: 'assets/img/support/community.png',
                  title: 'Community Support',
                ),
                SizedBox(height: 12),
                supportContainer(
                  funtion: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (builder) => Selfdefense(),
                      ),
                    );
                  },
                  img: 'assets/img/support/protection.png',
                  title: 'Self-defense techniques',
                ),
                SizedBox(height: 12),
                supportContainer(
                  funtion: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (builder) => Home(),
                      ),
                    );
                  },
                  img: 'assets/img/support/awareness.png',
                  title: 'Situational awareness tips',
                ),
                SizedBox(height: 12),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom container widget
  Widget supportContainer(
      {required String img, required String title, required funtion}) {
    return GestureDetector(
      onTap: funtion,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 6,
              spreadRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              img,
              height: 40,
              width: 40,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
