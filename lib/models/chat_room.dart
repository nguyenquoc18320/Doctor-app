import 'package:cloud_firestore/cloud_firestore.dart';
import 'userFirebase.dart';
import 'chat_message.dart';

class ChatRoom {
  String? id;
  List<String> users;
  String latest_message;
  DateTime latest_updated;

  ChatRoom(
      {this.id,
      required this.users,
      required this.latest_message,
      required this.latest_updated});

  ChatRoom.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        users = List<String>.from(doc.data()!['users'].toList()),
        latest_message = doc.data()!['latest_message'],
        latest_updated = doc.data()!['latest_updated'].toDate();

  // factory ChatRoom.fromSnapshot(DocumentSnapshot snapshot) {
  //   final newPet = ChatRoom.fromJson(snapshot.data() as Map<String, dynamic>);
  //   newPet.reference = snapshot.reference.id;
  //   return newPet;
  // }

  Map<String, dynamic> toJson() {
    return {
      'users': users,
      'latest_message': latest_message,
      'latest_updated': latest_updated,
    };
  }

  setLatestMessage(String latest_msg) {
    latest_message = latest_msg;
  }

  String getLatestMessage() {
    return latest_message;
  }

  setLatestUpdated(DateTime latest_upd) {
    latest_updated = latest_upd;
  }

  DateTime getLatestUpdated() {
    return latest_updated;
  }
}
