import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firechat/api/group_chat.dart';
import 'package:firechat/model/group.dart';
import 'package:firechat/model/group_message.dart';
import 'package:flutter/material.dart';

class GroupChat extends StatefulWidget {
  Group group;
  String gid;

  GroupChat(this.group, this.gid);

  @override
  State<StatefulWidget> createState() => GroupChatState();
}

class GroupChatState extends State<GroupChat> {
  var msg = TextEditingController();
  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;
  late User user;
  StreamController<QuerySnapshot<Map<String, dynamic>>> controller =
      StreamController();

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    stream = GroupChatApi().getMessages(widget.gid);

    stream.listen((res) {
      res.docChanges.forEach((element) {
        switch (element.type) {
          case DocumentChangeType.added:
            break;
          case DocumentChangeType.modified:
            // TODO: Handle this case.
            break;
          case DocumentChangeType.removed:
            // TODO: Handle this case.
            break;
        }
      });
    });
    controller.addStream(stream);
    super.initState();
  }

  @override
  void dispose() {
    msg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.group.name),
        ),
        body: Stack(
          children: [
            StreamBuilder(
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                      snapshots) {
                if (!snapshots.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        alignment:
                            snapshots.data!.docs[index].data()['sender_uid'] ==
                                    user.uid
                                ? Alignment.topRight
                                : Alignment.topLeft,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: snapshots.data!.docs[index]
                                          .data()['sender_uid'] ==
                                      user.uid
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              decoration: BoxDecoration(
                                color: snapshots.data!.docs[index]
                                            .data()['sender_uid'] ==
                                        user.uid
                                    ? Colors.blue
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                snapshots.data!.docs[index].data()['message'],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: snapshots.data!.docs.length,
                  );
                }
              },
              stream: stream,
            ),
            Align(
              child: TextFormField(
                controller: msg,
                decoration: InputDecoration(
                  hintText: 'Message',
                  suffix: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      String text = msg.text.trim();
                      GroupChatApi().addMessage(GroupMessage(
                          gid: widget.gid,
                          sender_uid: user.uid,
                          message: text,
                          sender_name: user.displayName!));
                      msg.clear();
                    },
                  ),
                ),
              ),
              alignment: Alignment.bottomCenter,
            )
          ],
        ),
      );
}
