import 'package:cloud_firestore/cloud_firestore.dart';

class AquabuildrUserTank{

  final String tankID;
  final String tankType;

  DocumentReference reference;

  AquabuildrUserTank(this.tankID,this.tankType,[this.reference]);

  String get aquabuildrUserTankId {
    return reference.id;
  }

  Map<String, dynamic> toMap(){
    return{
      "tankID":tankID,
      "tankType":tankType,
    };
  }

  factory AquabuildrUserTank.fromSnapshot(QueryDocumentSnapshot doc){
    return AquabuildrUserTank(doc["tankID"], doc["tankType"],doc.reference);
  }

}