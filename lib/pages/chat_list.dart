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
          return !snapshot.hasData ? Center(
              child: CircularProgressIndicator(),
            ) : ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                    onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(User.fromJSON(
                                  snapshot.data!.docs![index].data())))),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: snapshot.data!.docs[index]['pic_link'] ==
                                      null
                                  ? Icon(Icons.person)
                                  : Image.network(
                                      snapshot.data!.docs[index]['pic_link'],
                                      scale: 0.4,
                                    ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              snapshot.data!.docs[index]['name'],
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                );
              },
              itemCount: snapshot.data!.docs.length,
            );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.group_add),
      ),
    );
  }
}
