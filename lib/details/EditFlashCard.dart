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
  runApp(const EditFlashCard());
}

class EditFlashCard extends StatefulWidget {
  static const String routeName = "editFlashcard";
  final String? setTitle;
  final String? type;
  final String? docID;

  const EditFlashCard({Key? key, this.setTitle, this.type, this.docID}) : super(key: key);

  @override
  State<EditFlashCard> createState() => _EditFlashCardScreenState();
}

class FlashcardData {
  final String docID;
  final String question;
  final String answer;

  FlashcardData({
    required this.docID,
    required this.question,
    required this.answer,
  });
}

class _EditFlashCardScreenState extends State<EditFlashCard> {

 StorageService storageService = StorageService();
  final FlashCardSetService flashCardSetService = FlashCardSetService();
  final FlashCardService flashCardService = FlashCardService();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  List<TextEditingController> questionControllers = [];
  List<TextEditingController> answerControllers = [];
  List<Widget> flashcardTextFields = []; 

  @override
  void initState() {
    print(widget.type);
    super.initState();
    titleController.text = widget.setTitle ?? '';

    if (widget.type == 'edit' && widget.docID != null) {
      fetchFlashcards(widget.docID!);
    }
  }

List<FlashcardData> flashcardDataList = [];

  void fetchFlashcards(String setUid) {
    flashCardService.getCardsStream(setUid).listen((QuerySnapshot querySnapshot) {
      flashcardDataList.clear();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        String question = data['question'] ?? '';
        String answer = data['answer'] ?? '';

        TextEditingController questionController = TextEditingController(text: question);
        TextEditingController answerController = TextEditingController(text: answer);

        questionControllers.add(questionController);
        answerControllers.add(answerController);

        FlashcardData flashcardData = FlashcardData(
          docID: document.id,
          question: question,
          answer: answer,
        );

        flashcardDataList.add(flashcardData);

        flashcardTextFields.add(
          Column(
            children: [
              Text('Question'),
              TextField(
                controller: questionController,
                decoration: InputDecoration(
                  hintText: 'Input Question',
                ),
                maxLines: null,
              ),
              Text('Answer'),
              TextField(
                controller: answerController,
                decoration: InputDecoration(
                  hintText: 'Input Answer',
                ),
                maxLines: null,
              ),
            ],
          ),
        );
      }

      setState(() {});
    });
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

                if(widget.type == 'add'){
                  String? setUid = await flashCardSetService.addSet(titleController.text);
                  if (setUid != null) {
                    for (int i = 0; i < questionControllers.length; i++) {
                      flashCardService.addCard(
                        questionControllers[i].text,
                        answerControllers[i].text,
                        setUid,
                      );
                    }}
                }else{
                  print(widget.docID);
                  for (int i = 0; i < questionControllers.length; i++) {
                  print('testing: ${answerControllers[i].text}');
                    flashCardService.updateCard(
                      flashcardDataList[i].docID,
                      questionControllers[i].text,
                      answerControllers[i].text
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
