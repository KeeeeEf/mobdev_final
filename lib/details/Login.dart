import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobdev_final/details/Signup.dart';
import 'package:mobdev_final/details/Dashboard.dart';
import 'package:mobdev_final/routes.dart';

class Login extends StatefulWidget {
  static const String routeName = "login";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300.0,
          height: 300.0,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  fillColor: Colors.white,
                  filled: true,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  fillColor: Colors.white,
                  filled: true,
                ),
                obscureText: true,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  signIn(_emailController.value.text,
                      _passwordController.value.text);
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Sign-in with Google'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("New to the App?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Signup.routeName);
                    },
                    child: Text(
                      "Sign up here",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  signIn(String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("Login Successfully");
      Navigator.pushReplacementNamed(context, Dashboard.routeName);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }
}