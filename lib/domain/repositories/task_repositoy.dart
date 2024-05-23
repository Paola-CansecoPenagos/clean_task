import '../entities/task.dart';

abstract class ITaskRepository {
  Future<List<Task>> getTasks();
  Future<Task> addTask(Task task);
  Future<void> deleteTask(String id);
  Future<void> updateTask(Task task);
}
