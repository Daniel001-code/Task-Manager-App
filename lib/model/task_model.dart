// -------------------------
// Task Model
// -------------------------
class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime createdTime;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.createdTime,
    required this.isCompleted,
  });

  Task copyWith(
      {int? id,
      String? title,
      String? description,
      DateTime? createdTime,
      bool? isCompleted}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdTime: createdTime ?? this.createdTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdTime': createdTime.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      createdTime: DateTime.parse(map['createdTime']),
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
