class User {
  final String uid, email, name;

  User({required this.uid, required this.email, required this.name});

  toJSON() => {'uid': this.uid, 'email': this.email, 'name': this.name};

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(uid: json['uid'], email: json['email'], name: json['name']);
  }
}
