import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/api/chat_api.dart';
import 'package:firechat/model/user.dart';
import 'package:firechat/pages/chat_page.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: ChatApi().getList(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(User.fromJSON(
                                  snapshot.data!.docs![index].data()))));
                    },
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Icon(
                              Icons.person,
                              size: 30,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(snapshot.data!.docs[index]['name'],style: TextStyle(fontSize: 20),),
                          ),
                        ),
                      ],
                    ));
              },
              itemCount: snapshot.data!.docs.length,
            );
          }
        },
      ),
    );
  }
}
