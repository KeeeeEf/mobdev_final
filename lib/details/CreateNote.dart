import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
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

  const CreateNote({Key? key, this.noteTitle, this.noteText, this.docID})
      : super(key: key);

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
        backgroundColor: Color.fromRGBO(250, 244, 227, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(217, 178, 169, 0.7),
          title: Text(
            'Create Note',
            style: GoogleFonts.robotoMono(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(165, 166, 143, 1)),
              ),
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
              child: Text(
                'Save',
                style: GoogleFonts.robotoMono(
                    color: Color.fromRGBO(244, 238, 237, 1),
                    fontSize: 14.0,
                    height: 2.0),
              ),
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
                style: GoogleFonts.robotoMono(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: GoogleFonts.robotoMono(),
                    contentPadding: EdgeInsets.all(8.0)),
                maxLines: null, // Allows multiple lines
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                textAlign: TextAlign.start,
                controller: textController,
                style: GoogleFonts.robotoMono(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 3, color: Colors.greenAccent)),
                  fillColor: Color.fromRGBO(242, 219, 213, 1),
                  filled: true,
                  hintText: 'Content',
                  hintStyle: GoogleFonts.robotoMono(),
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
