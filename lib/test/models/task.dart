import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String title;
  final String taskId; // actual document id

  Task(this.title, [this.taskId]);  //constructor

  factory Task.fromSnapshot(DocumentSnapshot <Map<String, dynamic>> snapshot){
    final map = snapshot.data();
    return Task(map["title"], snapshot.id);
    // return Task(
    //   title: map["title"],
    // );
  }

}
