import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
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

  const CreateFlashcard(
      {Key? key,
      this.noteTitle,
      this.noteQuestion,
      this.noteAnswer,
      this.docID})
      : super(key: key);

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
  List<Widget> flashcardTextFields =
      []; // List to store dynamically added TextFields

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
            'Create Flashcard',
            style: GoogleFonts.robotoMono(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: primary,
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromRGBO(250, 244, 227, 1),
                ),
              ),
              onPressed: () async {
                String? setUid =
                    await flashCardSetService.addSet(titleController.text);

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
              child: Text(
                'Save',
                style: GoogleFonts.robotoMono(
                  color: Color.fromRGBO(244, 238, 237, 1),
                  fontSize: 14.0,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Input a title for this set',
                  style: GoogleFonts.robotoMono(
                    fontSize: 14.0,
                  ),
                ),
                TextField(
                  style: GoogleFonts.robotoMono(
                    fontWeight: FontWeight.w600,
                  ),
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: GoogleFonts.robotoMono(),
                  ),
                  maxLines: null, // Allows multiple lines
                ),

                SizedBox(height: 20.0),

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
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromRGBO(165, 166, 143, 1))),
                        child: Text(
                          'Delete',
                          style: GoogleFonts.robotoMono(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Color.fromRGBO(244, 238, 237, 1)),
                        ),
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
          hoverColor: Color.fromRGBO(250, 244, 227, 1),
          backgroundColor: Color.fromRGBO(244, 238, 237, 1),
          child: Icon(
            Icons.add,
            size: 40.0,
            color: Color.fromRGBO(165, 166, 143, 1),
          ),
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
            Text(
              'Question',
              style: GoogleFonts.robotoMono(),
            ),
            TextField(
              controller: newQuestionController,
              style: GoogleFonts.robotoMono(
                fontSize: 14.0,
              ),
              decoration: InputDecoration(
                hintText: 'Input Question',
                hintStyle: GoogleFonts.robotoMono(
                  fontSize: 12.0,
                ),
              ),
              maxLines: null, // Allows multiple lines
            ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              'Answer',
              style: GoogleFonts.robotoMono(
                fontSize: 14.0,
              ),
            ),
            TextField(
              style: GoogleFonts.robotoMono(),
              controller: newAnswerController,
              decoration: InputDecoration(
                hintText: 'Input Answer',
                hintStyle: GoogleFonts.robotoMono(
                  fontSize: 12.0,
                ),
              ),
              maxLines: null, // Allows multiple lines
            ),
          ],
        ),
      );

      questionControllers.add(newQuestionController);
      answerControllers.add(newAnswerController);

      flashcardTextFields.add(SizedBox(
        height: 20.0,
      ));
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
