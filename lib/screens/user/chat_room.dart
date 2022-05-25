import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_app/plugins/UserFirebaseSearch.dart';
import '../../models/userFirebase.dart';
import '../../widgets/user/bottomNavigationBar.dart';
import '../../widgets/doctor/bottomNavigationBar.dart' as DoctorBottomBar;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../../services/auth.dart';
import '../../services/database.dart';
import 'Chat.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final auth = FirebaseAuth.instance;
  AuthMethod authMethod = new AuthMethod();
  DatabaseMethod _databaseMethod = DatabaseMethod();

  final storeMessage = FirebaseFirestore.instance;
  UserFirebase currentUser = UserFirebase();

  getCurrentUser() async {
    final user = auth.currentUser;
    if (user != null) {
      loginUser = user;
      final res = await _databaseMethod.getUserById(loginUser!.uid);
      setState(() {
        currentUser = res;
      });
    }
  }

  @override
  void initState() {
    getCurrentUser();
    fetchChatRoom();
    super.initState();
  }

  var chatRoomSnapshot;

  fetchChatRoom() async {
    setState(() {
      chatRoomSnapshot = FirebaseFirestore.instance
          .collection('chat_rooms')
          .where('users', arrayContains: loginUser!.uid)
          .orderBy('latest_updated', descending: true)
          .snapshots();
    });
  }

  Future<UserFirebase?> fetchUserInChatRoom(QueryDocumentSnapshot x) async {
    String anotherId = x['users'][0];
    if (x['users'][0] == loginUser!.uid) {
      anotherId = x['users'][1];
    }

    return await _databaseMethod.getUserById(anotherId).then((value) {
      return value;
    });
  }

  String getDateTimeSend(DateTime timeSend) {
    DateTime now = DateTime.now();
    if (timeSend.year == now.year) {
      if (timeSend.month == now.month && timeSend.day == now.day) {
        return '${timeSend.hour}:${timeSend.minute}';
      } else {
        return '${timeSend.day}/${timeSend.month}';
      }
    } else {
      return '${now.year - timeSend.year} years ago';
    }
  }

  Widget showChatRoomByUser() {
    return StreamBuilder<QuerySnapshot>(
      stream: chatRoomSnapshot,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            primary: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              QueryDocumentSnapshot x = snapshot.data!.docs[index];
              return Container(
                child: FutureBuilder<UserFirebase?>(
                  future: fetchUserInChatRoom(x),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return SkeletonLoader(
                          builder: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 30,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 10,
                                        color: Colors.white,
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        width: double.infinity,
                                        height: 12,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          period: Duration(seconds: 2),
                          highlightColor: Colors.lightBlue.shade300,
                          direction: SkeletonDirection.ltr,
                        );
                      default:
                        if (snapshot.hasError || !snapshot.hasData) {
                          return Container(
                            child: Center(
                              child: Text('No Chat Found'),
                            ),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Color(0xFFFFFFFF),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ResultUser(
                                                receiver: snapshot.data!)));
                              },
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              leading: CircleAvatar(
                                radius: 32.0,
                                backgroundImage:
                                    NetworkImage(snapshot.data!.avatar_url),
                              ),
                              // title: Text(suggestion),
                              title: Text(
                                snapshot.data!.name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    x['latest_message'].length > 28
                                        ? x['latest_message'].substring(0, 28) +
                                            '...'
                                        : x['latest_message'],
                                    maxLines: 1,
                                  )),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(getDateTimeSend(
                                      x['latest_updated'].toDate())),
                                ],
                              ),
                            ),
                          );
                        }
                    }
                  },
                ),
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Chats',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: currentUser?.role == 'User'
              ? [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      final result = showSearch(
                          context: context, delegate: UserFirebaseSearch());
                    },
                  ),
                ]
              : null),
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: showChatRoomByUser(),
          ),
        )
      ]),
      bottomNavigationBar: currentUser.role == 'User'
          ? BottomNavigationBarCustom(currentIndex: 3)
          : DoctorBottomBar.BottomNavigationBarCustom(currentIndex: 3),
    );
  }
}
