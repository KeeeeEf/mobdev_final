import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobdev_final/details/Dashboard.dart';
import 'package:mobdev_final/firebase_options.dart';
import 'package:mobdev_final/routes.dart';
import 'package:mobdev_final/details/Login.dart';
import 'package:mobdev_final/details/Signup.dart';
import 'package:mobdev_final/services/StorageService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  StorageService storageService = StorageService();

  var item = await storageService.readData("uid");

  if (item != null) {
    runApp(MaterialApp(
      initialRoute: Dashboard.routeName,
      routes: routes,
    ));
  } else {
    runApp(MaterialApp(
      initialRoute: MainScreen.routeName,
      routes: routes,
    ));
  }
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
      backgroundColor: Color.fromRGBO(217, 178, 169, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: <Widget>[
                Text(
                  "FlashMaster",
                  style: GoogleFonts.robotoMono(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w400,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 3
                      ..color = Colors.black,
                  ),
                ),
                Text(
                  "FlashMaster",
                  style: GoogleFonts.robotoMono(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(165, 166, 143, 1),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              width: 280.0,
              height: 100.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    'Empower Learning with Self-Created Flashcards',
                    style: GoogleFonts.robotoMono(
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: 300.0,
              height: 200.0,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(250, 244, 227, 1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(242, 219, 213, 1)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              horizontal: 98, vertical: 20),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: <Widget>[
                              Text(
                                "Login",
                                style: GoogleFonts.robotoMono(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Colors.white,
                                ),
                              ),
                              Text(
                                "Login",
                                style: GoogleFonts.robotoMono(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(165, 166, 143, 1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )

                      // Text(
                      //   'Login',
                      //   style: GoogleFonts.robotoMono(
                      //     color: Colors.black,
                      //   ),
                      // ),
                      ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        register();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(242, 219, 213, 1)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 20),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: <Widget>[
                              Text(
                                "Register",
                                style: GoogleFonts.robotoMono(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w300,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Colors.white,
                                ),
                              ),
                              Text(
                                "Register",
                                style: GoogleFonts.robotoMono(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromRGBO(165, 166, 143, 1),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )

                      // Text(
                      //   'Login',
                      //   style: GoogleFonts.robotoMono(
                      //     color: Colors.black,
                      //   ),
                      // ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text(
    //       'Searching an Advice by ID',
    //       style: TextStyle(color: Colors.black),
    //     ),
    //     backgroundColor: Color.fromRGBO(250, 250, 250, 1),
    //     shadowColor: Color(0),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         const Text(
    //           'Welcome to (Name of Website)\n A website for notes taking',
    //         ),
    //         FloatingActionButton(
    //           heroTag: "btn1",
    //           onPressed: login,
    //           tooltip: 'Login',
    //           child: const Text('Login'),
    //         ),
    //         FloatingActionButton(
    //           heroTag: "btn2",
    //           onPressed: register,
    //           tooltip: 'Signup',
    //           child: const Text('Signup'),
    //         ),
    //         Text(
    //           '$_counter',
    //           style: Theme.of(context).textTheme.headlineMedium,
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  void login() {
    Navigator.pushNamed(context, Login.routeName);
  }

  void register() {
    Navigator.pushNamed(context, Signup.routeName);
  }
}
