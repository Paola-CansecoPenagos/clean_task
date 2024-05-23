import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import 'add_edit_task_screen.dart';
import '../../data/models/task_model.dart';  // Asegúrate de tener el import correcto para TaskModel

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: taskProvider.loadTasks,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          TaskModel taskModel = TaskModelExtensions.fromDomain(taskProvider.tasks[index]);  // Uso correcto de la extensión
          return ListTile(
            title: Text(taskModel.title),
            subtitle: Text(taskModel.description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddEditTaskScreen(task: taskModel),  // Pasar TaskModel
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => taskProvider.deleteTask(taskProvider.tasks[index].id),  // Usar Task ID
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddEditTaskScreen(),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
