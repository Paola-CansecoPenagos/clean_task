import '../repositories/task_repositoy.dart';

class DeleteTaskUseCase {
  final ITaskRepository repository;

  DeleteTaskUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteTask(id);
  }
}
