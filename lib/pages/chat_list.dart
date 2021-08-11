import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firechat/api/chat_api.dart';
import 'package:firechat/api/group_api.dart';
import 'package:firechat/model/group.dart';
import 'package:firechat/model/user.dart' as u;
import 'package:firechat/pages/chat_page.dart';
import 'package:firechat/pages/group_chat.dart';
import 'package:firechat/pages/new_group_page.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Chats'),
            actions: [
              IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed('/login');
                    });
                  },
                  icon: Icon(Icons.logout))
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Chat',
                ),
                Tab(
                  text: 'Group',
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [getChatView(), getGroupView()],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewGroupPage()));
            },
            child: Icon(Icons.group_add),
          ),
        ));
  }

  getChatView() => StreamBuilder(
        stream: ChatApi().getList(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(u.User.fromJSON(
                                  snapshot.data!.docs[index].data())))),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: snapshot.data!.docs[index]['pic_link'] ==
                                        null
                                    ? Icon(Icons.person)
                                    : SizedBox(
                                        child: Image.network(
                                          snapshot.data!.docs[index]
                                              ['pic_link'],
                                          scale: 0.4,
                                        ),
                                        height: 35,
                                        width: 35,
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
      );

  getGroupView() => StreamBuilder(
        stream: GroupApi().getGroup(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupChat(
                                  Group.fromJSON(
                                      snapshot.data!.docs[index].data()),
                                  snapshot.data!.docs[index].id))),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: snapshot.data!.docs[index]
                                              ['pic_link'] ==
                                          null
                                      ? Icon(Icons.person)
                                      : SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: Image.network(
                                            snapshot.data!.docs[index]
                                                ['pic_link'],
                                            scale: 0.4,
                                          ),
                                        )),
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
      );
}
