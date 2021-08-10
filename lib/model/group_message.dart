class GroupMessage {
  String gid, sender_uid, message, sender_name;
  late DateTime time;

  GroupMessage(
      {required this.gid,
      required this.sender_uid,
      required this.message,
      required this.sender_name}) {
    time = DateTime.now();
  }

  toJSON() => {
        'gid': this.gid,
        'time': this.time,
        'message': this.message,
        'sender_uid': this.sender_uid,
        'sender_name': this.sender_name
      };
}
