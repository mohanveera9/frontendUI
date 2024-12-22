import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/recycle.png',
            height: 50,
            width: 50,
          ),
          const SizedBox(
            height: 4,
          ),
          const Text(
            'Greater Visakhapatnam Municipal Corporation',
            style: TextStyle(),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
