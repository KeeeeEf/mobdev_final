import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  //get collection of note
  final CollectionReference notes = 
    FirebaseFirestore.instance.collection('notes');

  //CREATE
  Future<void> addNote(String title, String content){
    return notes.add({
      'title':title,
      'content':content,
      'timestamp': Timestamp.now(),
    });
  }

  //READ
  Stream<QuerySnapshot> getNotesStream(){
    final getNotesStream =
      notes.orderBy('timestamp', descending: true).snapshots();

    return getNotesStream;
  }

  //UPDATE
  Future<void> updateNote(String docID, String newTitle, String newContent){
    return notes.doc(docID).update({
      'title': newTitle,
      'content': newContent,
      'timestamp': Timestamp.now()
    });
  }

  //DElETE
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}