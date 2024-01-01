import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobdev_final/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobdev_final/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mobdev_final/main.dart';
import 'package:mobdev_final/services/firestore.dart';
import 'package:mobdev_final/services/StorageService.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Notes());
}

class Notes extends StatefulWidget {
  static const String routeName = "notes";
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<Notes> {
  StorageService storageService = StorageService();
  //firestore
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController textController = TextEditingController();

  void openNoteBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID == null) {
                        firestoreService.addNote('bilat', textController.text);
                      }

                      //update
                      else {
                        firestoreService.updateNote(
                            docID, 'bilat', textController.text);
                      }

                      //clear the text controller
                      textController.clear();

                      //close the box
                      Navigator.pop(context);
                    },
                    child: Text("Save"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(217, 178, 169, 1),
      appBar: AppBar(
        title: Text(
          'QuizMaster',
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
            color: Colors.amber,
            onPressed: () {
              signOut();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
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
                String noteText = data['content'];

                //display as a list tile
                return ListTile(
                    title: Text(noteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => openNoteBox(docID: docID),
                          icon: const Icon(
                            Icons.settings,
                            color: Color.fromRGBO(250, 244, 227, 1) ,
                            size: 10.0,
                            ),
                        ),
                        IconButton(
                          onPressed: () => firestoreService.deleteNote(docID),
                          icon: const Icon(
                            Icons.delete,
                            color: Color.fromRGBO(250, 244, 227, 1),
                            size: 10.0,
                            ),
                        ),
                      ],
                    ));
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