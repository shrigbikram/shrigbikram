import 'package:aquabuildr/Starter%20Aquarium%20Detail/model/starter_aquarium_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class StarterAquariumItemViewModel {
  final StarterAquariumItem tankItem;
  StarterAquariumItemViewModel({this.tankItem});

  String get name {
    return tankItem.name;
  }

  String get aquariumType {
    return tankItem.aquariumType;
  }

  String get prefNoInTank {
    return tankItem.prefNoInTank;
  }

  int get quantity {
    return tankItem.quantity;
  }

  int get isCompatible {
    return tankItem.isCompatible;
  }
  String get gender {
    return tankItem.gender;
  }

  set quantity(int qty) {
    tankItem.quantity = qty;
  }

  double get temprU {
    return tankItem.temprU;
  }

  double get temprL {
    return tankItem.temprL;
  }

  double get pHU {
    return tankItem.pHU;
  }

  double get pHL {
    return tankItem.pHL;
  }

  double get price {
    return tankItem.price;
  }

  int get adultSize {
    return tankItem.adultSize;
  }

  int get fishMinTankSize {
    return tankItem.fishMinTankSize;
  }

  String get photoURL {
    return tankItem.photoURL;
  }

   String get itemAddedDateTime{
    return DateFormat("MM-dd-yyyy HH:mm:ss").format(tankItem.itemAddedDateTime);
  }

  String get tankItemId {
    return tankItem.starterAquariumItemId;
  }

  factory StarterAquariumItemViewModel.fromSnapshot(QueryDocumentSnapshot doc) {
    final tankItem = StarterAquariumItem.fromSnapshot(doc);
    return StarterAquariumItemViewModel(tankItem: tankItem);
  }
}
