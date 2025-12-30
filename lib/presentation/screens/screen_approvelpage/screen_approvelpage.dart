import 'package:flutter/material.dart';

class ScreenApprovelpage extends StatefulWidget {
  const ScreenApprovelpage({super.key});

  @override
  State<ScreenApprovelpage> createState() => _ScreenApprovelpageState();
}

class _ScreenApprovelpageState extends State<ScreenApprovelpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Approvel Page'),
      ),
    );
  }
}