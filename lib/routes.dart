import 'package:flutter/material.dart';
import 'package:mobdev_final/details/CreateFlashCard.dart';
import 'package:mobdev_final/details/CreateNote.dart';
import 'package:mobdev_final/details/EditFlashCard.dart';
import 'package:mobdev_final/details/Flashcard.dart';
import 'package:mobdev_final/details/FlashcardSetList.dart';
import 'package:mobdev_final/details/Notes.dart';
import 'package:mobdev_final/details/NotesList.dart';
import 'package:mobdev_final/main.dart';
import 'package:mobdev_final/details/Login.dart';
import 'package:mobdev_final/details/Signup.dart';
import 'package:mobdev_final/details/Dashboard.dart';

final Map<String, WidgetBuilder> routes = {

  //Authentication
  Login.routeName: (BuildContext context) => Login(),
  Signup.routeName: (BuildContext context) => Signup(),

  MainScreen.routeName: (BuildContext context) => MainScreen(),

  Dashboard.routeName: (BuildContext context) => Dashboard(),

  Notes.routeName: (BuildContext context) => Notes(),
  NotesList.routeName: (BuildContext context) => NotesList(),
  CreateNote.routeName: (BuildContext context) => CreateNote(),

  FlashCardSetList.routeName: (BuildContext context) => FlashCardSetList(),
  Flashcard.routeName: (BuildContext context) => Flashcard(),
  CreateFlashcard.routeName: (BuildContext context) => CreateFlashcard(),
  EditFlashCard.routeName: (BuildContext context) => EditFlashCard(),
};
