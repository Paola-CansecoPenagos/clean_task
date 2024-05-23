import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repositoy.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final String apiUrl = "http://10.0.2.2:5000/tasks";

  @override
  Future<List<Task>> getTasks() async {
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => TaskModel.fromJson(item).toDomain()).toList();
    } else {
      throw Exception("Can't get tasks.");
    }
  }

  @override
  Future<Task> addTask(Task task) async {
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'title': task.title, 'description': task.description}),
    );
    if (response.statusCode == 201) {
      return TaskModel.fromJson(jsonDecode(response.body)).toDomain();
    } else {
      throw Exception("Failed to add task.");
    }
  }

  @override
  Future<void> deleteTask(String id) async {
    var response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception("Failed to delete task.");
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    var response = await http.put(
      Uri.parse('$apiUrl/${task.id}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'title': task.title, 'description': task.description}),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to update task.");
    }
  }
}
