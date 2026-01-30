class Todo {
  final String id;
  final String title;
  final bool isDone;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Todo copyWith({
    String? id,
    String? title,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
