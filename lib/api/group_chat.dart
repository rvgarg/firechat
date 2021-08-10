import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/model/group_message.dart';

class GroupChatApi {
  late CollectionReference reference;

  GroupChatApi() {
    this.reference = FirebaseFirestore.instance.collection('group_messages');
  }

  addMessage(GroupMessage message) async =>
      await reference.add(message.toJSON());

  getMessages(String gid) =>
      reference.where('gid', isEqualTo: gid).snapshots();
}
