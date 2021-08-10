import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firechat/model/group.dart';
import 'package:flutter/material.dart';

class GroupApi {
  late final CollectionReference reference;

  GroupApi() {
    reference = FirebaseFirestore.instance.collection('groups');
  }

  addGroup(Group group, BuildContext context) async => reference
      .add(group.toJSON())
      .then((value) => Navigator.of(context).pop());

  getGroup() => reference.where('participants', arrayContains: {
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'email': FirebaseAuth.instance.currentUser!.email!,
        'name': FirebaseAuth.instance.currentUser!.displayName!,
        'pic_link': FirebaseAuth.instance.currentUser!.photoURL!
      }).snapshots();
}
