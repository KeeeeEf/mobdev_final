import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlashCardService {
  String getCurrentUserUid() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  final CollectionReference cards =
      FirebaseFirestore.instance.collection('cards');

  // CREATE
  Future<void> addCard(String question, String answer, String setUid) async {
    if (setUid.isNotEmpty) {
      await cards.add({
        'question': question,
        'answer': answer,
        'timestamp': Timestamp.now(),
        'setUid': setUid,
      });
    }
  }

  // READ
  Stream<QuerySnapshot> getCardsStream(String setUid) {
    print('setuidssss: ${setUid}');
    if (setUid.isNotEmpty) {
      final getCardsStream = cards
          .where('setUid', isEqualTo: setUid)
          .orderBy('timestamp', descending: true)
          .snapshots();

      getCardsStream.listen((QuerySnapshot querySnapshot) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;
          print("Document ID: ${document.id}, Question: ${data['question']}");
        }
      });
      return getCardsStream;
    } else {
      print('Invalid setUid!');
      return Stream<QuerySnapshot>.empty();
    }
  }



  // EDIT
  Future<void> updateCard(String docID, String newQuestion, String newAnswer) {
    print('backend: ${docID}');
    return cards.doc(docID).update({
      'question': newQuestion,
      'answer': newAnswer,
      'timestamp': Timestamp.now(),
    });
  }

  // DELETE
  Future<void> deleteCard(String docID) {
    return cards.doc(docID).delete();
  }

  // DELETE ALL
  Future<void> deleteAllCardsForSet(String setUid) async {
    QuerySnapshot querySnapshot =
        await cards.where('setUid', isEqualTo: setUid).get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      await cards.doc(document.id).delete();
    }
  }
}
