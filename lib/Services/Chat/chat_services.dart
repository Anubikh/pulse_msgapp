import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minimsgapp_pantaleta/Models/message.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  // Send messages
  Future<void> sendMessage(String recieverID, message) async {
    // Get user info
    final String currentUserID = _auth.currentUser!.uid;
    String currentUserUsername = _auth.currentUser!.email!;

    // Get username from Firestore if available
    final userDoc =
        await _firestore.collection("Users").doc(currentUserID).get();
    if (userDoc.exists) {
      currentUserUsername = userDoc.get("username") ?? currentUserUsername;
    }

    final Timestamp timestamp = Timestamp.now();

    // Create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderUsername: currentUserUsername,
      recieverID: recieverID,
      message: message,
      timestamp: timestamp,
    );

    // Construct chatroom ID
    List<String> ids = [currentUserID, recieverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // Add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //Construct chatroom ID for two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
