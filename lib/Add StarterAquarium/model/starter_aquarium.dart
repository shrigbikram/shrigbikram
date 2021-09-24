import 'package:aquabuildr/Starter%20Aquariums/model/starter_aquarium_view_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StarterAquarium {
  final String aquariumName;
  final String starterKitLabel;
  final String aquariumDesciption;
  final int aquariumSize;
  final String aquariumType;
  final String photoURL;
  final String pHValue;
  final double pHValueL;
  final double pHValueU;
  final String temperature;
  final double temprL;
  final double temprU;

  DocumentReference reference;

  StarterAquarium(
      this.aquariumName,
      this.starterKitLabel,
      this.aquariumDesciption,
      this.aquariumSize,
      this.aquariumType,
      this.photoURL,
      this.pHValue,
      this.pHValueL,
      this.pHValueU,
      this.temperature,
      this.temprL,
      this.temprU,
      [this.reference]);

  String get aquariumId {
    return reference.id;
  }

  Map<String, dynamic> toMap() {
    return {
      "aquariumName": aquariumName,
      "starterKitLabel": starterKitLabel,
      "aquariumDesciption": aquariumDesciption,
      "aquariumSize": aquariumSize,
      "aquariumType":aquariumType,
      "photoURL": photoURL,
      "pHValue": pHValue,
      "pHValueL":pHValueL,
      "pHValueU":pHValueU,
      "temperature": temperature,
      "temprL":temprL,
      "temprU":temprU,
    };
  }

  factory StarterAquarium.fromSnapshot(QueryDocumentSnapshot doc) {
    return StarterAquarium(
        doc["aquariumName"],
        doc["starterKitLabel"],
        doc["aquariumDesciption"],
        doc["aquariumSize"],
        doc["aquariumType"],
        doc["photoURL"],
        doc["pHValue"],
        doc["pHValueL"],
        doc["pHValueU"],
        doc["temperature"],
        doc["temprL"],
        doc["temprU"],
        doc.reference);
  }

  factory StarterAquarium.fromDocument(QueryDocumentSnapshot doc) {
    return StarterAquarium(
      doc["aquariumName"],
      doc["starterKitLabel"],
      doc["aquariumDesciption"],
      doc["aquariumSize"],
      doc["aquariumType"],
      doc["photoURL"],
      doc["pHValue"],
      doc["pHValueL"],
      doc["pHValueU"],
      doc["temperature"],
      doc["temprL"],
      doc["temprU"],
      doc.reference,
    );
  }

  factory StarterAquarium.fromStarterAquariumViewState(
      StarterAquariumViewState vs) {
    return StarterAquarium(vs.aquariumName, vs.starterKitLabel, vs.aquariumDesciption, vs.aquariumSize, vs.aquariumType, vs.photoURL, vs.phValue, vs.pHValueL, vs.pHValueU, vs.temperature, vs.temprL, vs.temprU, vs.reference);
  }

  /*

  Map<String, dynamic> toMap() {
    return {
      "aquariumType": aquariumType,
      "aquariumDesciption": aquariumDesciption,
      "photoURL": photoURL,
    };
  }

  factory StarterAquarium.fromDocument(QueryDocumentSnapshot doc) {
    return StarterAquarium(
      aquariumType: doc["aquariumType"],
      aquariumDesciption: doc["aquariumDesciption"],
      photoURL: doc["photoURL"],
    );
  }

  factory StarterAquarium.fromStarterAquariumViewState(
      StarterAquariumViewState vs) {
    return StarterAquarium(
      aquariumType: vs.aquariumType,
      aquariumDesciption: vs.aquariumDesciption,
      photoURL: vs.photoURL,
    );
  }

  */
}
