import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderUsername;
  final String recieverID;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    required this.senderUsername,
    required this.recieverID,
    required this.message,
    required this.timestamp,
  });

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderUsername': senderUsername,
      'recieverID': recieverID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
