
import 'package:cloud_firestore/cloud_firestore.dart';

class AquabuildrFishViewState {

  final String description;

  final String aquariumType;
  final String species;
  
  final String gender;
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

  final DocumentReference reference;

  AquabuildrFishViewState(
      {this.description,
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
      this.reference});
}
