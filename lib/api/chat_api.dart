import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/model/message.dart';
import 'package:firechat/model/user.dart';
import 'package:flutter/material.dart';

class ChatApi {
  late final CollectionReference reference;

  ChatApi() {
    reference = FirebaseFirestore.instance.collection('chat');
  }

  getList() => FirebaseFirestore.instance.collection('users').snapshots();

  getMessages(
          {required String sender_uid,
          required String sender_email,
          required String receiver_uid,
          required String receiver_email}) =>
      reference.where('sender_uid', whereIn: [sender_uid, receiver_uid]).where(
          'sender_email',
          whereIn: [
            sender_email,
            receiver_email
          ]).where('receiver_uid', whereIn: [receiver_uid, sender_uid]).where(
          'receiver_email',
          whereIn: [receiver_email, sender_email]).snapshots();

  addList({required User user}) async {
    if ((await FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: user.uid)
                .where('email', isEqualTo: user.email)
                .get())
            .size ==
        0) FirebaseFirestore.instance.collection('users').add(user.toJSON());
  }

  addMessage({required BuildContext context, required Message message}) async =>
      await reference.add(message.toJSON()).then((value) => print('sent'));
}
