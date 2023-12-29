import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService{

  String getCurrentUserUid() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return user.uid;
  } else {
    // Handle the case when the user is not signed in
    return '';
  }
}

  //get collection of note
  final CollectionReference notes = 
    FirebaseFirestore.instance.collection('notes');

  //CREATE
  Future<void> addNote(String title, String content) async {
    String currentUserUid = getCurrentUserUid();
    if (currentUserUid.isNotEmpty) {
      await notes.add({
        'title': title,
        'content': content,
        'timestamp': Timestamp.now(),
        'userUid': currentUserUid,
      });
    }
  }

  //READ
Stream<QuerySnapshot> getNotesStream() {
  String currentUserUid = getCurrentUserUid();
  if (currentUserUid.isNotEmpty) {
    final getNotesStream = notes
        .where('userUid', isEqualTo: currentUserUid)
        .orderBy('timestamp', descending: true)
        .snapshots();
    
    getNotesStream.listen((QuerySnapshot querySnapshot) {
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      print("Document ID: ${document.id}, Content: ${data['content']}");
    }
  });
    return getNotesStream;
  } else {
    // Return an empty stream if the user is not logged in
    print('bilalat');
    return Stream<QuerySnapshot>.empty();
  }
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