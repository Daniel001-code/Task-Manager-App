// -------------------------
// Task Model
// -------------------------
class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime createdTime;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.createdTime,
  });

  Task copyWith(
      {int? id, String? title, String? description, DateTime? createdTime}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdTime': createdTime.toIso8601String(),
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdTime: DateTime.parse(map['createdTime']),
    );
  }
}
