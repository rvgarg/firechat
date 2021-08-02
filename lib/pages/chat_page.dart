import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firechat/api/chat_api.dart';
import 'package:firechat/model/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatePageState();
}

class ChatePageState extends State<ChatPage> {
  var msg = TextEditingController();
  var stream = ChatApi().getMessage();
  var stream1 = ChatApi().getMessage();

  @override
  Widget build(BuildContext context) => Scaffold(
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
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: Align(
                          alignment: snapshots.data!.docs[index]['uid'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: snapshots.data!.docs[index]['uid'] ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? Colors.blue
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Text(
                              snapshots.data!.docs[index]['msg'],
                            ),
                          ),
                        ),
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
                      String user = FirebaseAuth.instance.currentUser!.uid;
                      String name =
                          FirebaseAuth.instance.currentUser!.displayName ?? '';
                      ChatApi api = ChatApi();
                      api.addMessage(
                          context: context,
                          message: Message(msg: text, uid: user, dname: name));
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
  void initState() {
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
  void dispose() {
    msg.dispose();
    super.dispose();
  }
}
