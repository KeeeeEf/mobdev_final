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

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Flashcard 123',
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
      body: StreamBuilder<QuerySnapshot>(
        stream: flashCardService.getCardsStream(widget.setuid ?? ''), 
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index) {
                //get each indiv doc
                DocumentSnapshot document = notesList[index];
                String docID = document.id;

                //get note from the doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String noteQuestion = data['question'] ?? '';
                String noteAnswer = data['answer'] ?? '';  


                //display as a list tile
                return ListTile(
                  trailing: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Question: ${noteQuestion}'),
                      Text('Answer: ${noteAnswer}')
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text('Bushet');
          }
        }),
      ),
    );
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
