enum TaskStatus { naoIniciada, emDesenvolvimento, parada }

class TaskComment {
  final String author;
  final String text;

  const TaskComment(this.author, this.text);
}

class TaskCardModel {
  final String title;
  final String assigneeInitials;
  final TaskStatus status;
  final String? blockedReason;
  final List<TaskComment> comments;

  const TaskCardModel({
    required this.title,
    required this.assigneeInitials,
    required this.status,
    this.blockedReason,
    this.comments = const [],
  });

  int get commentCount => comments.length;
}
