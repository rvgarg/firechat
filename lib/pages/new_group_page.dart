import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firechat/api/chat_api.dart';
import 'package:firechat/api/group_api.dart';
import 'package:firechat/model/group.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewGroupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewGroupState();
}

class NewGroupState extends State<NewGroupPage> {
  List<Map<String, dynamic>> new_g = [];
  var name = TextEditingController();
  var key = GlobalKey<FormState>();
  File? _image;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Form(
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
        ),
        body: Column(
          children: [
            ClipRRect(
              child: _image != null
                  ? Image.file(
                      _image!,
                      height: 60,
                      width: 60,
                    )
                  : IconButton(
                      onPressed: () => showPicker(),
                      icon: Icon(
                        Icons.image_outlined,
                        color: Colors.black,
                      ),
                      iconSize: 60,
                    ),
              borderRadius: BorderRadius.circular(50),
            ),
            StreamBuilder(
              builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) =>
                  snapshot.hasData
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              new_g.add(snapshot.data!.docs[index].data());
                            },
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
                                              height: 35,
                                              width: 35,
                                              child: CachedNetworkImage(
                                                height: 35,
                                                width: 35,
                                                imageUrl: snapshot.data!
                                                    .docs[index]['pic_link'],
                                              ),
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () async {
            if (_image != null) {
              UploadTask task =
                  FirebaseStorage.instance.ref(_image!.path).putFile(_image!);
              var path = await (await task).ref.getDownloadURL();
              print(path);
              print(name.text.trim());
              GroupApi().addGroup(
                  Group(
                      participants: new_g,
                      name: name.text.trim(),
                      pic_link: path),
                  context);
            } else {
              GroupApi().addGroup(
                  Group(participants: new_g, name: name.text.trim()), context);
            }
          },
        ),
      );

  void showPicker() => showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      });

  _imgFromCamera() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }

  _imgFromGallery() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }
}
