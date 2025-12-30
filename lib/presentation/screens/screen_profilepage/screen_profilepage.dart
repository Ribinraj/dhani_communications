import 'package:flutter/material.dart';

class ScreenProfilepage extends StatefulWidget {
  const ScreenProfilepage({super.key});

  @override
  State<ScreenProfilepage> createState() => _ScreenProfilepageState();
}

class _ScreenProfilepageState extends State<ScreenProfilepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Profile Page'),
      ),
    );
  }
}