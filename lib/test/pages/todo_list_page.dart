import 'package:aquabuildr/test/models/task.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoListPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    FirebaseFirestore.instance
        .collection("todos")
        .add({"title": _controller.text});

    _controller.text = "";
  }

  void _deleteTask(Task task) async {
    FirebaseFirestore.instance.collection("todos")
    .doc(task.taskId)
    .delete();
  }

  Widget _buildList(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.docs.length,
        itemBuilder: (context, index) {
          final doc = snapshot.docs[index];
          final task = Task.fromSnapshot(doc);

          return _buildListItem(task);

          // final map = doc.data();
          // return ListTile(
          //   title: Text(map["title"])
          // );
        });
  }

  Widget _buildListItem(Task task) {
    return Dismissible(
      key: Key(task.taskId),
      onDismissed: (direction) {
        _deleteTask(task);
      },
      background: Container(color: Colors.red),
      child: ListTile(title: Text(task.title)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "Enter task name"),
            )),
            FlatButton(
              child: Text("Add task"),
              // style: TextStyle(color: Colors.white),
              color: Colors.green,
              onPressed: () {
                _addTask();
              },
              textColor: Colors.white,
            )
          ],
        ),

        // Expanded(
        //   child: ListView.builder(
        //       itemCount: 20,
        //       itemBuilder: (context, index) {
        //         return ListTile(
        //           title: Text("Your task here..."),
        //         );
        //       }),
        // )

        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("todos").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            return Expanded(child: _buildList(snapshot.data));
          },
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
      ),
      body: _buildBody(context),
    );
  }
}
