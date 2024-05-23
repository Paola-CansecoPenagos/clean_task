import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskRepository {
final String apiUrl = "http://10.0.2.2:5000/tasks";

  Future<List<TaskModel>> getTasks() async {
    var response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<TaskModel> tasks = body.map((dynamic item) => TaskModel.fromJson(item)).toList();
      return tasks;
    } else {
      throw "Can't get tasks.";
    }
  }

  Future<TaskModel> addTask(String title, String description) async {
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description
      }),
    );
    if (response.statusCode == 201) {
      return TaskModel.fromJson(jsonDecode(response.body));
    } else {
      throw "Failed to add task.";
    }
  }

  Future<void> deleteTask(String id) async {
    var response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode != 204) {
      throw "Failed to delete task.";
    }
  }

  Future<void> updateTask(String id, String title, String description) async {
    var response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'description': description
      }),
    );
    if (response.statusCode != 200) {
      throw "Failed to update task.";
    }
  }
}
