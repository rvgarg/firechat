import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/model/message.dart';
import 'package:flutter/material.dart';

class ChatApi {
  late final CollectionReference reference;

  ChatApi() {
    reference = FirebaseFirestore.instance.collection('chat');
  }

  getMessage() => reference.orderBy('time').snapshots();

  addMessage({required BuildContext context, required Message message}) async {
    reference.add(message.toJSON()).then((value) => print('sent'));
  }
}
