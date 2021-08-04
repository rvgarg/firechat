class User {
  final String uid, email;

  User({required this.uid, required this.email});

  toJSON() => {'uid': this.uid, 'email': this.email};

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(uid: json['uid'], email: json['email']);
  }
}
