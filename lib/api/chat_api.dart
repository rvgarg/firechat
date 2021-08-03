import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/model/message.dart';
import 'package:flutter/material.dart';

class ChatApi {
  late final CollectionReference reference;

  ChatApi() {
    reference = FirebaseFirestore.instance.collection('chat');
  }

  getList() => reference.snapshots();

  getMessages({required String uid}) =>
      reference.doc(uid).collection('chat').snapshots();

  addList({required String uid}) async {
    if ((await reference.where('uid', isEqualTo: uid).get()).size == 0)
      reference.add({'uid': uid});
  }

  addMessage(
      {required BuildContext context,
      required Message message,
      required String uid}) async {
    reference
        .doc(uid)
        .collection('chat')
        .add(message.toJSON())
        .then((value) => print('sent'));
  }
}
