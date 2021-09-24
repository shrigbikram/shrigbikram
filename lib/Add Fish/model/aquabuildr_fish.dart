import 'package:aquabuildr/Add%20Fish/model/aquabuildr_fish_view_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AquabuildrFish {
  final String aquariumType;
  final String species;
  final String description;

  String gender;
  final double price;
  final String experienceLevel;
  final int quantity;
  final double discount;

  final String celsiusTemperature;
  final double celsiusTempL;
  final double celsiusTempU;

  final String farenheitTemperature;
  final String pHValue;
  final double pHValueL;
  final double pHValueU;

  final String temperament;
  final int minimumTankSize;
  final int adultSize;

  final String activityLevel;

  final String preferredPlants;
  final String preferredTankFloor;
  final String preferredSwimDepth;
  final String preferredNoPerTankPred;
  final String preferredNoPerTankString;
  final String preferredTypes;

  final String cyclerSpecies;
  final String photoURL;
  final String feed;

  int tankQuantity;

  final DocumentReference reference;

  String get fishId {
    return reference.id;
  }

  AquabuildrFish({
    this.description,
    this.aquariumType,
    this.species,
    this.gender,
    this.price,
    this.experienceLevel,
    this.quantity,
    this.discount,
    this.celsiusTemperature,
    this.celsiusTempL,
    this.celsiusTempU,
    this.farenheitTemperature,
    this.pHValue,
    this.pHValueL,
    this.pHValueU,
    this.temperament,
    this.minimumTankSize,
    this.adultSize,
    this.activityLevel,
    this.preferredPlants,
    this.preferredTankFloor,
    this.preferredSwimDepth,
    this.preferredNoPerTankPred,
    this.preferredNoPerTankString,
    this.preferredTypes,
    this.cyclerSpecies,
    this.photoURL,
    this.feed,
    this.reference,
  });

  //to update to firebase we need to suppy dictionary
  //converting object to map/dictionary
  Map<String, dynamic> toMap() {
    return {
      "description": description,
      "aquariumType": aquariumType,
      "species": species,
      "gender": gender,
      "price": price,
      "experienceLevel": experienceLevel,
      "quantity": quantity,
      "discount": discount,
      "celsiusTemperature": celsiusTemperature,
      "celsiusTempL":celsiusTempL,
      "celsiusTempU":celsiusTempU,
      "farenheitTemperature": farenheitTemperature,
      "pHValue": pHValue,
      "pHValueL":pHValueL,
      "pHValueU":pHValueU,
      "temperament": temperament,
      "minimumTankSize": minimumTankSize,
      "adultSize": adultSize,
      "activityLevel": activityLevel,
      "preferredPlants": preferredPlants,
      "preferredTankFloor": preferredTankFloor,
      "preferredSwimDepth": preferredSwimDepth,
      "preferredNoPerTankPred": preferredNoPerTankPred,
      "preferredNoPerTankString": preferredNoPerTankString,
      "preferredTypes": preferredTypes,
      "cyclerSpecies": cyclerSpecies,
      "photoURL": photoURL,
      "feed":feed
    };
  }

  //convert dictionary to object
  factory AquabuildrFish.fromDocument(QueryDocumentSnapshot doc) {
    //#fishload
    //print("\n");
    //print(doc["description"]);
    //print(doc["aquariumType"]);
    //print(doc["species"]);
    // print(doc["gender"]);
    // print(doc["price"]);
    // print(doc["experienceLevel"]);
    // print(doc["quantity"]);

    // print(doc["discount"]);
    //print(doc["celsiusTemperature"]);
    //print(doc["celsiusTempL"]);
    //print(doc["celsiusTempU"]);
    // print(doc["farenheitTemperature"]);
    // print(doc["pHValue"]);
    // print(doc["pHValueL"]);
    // print(doc["pHValueU"]);

    // print(doc["temperament"]);
    // print(doc["minimumTankSize"]);
    // print(doc["adultSize"]);
    // print(doc["activityLevel"]);
    // print(doc["preferredPlants"]);
    // print(doc["preferredTankFloor"]);
    // print(doc["preferredSwimDepth"]);
    // print(doc["preferredNoPerTankPred"]);


    // print(doc["preferredNoPerTankString"]);
    // print(doc["cyclerSpecies"]);
    //print(doc["photoURL"]);

    //String speciesname = doc["species"];
    
    return AquabuildrFish(
      description: doc["description"],
      aquariumType: doc["aquariumType"],
      species: doc["species"],
      gender: doc["gender"],
      price: doc["price"],
      experienceLevel: doc["experienceLevel"],
      quantity: doc["quantity"],
      discount: doc["discount"],
      celsiusTemperature: doc["celsiusTemperature"],
      celsiusTempL: doc["celsiusTempL"],
      celsiusTempU: doc["celsiusTempU"],
      farenheitTemperature: doc["farenheitTemperature"],
      pHValue: doc["pHValue"],
      pHValueL: doc["pHValueL"],
      pHValueU: doc["pHValueU"],
      temperament: doc["temperament"],
      minimumTankSize: doc["minimumTankSize"],
      adultSize: doc["adultSize"],
      activityLevel: doc["activityLevel"],
      preferredPlants: doc["preferredPlants"],
      preferredTankFloor: doc["preferredTankFloor"],
      preferredSwimDepth: doc["preferredSwimDepth"],
      preferredNoPerTankPred: doc["preferredNoPerTankPred"],
      preferredNoPerTankString: doc["preferredNoPerTankString"],
      cyclerSpecies: doc["cyclerSpecies"],
      photoURL: doc["photoURL"],
      feed: doc["feed"],
      reference: doc.reference
    );
  }

  factory AquabuildrFish.fromAquabuildrFishViewState(
      AquabuildrFishViewState vs) {
    return AquabuildrFish(
      description: vs.description,
      aquariumType: vs.aquariumType,
      species: vs.species,
      gender: vs.gender,
      price: vs.price,
      experienceLevel: vs.experienceLevel,
      quantity: vs.quantity,
      discount: vs.discount,
      celsiusTemperature: vs.celsiusTemperature,
      celsiusTempL: vs.celsiusTempL,
      celsiusTempU: vs.celsiusTempU,
      farenheitTemperature: vs.farenheitTemperature,
      pHValue: vs.pHValue,
      pHValueL: vs.pHValueL,
      pHValueU: vs.pHValueU,
      temperament: vs.temperament,
      minimumTankSize: vs.minimumTankSize,
      adultSize: vs.adultSize,
      cyclerSpecies: vs.cyclerSpecies,
      activityLevel: vs.activityLevel,
      preferredPlants: vs.preferredPlants,
      preferredTankFloor: vs.preferredTankFloor,
      preferredSwimDepth: vs.preferredSwimDepth,
      preferredNoPerTankPred: vs.preferredNoPerTankPred,
      preferredNoPerTankString: vs.preferredNoPerTankString,
      photoURL: vs.photoURL,
      feed: vs.feed,
      reference: vs.reference
    );
  }
}
