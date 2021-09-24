import 'package:aquabuildr/Add%20Fish/model/aquabuildr_fish.dart';
import 'package:aquabuildr/utils/Global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AvailableAquabuildrFishListViewModel extends ChangeNotifier {


  bool isShowUpperSection = true;

  void updateShowUpperSection(bool isShowUpper){
      isShowUpperSection = isShowUpper;

      print("ISSHOWUPPER SECTION = " + isShowUpperSection.toString());
      notifyListeners();
  }

  List<AquabuildrFishViewModel> availableAquabuildrFishes = [];

  bool isAdmin = false;


  void checkIfAdminUser(String yourUserId) async {

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("admin")
        .get();

    final adminsDb =
          snapshot.docs.map((doc) =>  doc["admin1"]).toList();

    if(adminsDb.length > 0){

      adminsDb.forEach((admin) { 
        print("Admin Id = ");
        print(admin);

        print(yourUserId);
        print(admin);

        String adm = admin;
        String usrid = yourUserId;

        if( adm == usrid){
          print("EQUAL");
          isAdmin = true;
          Global.isAdmin = true;
          print("BRAVO! ADMIN USER");
        }else{
          print("NOT EQUAL");
          Global.isAdmin = false;
          print("NOT ADMIN USER");
        }

        print("Global.isAdmin = " + Global.isAdmin.toString());

      });



    }

    notifyListeners();
  }

  void loadData(bool isRefresh) async {

    if (Global.aquabuildrFishes.length == 0 || isRefresh) {
      //print("loading data....");
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("aquabuildrfishes")
          // .orderBy("date", descending: true)
          .get();

      //print("...get success now maping...");
      snapshot.docs.map((doc) {
        print(doc.toString());
      });

      //print("...get success now maping second...");

      // final aquabuildrFishes =
      //     snapshot.docs.map((doc) => AquabuildrFish.fromDocument(doc)).toList();

      final aquabuildrFishes =
          snapshot.docs.map((doc) => AquabuildrFish.fromDocument(doc)).toList();

      // print("---> Aquabuildrfishes = " + aquabuildrFishes.toString());

      // aquabuildrFishes.map((aquabuildrFish) {
      //   print(aquabuildrFish.celsiusTemperature);
      // });

      //we got models and we iterate to get view models
      //return aquabuildrFishes.map((aquabuildrFish) => AquabuildrFishViewModel(aquabuildrFish: aquabuildrFish)).toList();
      availableAquabuildrFishes = aquabuildrFishes
          .map((aquabuildrFish) =>
              AquabuildrFishViewModel(aquabuildrFish: aquabuildrFish))
          .toList();
      Global.aquabuildrFishes = availableAquabuildrFishes;
    } else {
      availableAquabuildrFishes = Global.aquabuildrFishes;
    }
    notifyListeners();
  }

/*
  Future<List<AquabuildrFishViewModel>> getAllAvailableAquabuildrFish() async {
      
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("aquabuildrfishes")
      // .orderBy("date", descending: true)
      .get();

      final aquabuildrFishes = snapshot.docs.map((doc) => AquabuildrFish.fromDocument(doc)).toList();
      //we got models and we iterate to get view models
      //return aquabuildrFishes.map((aquabuildrFish) => AquabuildrFishViewModel(aquabuildrFish: aquabuildrFish)).toList();
      availableAquabuildrFishes = aquabuildrFishes.map((aquabuildrFish) => AquabuildrFishViewModel(aquabuildrFish: aquabuildrFish)).toList();

      notifyListeners();

  }*/
}

class AquabuildrFishViewModel {
  final AquabuildrFish aquabuildrFish;
  AquabuildrFishViewModel({this.aquabuildrFish});

  String get description {
    return aquabuildrFish.description;
  }

  String get aquariumType {
    return aquabuildrFish.aquariumType;
  }

  String get species {
    return aquabuildrFish.species;
  }

  String get gender {
    return aquabuildrFish.gender;
  }
  set gender(String gen) {
    aquabuildrFish.gender = gen;
  }

  double get price {
    return aquabuildrFish.price;
  }

  String get experienceLevel {
    return aquabuildrFish.experienceLevel;
  }

  int get quantity {
    return aquabuildrFish.quantity;
  }

  double get discount {
    return aquabuildrFish.discount;
  }

  String get celsiusTemperature {
    return aquabuildrFish.celsiusTemperature;
  }

  double get celsiusTemprL {
    return aquabuildrFish.celsiusTempL;
  }

  double get celsiumTemprU {
    return aquabuildrFish.celsiusTempU;
  }

  String get farenheitTemperature {
    return aquabuildrFish.farenheitTemperature;
  }

  String get pHValue {
    return aquabuildrFish.pHValue;
  }

  double get pHValueL{
    return aquabuildrFish.pHValueL;
  }

  double get pHValueU{
    return aquabuildrFish.pHValueU;
  }

  String get temperament {
    return aquabuildrFish.temperament;
  }

  int get minimumTankSize {
    return aquabuildrFish.minimumTankSize;
  }

  int get adultSize {
    return aquabuildrFish.adultSize;
  }

  String get activityLevel {
    return aquabuildrFish.activityLevel;
  }

  String get preferredPlants {
    return aquabuildrFish.preferredPlants;
  }

  String get preferredTankFloor {
    return aquabuildrFish.preferredTankFloor;
  }

  String get preferredSwimDepth {
    return aquabuildrFish.preferredSwimDepth;
  }

  String get preferredNoPerTankPred {
    return aquabuildrFish.preferredNoPerTankPred;
  }

  String get preferredNoPerTankString {
    return aquabuildrFish.preferredNoPerTankString;
  }

  String get preferredTypes {
    return aquabuildrFish.preferredTypes;
  }

  String get cyclerSpecies {
    return aquabuildrFish.cyclerSpecies;
  }

  String get photoURL {
    return aquabuildrFish.photoURL;
  }

  String get feed {
    return aquabuildrFish.feed;
  }

  int get tankQuantity {
    return aquabuildrFish.tankQuantity;
  }

  set tankQuantity(int tankquantity) {
    aquabuildrFish.tankQuantity = tankquantity;
  }

  String get fishId {
    return aquabuildrFish.reference.id;
  }

  DocumentReference get reference {
    return aquabuildrFish.reference;
  }
}
