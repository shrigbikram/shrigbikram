import 'package:cloud_firestore/cloud_firestore.dart';

class User{

  final String name;
  final String email;
  DocumentReference reference;

  User(this.name, this.email, [this.reference]);

  String get aquabuildrUserId {
    return reference.id;
  }

  Map<String, dynamic> toMap(){
    return{
      "name":name,
      "email":email
    };
  }

  factory User.fromSnapshot(QueryDocumentSnapshot doc){
    return User(doc["name"], doc["email"],doc.reference);
  }

}