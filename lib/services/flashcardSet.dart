import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobdev_final/services/flashcard.dart';

class FlashCardSetService{

  String getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null) {
      return user.uid;
    } else{
      return '';
    }
  }

  final CollectionReference cardSet = 
    FirebaseFirestore.instance.collection('cardSet');

    //CREATE
    Future<String?> addSet(String title) async {
      String currentUserUid = getCurrentUserUid();
      if (currentUserUid.isNotEmpty) {
        DocumentReference documentReference = await cardSet.add({
          'title': title,
          'timestamp': Timestamp.now(),
          'userUid': currentUserUid,
        });

        return documentReference.id; 
      } else {
        return null;
      }
    }

    //READ
    Stream<QuerySnapshot> getSetStream() {
      String currentUserUid = getCurrentUserUid();
      if (currentUserUid.isNotEmpty) {
        final getNotesStream = cardSet
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
        print('Not logged on!');
        return Stream<QuerySnapshot>.empty();
      }
    }

  //EDIT
  Future<void> updateSet(String docID, String newTitle){
    return cardSet.doc(docID).update({
      'title': newTitle,
      'timestamp': Timestamp.now()
    });
  }

  //DELETE
  Future<void> deleteSet(String docID) async {
    String setUid = docID; // Assuming the setUid is the same as the docID in this case
    await FlashCardService().deleteAllCardsForSet(setUid);
    await cardSet.doc(docID).delete();
  }
}