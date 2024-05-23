import '../repositories/task_repositoy.dart';
import '../entities/task.dart';

class UpdateTaskUseCase {
  final ITaskRepository repository;

  UpdateTaskUseCase(this.repository);

  Future<void> call(Task task) async {
    return await repository.updateTask(task);
  }
}
