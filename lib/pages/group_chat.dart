import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
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
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: SizedBox(
                    height: 35,
                    width: 35,
                    child: CachedNetworkImage(
                      imageUrl: widget.group.pic_link!,
                    ),
                  ),
                ),
              ),
              Text(widget.group.name),
            ],
          ),
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
                                borderRadius: BorderRadius.circular(50),
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
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextFormField(
                        controller: msg,
                        decoration: InputDecoration(
                          hintText: 'Message',
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: EdgeInsets.all(5.0),
                        color: Colors.teal,
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
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
                  ],
                ),
              ),
              alignment: Alignment.bottomCenter,
            )
          ],
        ),
      );
}
