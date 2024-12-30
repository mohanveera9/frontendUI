import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Selfdefense extends StatelessWidget {
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
                      'Self-defense Techniques',
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  selfDefenseContainer(
                    image: 'assets/img/support/self-control.png',
                    title: 'Basic Self-Defense Moves',
                  ),
                  selfDefenseContainer(
                    image: 'assets/img/support/video.png',
                    title: 'Video Tutorials',
                  ),
                  selfDefenseContainer(
                    image: 'assets/img/support/safety-pin.png',
                    title: 'Self-Defense Tools',
                  ),
                  selfDefenseContainer(
                    image: 'assets/img/support/pepper-spray.png',
                    title: 'Escape Techniques',
                  ), 
                  selfDefenseContainer(
                    image: 'assets/img/support/emergency-support.png',
                    title: 'Emergency Response',
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom widget for each container
  Widget selfDefenseContainer({required String image, required String title}) {
    return Container(
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 50,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
