import '../repositories/task_repositoy.dart';
import '../entities/task.dart';

class AddTaskUseCase {
  final ITaskRepository repository;

  AddTaskUseCase(this.repository);

  Future<Task> call(Task task) async {
    return await repository.addTask(task);
  }
}
