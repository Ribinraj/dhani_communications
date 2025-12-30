import 'package:flutter/material.dart';

class ScreenDashboardpage extends StatefulWidget {
  const ScreenDashboardpage({super.key});

  @override
  State<ScreenDashboardpage> createState() => _ScreenDashboardpageState();
}

class _ScreenDashboardpageState extends State<ScreenDashboardpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Dashboard Page'),
      ),
    );
  }
}