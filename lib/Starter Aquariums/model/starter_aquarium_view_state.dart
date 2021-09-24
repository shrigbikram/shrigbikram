
import 'package:cloud_firestore/cloud_firestore.dart';

class StarterAquariumViewState {
  final String aquariumName;
  final String starterKitLabel;
  final String aquariumDesciption;
  final String photoURL;
  final int aquariumSize;
  final String aquariumType;
  final String phValue;
  final double pHValueL;
  final double pHValueU;
  final String temperature;
  final double temprL;
  final double temprU;
  final DocumentReference reference;

  StarterAquariumViewState(
      {
        this.aquariumName, 
        this.starterKitLabel,
        this.aquariumDesciption, 
        this.photoURL,
        this.aquariumSize,
        this.aquariumType,
        this.phValue,
        this.pHValueL,
        this.pHValueU,
        this.temperature,
        this.temprL,
        this.temprU,
        this.reference
      });


}
