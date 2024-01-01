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
import 'package:google_fonts/google_fonts.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
                  "Login",
                  style: GoogleFonts.robotoMono(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w400,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 3
                      ..color = Colors.black,
                  ),
                ),
                Text(
                  "Login",
                  style: GoogleFonts.robotoMono(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(165, 166, 143, 1),
                  ),
                ),
              ],
            ),
            
            const SizedBox(
              height: 25.0,
            ),
            
            Stack(
              children: <Widget>[
                Text(
                  "LOGIN",
                  style: GoogleFonts.robotoMono(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w100,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = Colors.white,
                  ),
                ),
                Text(
                  "LOGIN",
                  style: GoogleFonts.robotoMono(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Container(
              width: 300.0,
              height: 350.0,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(250, 244, 227, 1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: GoogleFonts.robotoMono(
                        fontSize: 15,
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
                        fontSize: 15,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      signIn(context, _emailController.value.text,
                          _passwordController.value.text);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(242, 219, 213, 1)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.robotoMono(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      loginWithGoogle();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(242, 219, 213, 1)),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      ),
                    ),
                    child: Text(
                      'Sign-in with Google',
                      style: GoogleFonts.robotoMono(
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
                        "New to the App? ",
                        style: GoogleFonts.robotoMono(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, Signup.routeName);
                        },
                        child: Text(
                          "Sign up here",
                          style: GoogleFonts.robotoMono(
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
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      print("Signed in: ${user!.displayName}");

      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
