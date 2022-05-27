import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_app/models/chat_message.dart';
import 'package:doctor_app/models/chat_room.dart';
import 'package:doctor_app/models/userFirebase.dart';
import 'package:doctor_app/services/database.dart';
import 'package:doctor_app/widgets/base/TextFieldPrimary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class ResultUser extends StatefulWidget {
  final UserFirebase receiver;
  const ResultUser({Key? key, required this.receiver}) : super(key: key);

  @override
  State<ResultUser> createState() => _ResultUserState();
}

class _ResultUserState extends State<ResultUser> {
  ChatRoom? chatroom;
  DatabaseMethod _databaseMethod = DatabaseMethod();

  TextEditingController message = new TextEditingController();

  Future<ChatRoom?>? fetchChatroomWithUsers() {
    _databaseMethod
        .getChatRoomByUsers(loginUser!.uid, widget.receiver.id!)
        .then((res) {
      setState(() {
        chatroom = res;
      });
      return res;
    });
  }

  getCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      loginUser = user;
    }
  }

  sendMessage() async {
    print('Send message');
    if (chatroom == null) {
      print('Create new chatroom and send message');
      List<String> users = [loginUser!.uid, widget.receiver.id!];
      String content_message = message.text;
      DateTime now = DateTime.now();

      ChatRoom newChatRoom = ChatRoom(
          users: users, latest_message: content_message, latest_updated: now);

      ChatRoom savedChatRoom =
          await _databaseMethod.createChatRoom(newChatRoom);

      setState(() {
        chatroom = savedChatRoom;
      });

      ChatMessage newMessage = ChatMessage(
          chatroom_id: savedChatRoom.id,
          message: content_message,
          receiver: widget.receiver.id!,
          sender: loginUser!.uid,
          time: now);

      await _databaseMethod.addMessage(newMessage);

      message.clear();
    } else {
      String content_message = message.text;
      DateTime now = DateTime.now();

      ChatMessage newMessage = ChatMessage(
          chatroom_id: chatroom!.id,
          message: content_message,
          receiver: widget.receiver.id!,
          sender: loginUser!.uid,
          time: now);

      await _databaseMethod.addMessage(newMessage);

      chatroom!.setLatestMessage(content_message);
      chatroom!.setLatestUpdated(now);

      await _databaseMethod.updateChatRoom(chatroom!.id!, chatroom!);

      message.clear();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  StreamBuilder<QuerySnapshot> buildStreamMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('messages')
          .where('chatroom_id', isEqualTo: chatroom!.id)
          .orderBy('time')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16),
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            primary: true,
            physics: ScrollPhysics(),
            itemBuilder: (context, index) {
              QueryDocumentSnapshot x = snapshot.data!.docs[index];
              return ListTile(
                dense: true,
                title: _messageWidget(
                    loginUser!.uid == x['sender'], x['message'], x['time']),
              );
            });
      },
    );
  }

  Widget _messageWidget(isSender, content, time) {
    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xFF3A3C30).withOpacity(0.2),
                width: 1,
              ),
              color: isSender ? Color(0xFF8856EB) : Color(0xFFF59591),
            ),
            child: Text(
              content,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSender ? Colors.white : Colors.black),
            )),
      ],
    );
  }

  FutureBuilder<ChatRoom?> buildFutureChatRoom() {
    return FutureBuilder<ChatRoom?>(
        future: fetchChatroomWithUsers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError || !snapshot.hasData) {
                return buildNoChatroom();
              } else {
                return Container(
                  child: Center(
                    child: Text(snapshot.data!.id.toString()),
                  ),
                );
              }
          }
        });
  }

  buildChatRoom() {
    if (chatroom != null) {
      return buildStreamMessages();
    } else {
      return buildFutureChatRoom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiver.name),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: buildChatRoom(),
              reverse: true,
              physics: ScrollPhysics(),
            )),
            Container(
              padding: EdgeInsets.only(top: 8, left: 16, right: 4, bottom: 8),
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                          child: TextFieldPrimary(
                            title: 'Messages',
                            textController: message,
                          )
                          // child: TextFormField(
                          //   controller: message,
                          //   decoration: InputDecoration(
                          //     filled: true,
                          //     fillColor: Color(0xFFFFFFFF),
                          //     hintText: "Messages",
                          //     hintStyle: TextStyle(color: Colors.black38),
                          //     border: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             width: 1.0,
                          //             color:
                          //                 Color(0xFF3A3C30).withOpacity(0.2)),
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(24.0))),
                          //     focusedBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             width: 1.0,
                          //             color:
                          //                 Color(0xFF3A3C30).withOpacity(0.2)),
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(24.0))),
                          //     enabledBorder: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //             width: 1.0,
                          //             color:
                          //                 Color(0xFF3A3C30).withOpacity(0.2)),
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(24.0))),
                          //     contentPadding: EdgeInsets.symmetric(
                          //         horizontal: 16, vertical: 16),
                          //   ),
                          // )
                          )),
                  IconButton(
                      onPressed: () async {
                        if (message.text == '') {
                          return;
                        }
                        await sendMessage();
                      },
                      icon: Icon(Icons.send,
                          color: Theme.of(context).colorScheme.primary))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildNoChatroom() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text('Send message to connect with doctor!',
            style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
