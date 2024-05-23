import 'package:flutter/material.dart';
import 'presentation/screens/task_list_screen.dart';
import 'presentation/providers/task_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'Task Manager',
        home: TaskListScreen(),
      ),
    );
  }
}
