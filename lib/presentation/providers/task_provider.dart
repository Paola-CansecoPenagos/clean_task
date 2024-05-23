import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';
import '../services/db_helper.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();
  List<TaskModel> _tasks = [];
  bool _isOnline = false;

  List<TaskModel> get tasks => _tasks;
  bool get isOnline => _isOnline;

  TaskProvider() {
    _checkConnectivity();
  }

  void _checkConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      _isOnline = result != ConnectivityResult.none;
      notifyListeners();
      if (_isOnline) {
        synchronizeTasks();
      }
    });
  }

  void loadTasks() async {
    if (_isOnline) {
      _tasks = await _taskRepository.getTasks();
      notifyListeners();
    } else {
      // Manejar lógica para cuando no hay conexión
      _tasks = []; // O cargar tareas desde una caché local si es necesario
      notifyListeners();
    }
  }

  void addTask(String title, String description) async {
    if (_isOnline) {
      TaskModel task = await _taskRepository.addTask(title, description);
      _tasks.add(task);
    } else {
      final db = await DBHelper.database;
      db.insert('pending_tasks', {
        'title': title,
        'description': description,
        'action': 'add'
      });
    }
    notifyListeners();
  }

  void deleteTask(String id) async {
    if (_isOnline) {
      await _taskRepository.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
    } else {
      final db = await DBHelper.database;
      db.insert('pending_tasks', {
        'id': id,
        'action': 'delete'
      });
    }
    notifyListeners();
  }

  void updateTask(String id, String title, String description) async {
    if (_isOnline) {
      await _taskRepository.updateTask(id, title, description);
      int index = _tasks.indexWhere((task) => task.id == id);
      _tasks[index] = TaskModel(id: id, title: title, description: description);
    } else {
      final db = await DBHelper.database;
      db.insert('pending_tasks', {
        'id': id,
        'title': title,
        'description': description,
        'action': 'update'
      });
    }
    notifyListeners();
  }

    Future<void> synchronizeTasks() async {
    final db = await DBHelper.database;
    List<Map<String, dynamic>> pendingTasks = await db.query('pending_tasks');

    for (var task in pendingTasks) {
      if (task['action'] == 'add') {
        addTask(task['title'], task['description']);
      } else if (task['action'] == 'delete') {
        deleteTask(task['id'].toString());
      } else if (task['action'] == 'update') {
        updateTask(task['id'].toString(), task['title'], task['description']);
      }
      await db.delete('pending_tasks', where: 'id = ?', whereArgs: [task['id']]);
    }
  }
}