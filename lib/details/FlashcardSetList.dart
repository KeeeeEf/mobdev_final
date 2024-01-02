import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: Color.fromRGBO(217, 178, 169, 1),
      appBar: AppBar(
        title: Text(
          'Your Flashcards',
          style: GoogleFonts.robotoMono(
            color: Color.fromRGBO(165, 166, 143, 1),
          ),
        ),
        backgroundColor: primary,
        shadowColor: Color(0),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            padding: EdgeInsets.all(5.0),
            color: Color.fromRGBO(165, 166, 143, 1),
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
        hoverColor: Color.fromRGBO(250, 244, 227, 1),
        backgroundColor: Color.fromRGBO(244, 238, 237, 1),
        child: const Icon(
          Icons.add,
          size: 40.0,
          color: Color.fromRGBO(165, 166, 143, 1),
      ),
      ),
      
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: StreamBuilder<QuerySnapshot>(
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
              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(250, 244, 227, 0.30),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child:  ListTile(
                  title: Text(
                    noteTitle,
                    style: GoogleFonts.robotoMono(
                     fontSize: 14.0,
                     color: Colors.black,
                     fontWeight: FontWeight.w700
                    ),
                    ),
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
                        onPressed: () => flashCardSetService.deleteSet(docID),
                        icon: const Icon(
                          Icons.delete,
                           color: Color.fromRGBO(250, 244, 227, 1),
                          size: 20.0,
                          ),
                      ),
                    ],
                  ),
                ),
                  ),
              );
              },
            );
          } else {
            return const Text('');
          }
        }),
      ),
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
