
import 'package:cloud_firestore/cloud_firestore.dart';

class StarterAquariumItem{
  String starterAquariumItemId;
  final String aquabuildrFishId;
  final String name;
  final String aquariumType;
  final String prefNoInTank;
  final double price;
  final int adultSize;
  final int fishMinTankSize;

  final double temprU;
  final double temprL;
  final double pHU;
  final double pHL;

  int quantity;
  int isCompatible;
  final String gender;
  final String photoURL;

  final DateTime itemAddedDateTime;


  StarterAquariumItem(this.aquabuildrFishId, this.name,this.aquariumType,this.prefNoInTank,this.price, this.adultSize, this.fishMinTankSize, this.temprL, this.temprU, this.pHL, this.pHU,this.quantity, this.isCompatible, this.gender, this.photoURL, this.itemAddedDateTime,[this.starterAquariumItemId]);

  Map<String, dynamic> toMap() {
    return{
      "aquabuildrFishId":aquabuildrFishId,
      "name":name,
      "aquariumType":aquariumType,
      "prefNoInTank":prefNoInTank,
      "price":price,
      //"price2":price2,
      "adultSize":adultSize,
      "fishMinTankSize":fishMinTankSize,
      "temprU":temprU,
      "temprL":temprL,
      "pHU":pHU,
      "pHL":pHL,
      "quantity":quantity,
      "iscompatible":isCompatible,
      "gender":gender,
      "photoURL":photoURL,
      "itemAddedDateTime":itemAddedDateTime,
    };
  }

  factory StarterAquariumItem.fromSnapshot(QueryDocumentSnapshot doc){
    return StarterAquariumItem
      (
      doc["aquabuildrFishId"],
      doc["name"], 
      doc["aquariumType"],
      doc["prefNoInTank"],
      doc["price"],
    
      doc["adultSize"],
      doc["fishMinTankSize"],
      doc["temprU"],
      doc["temprL"],
      doc["pHU"],
      doc["pHL"],
      doc["quantity"],
      doc["iscompatible"],
      doc["gender"],
      doc["photoURL"],
      doc["itemAddedDateTime"].toDate(),
      doc.id
      );
  }

}