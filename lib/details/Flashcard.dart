import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobdev_final/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobdev_final/details/CreateFlashCard.dart';
import 'package:mobdev_final/details/CreateNote.dart';
import 'package:mobdev_final/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mobdev_final/main.dart';
import 'package:mobdev_final/services/flashcard.dart';
import 'package:mobdev_final/services/flashcardSet.dart';
import 'package:mobdev_final/services/StorageService.dart';
import 'package:flip_card/flip_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Flashcard());
}

class Flashcard extends StatefulWidget {
  static const String routeName = "flashcard";
  final String? setTitle;
  final String? setuid;

  const Flashcard({super.key, this.setTitle, this.setuid});

  @override
  State<Flashcard> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<Flashcard> {
  StorageService storageService = StorageService();
  final FlashCardService flashCardService = FlashCardService();

  late List<FlashcardModel> _flashcards;
  int _currIndex = 0;

  @override
  void initState() {
    super.initState();
    _flashcards = []; // Initialize with your actual flashcards data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(217, 178, 169, 1),
      appBar: AppBar(
        title: const Text(
          'FlashMaster',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: primary,
        shadowColor: Color(0),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            padding: EdgeInsets.all(5.0),
            color: Colors.amber,
            onPressed: () {
              signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: 300.0,
          height: 400.0,
          child: StreamBuilder<QuerySnapshot>(
            stream: flashCardService.getCardsStream(widget.setuid ?? ''),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                _flashcards.clear(); // Clear existing data
                List notesList = snapshot.data!.docs;
                for (int index = 0; index < notesList.length; index++) {
                  DocumentSnapshot document = notesList[index];
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String noteQuestion = data['question'] ?? '';
                  String noteAnswer = data['answer'] ?? '';

                  // Convert Firebase data to FlashcardModel
                  FlashcardModel flashcard =
                      FlashcardModel(noteQuestion, noteAnswer);

                  // Add the FlashcardModel to the _flashcards list
                  _flashcards.add(flashcard);
                }

                return Card(
                  elevation: 4,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: FlipCard(
                          front: Center(
                            child: Text(
                              'Question: ${_flashcards[_currIndex].question}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          back: Center(
                            child: Text(
                              'Answer: ${_flashcards[_currIndex].answer}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          OutlinedButton.icon(
                            onPressed: previousCard,
                            icon: Icon(Icons.chevron_left),
                            label: Text('Prev'),
                          ),
                          OutlinedButton.icon(
                            onPressed: nextCard,
                            icon: Icon(Icons.chevron_right),
                            label: Text('Next'),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return const Text('Bushet');
              }
            }),
          ),
        ),
      ),
    );
  }

  void nextCard() {
    setState(() {
      _currIndex = (_currIndex + 1 < _flashcards.length) ? _currIndex + 1 : 0;
    });
  }

  void previousCard() {
    setState(() {
      _currIndex =
          (_currIndex - 1 >= 0) ? _currIndex - 1 : _flashcards.length - 1;
    });
  }

  signOut() async {
    try {
      await storageService.deleteAllData();
      print("Logout na");
      Navigator.pushReplacementNamed(context, MainScreen.routeName);
    } catch (e) {
      print(e);
    }
  }
}

class FlashcardModel {
  final String question;
  final String answer;

  FlashcardModel(this.question, this.answer);
}
