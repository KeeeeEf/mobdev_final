import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobdev_final/firebase_options.dart';
import 'package:mobdev_final/colors.dart';
import 'package:mobdev_final/services/firestore.dart';
import 'package:mobdev_final/services/StorageService.dart';
import 'package:mobdev_final/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CreateNote());
}

class CreateNote extends StatefulWidget {
  static const String routeName = "createNote";
  final String? noteTitle;
  final String? noteText;
  final String? docID;

  const CreateNote({Key? key, this.noteTitle, this.noteText, this.docID}) : super(key: key);

  @override
  State<CreateNote> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNote> {
  StorageService storageService = StorageService();
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.noteTitle ?? '';
    textController.text = widget.noteText ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: background),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Create Note',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: primary,
          actions: [
            ElevatedButton(
              onPressed: () {
                if (widget.docID == null) {
                  firestoreService.addNote(
                    titleController.text,
                    textController.text,
                  );
                } else {
                  firestoreService.updateNote(
                    widget.docID!,
                    titleController.text,
                    textController.text,
                  );
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                ),
                maxLines: null, // Allows multiple lines
              ),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: 'ambot...'
                ),
                maxLines: null, // Allows multiple lines
              ),
            ],
          ),
        ),
      ),
    );
  }
}
