import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/task_list_screen.dart';
import 'presentation/providers/task_provider.dart';
import 'domain/use_cases/get_tasks_use_case.dart';
import 'domain/use_cases/add_task_use_case.dart';
import 'domain/use_cases/delete_task_use_case.dart';
import 'domain/use_cases/update_task_use_case.dart';
import 'data/repositories/task_repository_impl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Crear instancias de tus casos de uso dentro del método build
    final TaskRepositoryImpl taskRepository = TaskRepositoryImpl();
    final GetTasksUseCase getTasksUseCase = GetTasksUseCase(taskRepository);
    final AddTaskUseCase addTaskUseCase = AddTaskUseCase(taskRepository);
    final DeleteTaskUseCase deleteTaskUseCase = DeleteTaskUseCase(taskRepository);
    final UpdateTaskUseCase updateTaskUseCase = UpdateTaskUseCase(taskRepository);

    return MultiProvider(
      providers: [
        // Provee el TaskProvider con las dependencias necesarias
        ChangeNotifierProvider(
          create: (_) => TaskProvider(
            getTasksUseCase,
            addTaskUseCase,
            deleteTaskUseCase,
            updateTaskUseCase
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: TaskListScreen(),
      ),
    );
  }
}
