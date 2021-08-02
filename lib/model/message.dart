class Message {
  late final String msg, uid, dname;
  late final DateTime time;

  Message(
      {required String msg, required String uid, required String dname, time}) {
    this.uid = uid;
    this.msg = msg;
    this.dname = dname;
    this.time = time ?? DateTime.now();
  }

  toJSON() => {
        'uid': this.dname,
        'msg': this.msg,
        'dname': this.dname,
        'time': this.time
      };

  factory Message.fromJSON(Map<String, dynamic> json) {
    return Message(
        msg: json['msg'],
        uid: json['uid'],
        dname: json['dname'],
        time: json['time']);
  }
}
