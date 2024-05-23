import '../../domain/entities/task.dart';  // Importar la entidad Task

class TaskModel {
  final String id;
  final String title;
  final String description;

  TaskModel({required this.id, required this.title, required this.description});

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
    );
  }

  Task toDomain() {
    return Task(id: id, title: title, description: description);
  }
}

extension TaskModelExtensions on TaskModel {
  static TaskModel fromDomain(Task task) {
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
    );
  }
}
