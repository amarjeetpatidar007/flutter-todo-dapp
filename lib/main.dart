import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_dapp/todo_list.dart';
import 'package:todo_dapp/todolist_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoModel(),
      child: MaterialApp(
        title: "Flutter Dapp",
        home: TodoList(),
      ),
    );
  }
}
