import 'package:cloud_firestore/cloud_firestore.dart';

class AquabuildrUserTankFish{
  String aquabuildrUserTankFishId;
  final String name;
  final double price;
  final int quantity;

  AquabuildrUserTankFish(this.name,this.price,this.quantity,[this.aquabuildrUserTankFishId]);

  Map<String, dynamic> toMap() {
    return{
      "name":name,
      "price":price,
      "quantity":quantity
    };
  }

  factory AquabuildrUserTankFish.fromSnapshot(QueryDocumentSnapshot doc){
    return AquabuildrUserTankFish(
      doc["name"], 
      doc["price"],
      doc["quantity"],
      doc.id
      );
  }

}