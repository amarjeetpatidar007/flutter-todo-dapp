import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Todo Dapp'),
          centerTitle: true,
        ),
        body: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Expanded(
                  flex: 4,
                  child: ListView.builder(
                      itemCount: 100,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('Todo'),
                        );
                      })),
              Expanded(
                  flex: 1,
                  child: Row(children: [
                    Expanded(
                      flex: 5,
                      child: TextField(),
                    ),
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Add Todo'),
                    )),
                  ]))
            ]));
  }
}
