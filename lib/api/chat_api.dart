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
      reference
          .where('sender_uid', isEqualTo: sender_uid)
          .where('sender_email', isEqualTo: sender_email)
          .where('receiver_uid', isEqualTo: receiver_uid)
          .where('receiver_email', isEqualTo: receiver_email)
          .snapshots();

  addList({required User user}) async {
    if ((await FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: user.uid)
                .where('email', isEqualTo: user.email)
                .get())
            .size ==
        0) reference.add(user.toJSON());
  }

  addMessage({required BuildContext context, required Message message}) async {
    reference.add(message.toJSON()).then((value) => print('sent'));
  }
}
