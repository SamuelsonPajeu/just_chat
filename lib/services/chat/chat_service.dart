import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_chat/models/message.dart';

class ChatService {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Get users list

  Stream<List<Map<String, dynamic>>> getUserStream() {
    return firebaseFirestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async {
    final String currentUserID = firebaseAuth.currentUser!.uid;
    final String currentUserEmail = firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: message,
      timestamp: timestamp,
    );

    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get message
  Stream<QuerySnapshot> getMessages(String currentUserID, senderID) {
    List<String> ids = [currentUserID, senderID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
