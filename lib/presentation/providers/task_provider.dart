import 'package:flutter/material.dart';
import '../../domain/use_cases/add_task_use_case.dart';
import '../../domain/use_cases/get_tasks_use_case.dart';
import '../../domain/use_cases/delete_task_use_case.dart';
import '../../domain/use_cases/update_task_use_case.dart';
import '../../domain/entities/task.dart';

class TaskProvider with ChangeNotifier {
  final GetTasksUseCase _getTasksUseCase;
  final AddTaskUseCase _addTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  TaskProvider(this._getTasksUseCase, this._addTaskUseCase, this._deleteTaskUseCase, this._updateTaskUseCase) {
    loadTasks();
  }

  void loadTasks() async {
    _tasks = await _getTasksUseCase.call();
    notifyListeners();
  }

  void addTask(String title, String description) async {
    Task task = await _addTaskUseCase.call(Task(id: '', title: title, description: description));
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(String id) async {
    await _deleteTaskUseCase.call(id);
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void updateTask(String id, String title, String description) async {
    Task updatedTask = Task(id: id, title: title, description: description);
    await _updateTaskUseCase.call(updatedTask);
    int index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }
}
