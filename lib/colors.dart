import 'package:flutter/material.dart';

//if you want to change color: http://mcg.mbitson.com/ copy and pick flutter material color
//youtube link: https://www.youtube.com/shorts/IEAvlucQB0s

//remove static when pasted

//background

const MaterialColor background = MaterialColor(_backgroundPrimaryValue, <int, Color>{
  50: Color(0xFFFAF6F5),
  100: Color(0xFFF4E8E5),
  200: Color(0xFFECD9D4),
  300: Color(0xFFE4C9C3),
  400: Color(0xFFDFBEB6),
  500: Color(_backgroundPrimaryValue),
  600: Color(0xFFD5ABA2),
  700: Color(0xFFCFA298),
  800: Color(0xFFCA998F),
  900: Color(0xFFC08A7E),
});
const int _backgroundPrimaryValue = 0xFFD9B2A9;

const MaterialColor backgroundAccent = MaterialColor(_backgroundAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_backgroundAccentValue),
  400: Color(0xFFFFE7E2),
  700: Color(0xFFFFD2C9),
});
const int _backgroundAccentValue = 0xFFFFFFFF;

//primary

const MaterialColor primary = MaterialColor(_primaryPrimaryValue, <int, Color>{
  50: Color(0xFFFEFEFC),
  100: Color(0xFFFEFCF7),
  200: Color(0xFFFDFAF1),
  300: Color(0xFFFCF7EB),
  400: Color(0xFFFBF6E7),
  500: Color(_primaryPrimaryValue),
  600: Color(0xFFF9F3E0),
  700: Color(0xFFF9F1DC),
  800: Color(0xFFF8EFD8),
  900: Color(0xFFF6ECD0),
});
const int _primaryPrimaryValue = 0xFFFAF4E3;

const MaterialColor primaryAccent = MaterialColor(_primaryAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_primaryAccentValue),
  400: Color(0xFFFFFFFF),
  700: Color(0xFFFFFFFF),
});
const int _primaryAccentValue = 0xFFFFFFFF;

//secondary

const MaterialColor secondary = MaterialColor(_secondaryPrimaryValue, <int, Color>{
  50: Color(0xFFFDFBFA),
  100: Color(0xFFFBF4F2),
  200: Color(0xFFF9EDEA),
  300: Color(0xFFF6E6E2),
  400: Color(0xFFF4E0DB),
  500: Color(_secondaryPrimaryValue),
  600: Color(0xFFF0D7D0),
  700: Color(0xFFEED2CA),
  800: Color(0xFFECCDC4),
  900: Color(0xFFE8C4BA),
});
const int _secondaryPrimaryValue = 0xFFF2DBD5;

const MaterialColor secondaryAccent = MaterialColor(_secondaryAccentValue, <int, Color>{
  100: Color(0xFFFFFFFF),
  200: Color(_secondaryAccentValue),
  400: Color(0xFFFFFFFF),
  700: Color(0xFFFFFFFF),
});
const int _secondaryAccentValue = 0xFFFFFFFF;