import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobdev_final/details/Signup.dart';
import 'package:mobdev_final/details/Dashboard.dart';
import 'package:mobdev_final/firebase_options.dart';
import 'package:mobdev_final/models/StorageItem.dart';
import 'package:mobdev_final/routes.dart';
import 'package:mobdev_final/services/StorageService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class Login extends StatefulWidget {
  static const String routeName = "login";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  StorageService storageService = StorageService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 238, 237, 1.0),
      body: Center(
        child: Container(
          width: 300.0,
          height: 350.0,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        signIn(context, _emailController.value.text,
                            _passwordController.value.text);
                      },
                      child: Text('Login')),
                  TextButton(
                      onPressed: () {
                        loginWithGoogle();
                      },
                      child: Text('Sign-Up with Google')),
                ],
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

  signIn(context, String email, String password) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("Login Successfully");

      var item = StorageItem("uid", credential.user?.uid ?? "");
      print(credential);
      await storageService.saveData(item);

      Navigator.pushReplacementNamed(context, Dashboard.routeName);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    } catch (e) {
      print(e);
    }
  }

  loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential? userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      Navigator.pushReplacementNamed(context, Dashboard.routeName);
    } catch (e) {
      print(e);
    }
  }
}
