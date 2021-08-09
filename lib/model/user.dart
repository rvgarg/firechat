class User {
  final String uid, email, name;
  String? pic_link;

  User(
      {required this.uid,
      required this.email,
      required this.name,
      this.pic_link});

  toJSON() => {
        'uid': this.uid,
        'email': this.email,
        'name': this.name,
        'pic_link': this.pic_link
      };

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
        uid: json['uid'],
        email: json['email'],
        name: json['name'],
        pic_link: json['pic_link']);
  }
}
