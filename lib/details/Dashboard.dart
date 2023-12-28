import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobdev_final/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:mobdev_final/services/firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Dashboard());
}

class Dashboard extends StatefulWidget {
  static const String routeName = "dashboard";
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<Dashboard> {

  //firestore
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController  textController = TextEditingController();


  void openNoteBox({String? docID}){
    showDialog(
      context: context, 
      builder: (context)=> AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: (){

              if(docID == null){
                firestoreService.addNote('bilat', textController.text);
              }

              //update
              else{
                firestoreService.updateNote(docID, 'bilat', textController.text);
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
      appBar: AppBar(
        title: const Text(
          'Want an Advices?',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        shadowColor: Color(0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: ((context, snapshot){
          if(snapshot.hasData){
            List notesList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: notesList.length,
              itemBuilder: (context, index){
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
                        onPressed: ()=> openNoteBox(docID: docID),
                        icon: const Icon(Icons.settings),
                      ),
                      IconButton(
                        onPressed: ()=> firestoreService.deleteNote(docID),
                        icon: const Icon(Icons.delete),
                      ),
                  ],)
                );
              },
            );
          }else{
            return const Text('Bushet');
          }

        }),
      ),
    );
  }
}
