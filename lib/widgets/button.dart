import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback funtion;

   const Button({super.key, required this.text, required this.funtion, });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: funtion,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4CAF50),
        padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child:Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
