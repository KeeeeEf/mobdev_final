import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobdev_final/details/Login.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup extends StatefulWidget {
  static const String routeName = "signup";
  const Signup({Key? key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(217, 178, 169, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: <Widget>[
                Text(
                  "REGISTER",
                  style: GoogleFonts.robotoMono(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w200,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = Colors.white,
                  ),
                ),
                Text(
                  "REGISTER",
                  style: GoogleFonts.robotoMono(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            SizedBox(height: 15.0,),

            Container(
              width: 325.0,
              height: 400.0,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(250, 240, 227, 1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: GoogleFonts.robotoMono(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Login.routeName);
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.robotoMono(
                        fontSize: 15.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Input Email',
                      labelStyle: GoogleFonts.robotoMono(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: GoogleFonts.robotoMono(
                        color: Colors.black,
                        fontSize: 15.0,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      signUp(_emailController.value.text,
                          _passwordController.value.text);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(242, 219, 213, 1),
                      ),
                      fixedSize: MaterialStateProperty.all<Size>(
                        Size(85, 50),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.robotoMono(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: GoogleFonts.robotoMono(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, Login.routeName);
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.robotoMono(
                            fontSize: 15.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  signUp(String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      print("Successful registration");
      Navigator.pushReplacementNamed(context, Login.routeName);
    } catch (e) {
      print(e);
    }
  }
}