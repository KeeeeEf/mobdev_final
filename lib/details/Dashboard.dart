import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  static const String routeName = "dashboard";
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<Dashboard> {
  int number = 1;
  int maxnum = 225;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Want an Advice?',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        shadowColor: Color(0),
      ),
    );
  }

  void _setCounter() {
    setState(() {});
  }
}
