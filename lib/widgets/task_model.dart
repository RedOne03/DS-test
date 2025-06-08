class Task {
  int? id;
  String title;
  String description;
  String startTime;
  String endTime;
  DateTime date;
  String userId;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'date': date.toIso8601String(),
      'userId': userId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      date: DateTime.parse(map['date']),
      userId: map['userId'],
    );
  }
}