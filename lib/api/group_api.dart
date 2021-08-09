import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firechat/model/group.dart';

class GroupApi {
  late final CollectionReference reference;

  GroupApi() {
    reference = FirebaseFirestore.instance.collection('groups');
  }

  addGroup(Group group) async => reference.add(group.toJSON());

  getGroup() => reference.snapshots();
}
