import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_dapp/todolist_model.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<TodoModel>(context);
    final TextEditingController textEditingController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          title: Text('Todo Dapp'),
          centerTitle: true,
        ),
        body: listModel.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                    Expanded(
                        flex: 4,
                        child: ListView.builder(
                            itemCount: listModel.taskCount,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(listModel.todos[index].taskName),
                              );
                            })),
                    Expanded(
                        flex: 1,
                        child: Row(children: [
                          Expanded(
                            flex: 5,
                            child: TextField(
                              controller: textEditingController,
                            ),
                          ),
                          Expanded(
                              child: ElevatedButton(
                            onPressed: () {
                              listModel.addTodo(textEditingController.text);
                            },
                            child: Text('Add Todo'),
                          )),
                        ]))
                  ]));
  }
}
