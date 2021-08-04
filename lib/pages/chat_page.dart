import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firechat/api/chat_api.dart';
import 'package:firechat/model/message.dart';
import 'package:firechat/model/user.dart' as u;
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final u.User receiver;

  ChatPage(this.receiver);

  @override
  State<StatefulWidget> createState() => ChatePageState();
}

class ChatePageState extends State<ChatPage> {
  var msg = TextEditingController();
  var stream1, stream;

  @override
  void initState() {
    User current = FirebaseAuth.instance.currentUser!;
    stream = ChatApi().getMessages(
        receiver_email: widget.receiver.email,
        receiver_uid: widget.receiver.uid,
        sender_uid: current.uid,
        sender_email: current.email!);
    stream1 = ChatApi().getMessages(
        sender_uid: current.uid,
        sender_email: current.email!,
        receiver_uid: widget.receiver.uid,
        receiver_email: widget.receiver.email);
    stream.listen((res) {
      res.docChanges.forEach((re) {
        switch (re.type) {
          case DocumentChangeType.added:
            // stream1.sink(re.doc.data());
            break;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.receiver.name),
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
                        alignment: snapshots.data!.docs[index]['sender_uid'] ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        padding: EdgeInsets.all(10),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                            alignment: snapshots.data!.docs[index]
                                        ['sender_uid'] ==
                                    FirebaseAuth.instance.currentUser!.uid
                                ? Alignment.topRight
                                : Alignment.topLeft,
                            decoration: BoxDecoration(
                              color: snapshots.data!.docs[index]
                                          ['sender_uid'] ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? Colors.blue
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              snapshots.data!.docs[index]['msg'],
                            ),
                          ),
                        ]),
                      );
                    },
                    itemCount: snapshots.data!.docs.length,
                  );
                }
              },
              stream: stream1,
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
                      ChatApi().addMessage(
                        context: context,
                        message: Message(
                            msg: text,
                            sender_email:
                                FirebaseAuth.instance.currentUser!.email!,
                            sender_uid: FirebaseAuth.instance.currentUser!.uid,
                            receiver_uid: widget.receiver.uid,
                            receiver_email: widget.receiver.email),
                      );
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

  @override
  void dispose() {
    msg.dispose();
    super.dispose();
  }
}
