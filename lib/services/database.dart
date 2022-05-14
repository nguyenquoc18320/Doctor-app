import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_app/models/chat_message.dart';
import 'package:doctor_app/models/chat_room.dart';
import 'package:doctor_app/models/userFirebase.dart';

class DatabaseMethod {
  static final _db = FirebaseFirestore.instance;

  getUserByUsername(String username) async {
    var users = await _db
        .collection("users")
        .where('name', isGreaterThanOrEqualTo: username)
        .where('name', isLessThanOrEqualTo: username + '\uf8ff')
        .where('role', isEqualTo: 'Doctor')
        .get();
    return users;
  }

  getUserByUID(String uid) async {
    var user = await _db.collection("users").doc(uid).get();
    return user;
  }

  static Future<List<String>> searchUsers(String query) async {
    QuerySnapshot<Map<String, dynamic>> usersSnapshot = await _db
        .collection("users")
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .where('role', isEqualTo: 'Doctor')
        .get();

    return usersSnapshot.docs
        .map((docSnapshot) => docSnapshot.get('name').toString())
        .toList();
  }

  static Future<List<UserFirebase>> searchUsersFirebase(String query) async {
    QuerySnapshot<Map<String, dynamic>> usersSnapshot = await _db
        .collection("users")
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .where('role', isEqualTo: 'Doctor')
        .get();

    return usersSnapshot.docs
        .map((docSnapshot) => UserFirebase.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<UserFirebase>> retrieveUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("users").get();
    List<UserFirebase> listUser = snapshot.docs
        .map((docSnapshot) => UserFirebase.fromDocumentSnapshot(docSnapshot))
        .toList();

    listUser.forEach((element) {
      print("User: " + element.id!);
    });

    return listUser;
  }

  retrieveChatRooms() async {}

  getUserByEmail(String userEmail) async {
    var user = await _db
        .collection("users")
        .where('email', isEqualTo: userEmail)
        .get();
    return user;
  }

  uploadUserInfo(uid, userMap) {
    return _db.collection('users').doc(uid).set(userMap).catchError((e) {
      print(e.toString());
    });
  }

  Future<ChatRoom> createChatRoom(ChatRoom chatRoomMap) async {
    DocumentReference<Map<String, dynamic>> snapshot =
        await _db.collection('chat_rooms').add(chatRoomMap.toJson());

    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await snapshot.get();

    List<String> users =
        List<String>.from(docSnapshot.data()!['users'].toList());

    print("Users: " + users.toString());

    ChatRoom chatroom = ChatRoom.fromDocumentSnapshot(docSnapshot);
    return chatroom;
  }

  Future<bool> addMessage(ChatMessage chatMessage) async {
    bool result = false;
    await _db.collection('messages').add(chatMessage.toJson()).then((value) {
      if (value.id != null) {
        result = true;
      }
    }).catchError((e) {
      print(e.toString());
    });

    return result;
  }

  Future<bool> updateChatRoom(String chatroomId, ChatRoom newChatRoom) async {
    bool res = false;
    await _db
        .collection('chat_rooms')
        .doc(chatroomId)
        .set(newChatRoom.toJson())
        .then((value) {
      res = true;
    });

    return res;
  }

  getChatRoomById(chatRoomId) async {
    return await _db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .get()
        .catchError((e) => print(e.toString()));
  }

  getLatestMessageByChatRoomId(chatRoomId) async {
    print('chatRoomId: ' + chatRoomId);
    var latestMessage = await _db
        .collection('messages')
        .where('chat_room', isEqualTo: chatRoomId)
        .get();
    return latestMessage;
  }

  Future<ChatRoom> getChatRoomByUsers(String userId1, String userId2) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection('chat_rooms')
        .where('users', whereIn: [
          [userId1, userId2],
          [userId2, userId1]
        ])
        .limit(1)
        .get();

    ChatRoom chatroom = ChatRoom.fromDocumentSnapshot(snapshot.docs[0]);
    return chatroom;
  }

  Future<UserFirebase> getUserById(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection('users').doc(userId).get();

    UserFirebase user = UserFirebase.fromDocumentSnapshot(snapshot);
    return user;
  }

  getAllChatRoomByUser(user) async {
    var chatRoom = await _db
        .collection('chat_rooms')
        .where('users', arrayContains: user)
        .snapshots();
    return chatRoom;
  }
}
