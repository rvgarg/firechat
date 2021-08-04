class Message {
  late final String msg, sender_uid, receiver_uid, sender_email, receiver_email;
  late final DateTime time;

  Message(
      {required this.msg,
      required this.receiver_email,
      required this.receiver_uid,
      required this.sender_email,
      required this.sender_uid,
      time}) {
    this.time = time ?? DateTime.now();
  }

  toJSON() => {
        'sender_uid': this.sender_uid,
        'msg': this.msg,
        'sender_email': this.sender_email,
        'time': this.time,
        'receiver_uid': this.receiver_uid,
        'receiver_email': this.receiver_email
      };

  factory Message.fromJSON(Map<String, dynamic> json) {
    return Message(
        msg: json['msg'],
        sender_email: json['sender_email'],
        receiver_email: json['receiver_email'],
        receiver_uid: json['receiver_uid'],
        sender_uid: json['sender_uid'],
        time: json['time']);
  }
}
