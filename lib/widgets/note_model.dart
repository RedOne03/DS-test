class Note {
  int? id;
  String text;
  String time;

  Note({this.id, required this.text, required this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'time': time,
    };
  }
}