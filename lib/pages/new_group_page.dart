import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/api/chat_api.dart';
import 'package:firechat/api/group_api.dart';
import 'package:firechat/model/group.dart';
import 'package:firechat/model/user.dart';
import 'package:flutter/material.dart';

class NewGroupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewGroupState();
}

class NewGroupState extends State<NewGroupPage> {
  List<User> new_g = [];
  var name = TextEditingController();
  var key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            children: [
              Form(
                child: TextFormField(
                  controller: name,
                  validator: (value) {
                    if (value == null) return 'Group Name is required';
                  },
                  decoration: InputDecoration(
                    labelText: 'Group Name',
                  ),
                ),
                key: key,
              ),
              StreamBuilder(
                builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) =>
                    snapshot.hasData
                        ? ListView.builder(
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                new_g.add(User.fromJSON(
                                    snapshot.data!.docs[index].data()));
                              },
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: snapshot.data!.docs[index]
                                                    ['pic_link'] ==
                                                null
                                            ? Icon(Icons.person)
                                            : Image.network(
                                                snapshot.data!.docs[index]
                                                    ['pic_link'],
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
                            ),
                            itemCount: snapshot.data!.docs.length,
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                stream: ChatApi().getList(),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () => GroupApi()
              .addGroup(Group(participants: new_g, name: name.text.trim())),
        ),
      );
}
