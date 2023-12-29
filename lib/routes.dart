import 'package:flutter/material.dart';
import 'package:mobdev_final/details/Notes.dart';
import 'package:mobdev_final/main.dart';
import 'package:mobdev_final/details/Login.dart';
import 'package:mobdev_final/details/Signup.dart';
import 'package:mobdev_final/details/Dashboard.dart';

final Map<String, WidgetBuilder> routes = {
  MainScreen.routeName: (BuildContext context) => MainScreen(),
  Login.routeName: (BuildContext context) => Login(),
  Dashboard.routeName: (BuildContext context) => Dashboard(),
  Notes.routeName: (BuildContext context) => Notes(),
  Signup.routeName: (BuildContext context) => Signup(),
};
