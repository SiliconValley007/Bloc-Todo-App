class Todo {
  final int? id;
  final int taskId;
  final String title;
  final bool isComplete;

  Todo({
    this.id,
    required this.taskId,
    required this.title,
    required this.isComplete,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'taskId': taskId,
      'title': title,
      'isComplete': isComplete.toString(),
    };
  }
}
