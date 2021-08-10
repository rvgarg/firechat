class Group {
  final List<dynamic> participants;
  final String name;
  final String? pic_link;

  Group({required this.participants, required this.name, this.pic_link});

  toJSON() => {
        'participants': this.participants,
        'name': this.name,
        'pic_link': this.pic_link
      };

  factory Group.fromJSON(Map<String, dynamic> json) {
    return Group(
        participants: json['participants'],
        name: json['name'],
        pic_link: json['pic_link']);
  }
}
