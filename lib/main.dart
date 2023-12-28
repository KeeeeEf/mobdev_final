import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobdev_final/firebase_options.dart';
import 'package:mobdev_final/routes.dart';
import 'package:mobdev_final/details/Login.dart';
import 'package:mobdev_final/details/Signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: MainScreen(),
    routes: routes,
  ));
}

class MainScreen extends StatefulWidget {
  static const String routeName = "mainpage";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Searching an Advice by ID',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        shadowColor: Color(0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to (Name of Website)\n A website for notes taking',
            ),
            FloatingActionButton(
              onPressed: login,
              tooltip: 'Login',
              child: const Text('Login'),
            ),
            FloatingActionButton(
              onPressed: register,
              tooltip: 'Signup',
              child: const Text('Signup'),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }

  void login() {
    Navigator.pushReplacementNamed(context, Login.routeName);
  }

  void register() {
    Navigator.pushReplacementNamed(context, Signup.routeName);
  }
}
