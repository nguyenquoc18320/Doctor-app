import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  String? id;
  String? chatroom_id;
  String message;
  String receiver;
  String sender;
  DateTime time;

  ChatMessage(
      {this.id,
      required this.chatroom_id,
      required this.message,
      required this.receiver,
      required this.sender,
      required this.time});

  Map<String, dynamic> toJson() {
    return {
      'chatroom_id': chatroom_id,
      'message': message,
      'receiver': receiver,
      'sender': sender,
      'time': time,
    };
  }

  ChatMessage.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        chatroom_id = doc.data()!["chatroom_id"],
        message = doc.data()!["message"],
        receiver = doc.data()!["receiver"],
        sender = doc.data()!["sender"],
        time = doc.data()!["time"].toDate();
}
