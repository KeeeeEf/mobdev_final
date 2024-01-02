import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobdev_final/firebase_options.dart';
import 'package:mobdev_final/colors.dart';
import 'package:mobdev_final/services/firestore.dart';
import 'package:mobdev_final/services/StorageService.dart';
import 'package:mobdev_final/main.dart';
import 'package:mobdev_final/services/flashcard.dart';
import 'package:mobdev_final/services/flashcardSet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const CreateFlashcard());
}

class CreateFlashcard extends StatefulWidget {
  static const String routeName = "createFlashcard";
  final String? noteTitle;
  final String? noteQuestion;
  final String? noteAnswer;
  final String? docID;

  const CreateFlashcard({Key? key, this.noteTitle, this.noteQuestion, this.noteAnswer,  this.docID}) : super(key: key);

  @override
  State<CreateFlashcard> createState() => _CreateFlashcardScreenState();
}

class _CreateFlashcardScreenState extends State<CreateFlashcard> {
  StorageService storageService = StorageService();
  final FlashCardSetService flashCardSetService = FlashCardSetService();
  final FlashCardService flashCardService = FlashCardService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  List<TextEditingController> questionControllers = [];
  List<TextEditingController> answerControllers = [];
  List<Widget> flashcardTextFields = []; // List to store dynamically added TextFields

  @override
  void initState() {
    super.initState();
    titleController.text = widget.noteTitle ?? '';
    questionController.text = widget.noteQuestion ?? '';
    answerController.text = widget.noteAnswer ?? '';
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
            onPressed: () async {
              String? setUid = await flashCardSetService.addSet(titleController.text);

              if (setUid != null) {
                for (int i = 0; i < questionControllers.length; i++) {
                  flashCardService.addCard(
                    questionControllers[i].text,
                    answerControllers[i].text,
                    setUid,
                  );
                }
              }

              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Set Title'),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                  ),
                  maxLines: null, // Allows multiple lines
                ),
                Text('Flashcards'),
                // Dynamically added TextFields
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: flashcardTextFields.length,
                  itemBuilder: (context, index) => Row(
                    children: [
                      Expanded(
                        child: flashcardTextFields[index],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          deleteFlashcardTextField(index);
                        },
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addFlashcardTextField();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void addFlashcardTextField() {
    TextEditingController newQuestionController = TextEditingController();
    TextEditingController newAnswerController = TextEditingController();

    setState(() {
      flashcardTextFields.add(
        Column(
          children: [
            Text('Question'),
            TextField(
              controller: newQuestionController,
              decoration: InputDecoration(
                hintText: 'Input Question',
              ),
              maxLines: null, // Allows multiple lines
            ),
            Text('Answer'),
            TextField(
              controller: newAnswerController,
              decoration: InputDecoration(
                hintText: 'Input Answer',
              ),
              maxLines: null, // Allows multiple lines
            ),
          ],
        ),
      );

      questionControllers.add(newQuestionController);
      answerControllers.add(newAnswerController);
    });
  }

  void deleteFlashcardTextField(int index) {
    setState(() {
      flashcardTextFields.removeAt(index);
      questionControllers.removeAt(index);
      answerControllers.removeAt(index);
    });
  }

  
}
