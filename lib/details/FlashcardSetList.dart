import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobdev_final/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobdev_final/details/CreateFlashCard.dart';
import 'package:mobdev_final/details/CreateNote.dart';
import 'package:mobdev_final/details/Flashcard.dart';
import 'package:mobdev_final/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mobdev_final/main.dart';
import 'package:mobdev_final/services/flashcardSet.dart';
import 'package:mobdev_final/services/StorageService.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FlashCardSetList());
}

class FlashCardSetList extends StatefulWidget {
  static const String routeName = "flashcardSetList";
  const FlashCardSetList({super.key});

  @override
  State<FlashCardSetList> createState() => _FlashCardSetListScreenState();
}

class _FlashCardSetListScreenState extends State<FlashCardSetList> {
  StorageService storageService = StorageService();
final FlashCardSetService flashCardSetService = FlashCardSetService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QuizMaster',
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, CreateFlashcard.routeName);
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: flashCardSetService.getSetStream(),
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
                String noteTitle = data['title'] ?? ''; // Provide a default value if 'title' is null


                //display as a list tile
                return ListTile(
                  title: Text(noteTitle),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Flashcard(setTitle: noteTitle, setuid: docID),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.settings),
                      ),
                      IconButton(
                        onPressed: () => flashCardSetService.deleteSet(docID),
                        icon: const Icon(Icons.delete),
                      ),
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
