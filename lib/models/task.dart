class Task {
  final String id;
  final String title;
  final bool isDone;

  const Task({required this.id, required this.title, this.isDone = false});

  Task copyWith({String? title, bool? isDone}) => Task(
        id: id,
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
      );
}
