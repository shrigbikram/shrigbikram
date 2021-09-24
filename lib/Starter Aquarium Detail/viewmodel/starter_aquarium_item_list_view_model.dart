import 'package:aquabuildr/Starter%20Aquarium%20Detail/model/starter_aquarium_item.dart';
import 'package:aquabuildr/Starter%20Aquariums/viewmodel/starter_aquarium_list_view_model.dart';
import 'package:aquabuildr/Starter%20Aquarium%20Detail/viewmodel/starter_aquarium_item_view_model.dart';
import 'package:aquabuildr/utils/Global.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StarterAquariumItemListViewModel extends ChangeNotifier {
  String aquabuildrFishId;
  String name;
  String aquariumType;
  String prefNoInTank;
  double price;
  int adultSize;
  int fishMinTankSize;

  double temprU;
  double temprL;
  double pHU;
  double pHL;
  
  int quantity;
  int isCompatible;
  String gender;
  String photoURL;

  DateTime itemAddedDateTime;

  final StarterAquariumViewModel aquarium;

  StarterAquariumItemListViewModel({this.aquarium});

  Stream<QuerySnapshot> get tankItemsAsStream {
    return FirebaseFirestore.instance
        .collection(Constants.STARTERAQUARIUMSLIST_COLLECTION)
        .doc(aquarium.aquariumId)
        .collection("tankitems")
        // .orderBy("itemAddedDateTime", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> get usertankItemsAsStream {
    return FirebaseFirestore.instance
        .collection(Constants.USER_COLLECTION)
        .doc(Global.aquabuildrUserId)
        .collection(Constants.USER_AQUARIUM)
        .doc(aquarium.aquariumId)
        .collection("tankitems")
        .orderBy("itemAddedDateTime", descending: true)
        .snapshots();
  }

  Future <String> loadTankItems(bool isStarterAquarium) async {

      QuerySnapshot snapshot;

      if(isStarterAquarium){
        snapshot = await FirebaseFirestore.instance
        .collection(Constants.STARTERAQUARIUMSLIST_COLLECTION)
        .doc(aquarium.aquariumId)
        .collection("tankitems")
        // .orderBy("date", descending: true)
        .get();

      }else{
        snapshot = await FirebaseFirestore.instance
        .collection(Constants.USER_COLLECTION)
        .doc(Global.aquabuildrUserId)
        .collection(Constants.USER_AQUARIUM)
        .doc(aquarium.aquariumId)
        .collection("tankitems")
        // .orderBy("date", descending: true)
        .get();

      }
      

    final tankitems = snapshot.docs
        .map((item) => StarterAquariumItemViewModel.fromSnapshot(item))
        .toList();

    String items = "";
    tankitems.forEach((item) {
      print(item.name);
      print(item.gender);
      if(item.gender == "female"){
        items += "<br>" + item.name + "(female)" + " (Qty. " + item.quantity.toString() + "),";

      }else{
        items += "<br>" + item.name + " (Qty. " + item.quantity.toString() + "),";

      }
    });

    return items;

  }

  

  Future<int> getStarterAquariumItemsCount() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(Constants.STARTERAQUARIUMSLIST_COLLECTION)
        .doc(aquarium.aquariumId)
        .collection("tankitems")
        .orderBy("date", descending: true)
        .get();

    final tankitems = snapshot.docs
        .map((item) => StarterAquariumItemViewModel.fromSnapshot(item))
        .toList();

    int tankitemcnt = 0;
    tankitems.forEach((item) {
      tankitemcnt += item.quantity;
    });

    return tankitemcnt;
  }

  Future<String> getStarterAquariumItems() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(Constants.STARTERAQUARIUMSLIST_COLLECTION)
        .doc(aquarium.aquariumId)
        .collection("tankitems")
        .orderBy("date", descending: true)
        .get();

    final tankitems = snapshot.docs
        .map((item) => StarterAquariumItemViewModel.fromSnapshot(item))
        .toList();

    String items = "";
    tankitems.forEach((item) {
      print("item in aquarium = " + item.name);
      items += item.name + ",";
    });

    return items;
  }

  Future<int> getUserAquariumItemsCount() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(Constants.USER_COLLECTION)
        .doc(Global.aquabuildrUserId)
        .collection(Constants.USER_AQUARIUM)
        .doc(aquarium.aquariumId)
        .collection("tankitems")
        // .orderBy("date", descending: true)
        .get();

    final tankitems = snapshot.docs
        .map((item) => StarterAquariumItemViewModel.fromSnapshot(item))
        .toList();

    int tankitemcnt = 0;
    tankitems.forEach((item) {
      tankitemcnt += item.quantity;
    });

    return tankitemcnt;
  }

  Future<int> getLogicalUserAquariumItemsCount() async {

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(Constants.USER_COLLECTION)
        .doc(Global.aquabuildrUserId)
        .collection(Constants.USER_AQUARIUM)
        .doc(aquarium.aquariumId)
        .collection("tankitems")
        // .orderBy("date", descending: true)
        .get();


       // print("hello");

    final tankitems = snapshot.docs
        .map((item) => StarterAquariumItemViewModel.fromSnapshot(item))
        .toList();

    int tankitemcnt = 0;

           // print("hello2");


    int smallerFishesCount = 0;
    int biggerFishesCount = 0;
    tankitems.forEach((item) {

      //print(item.name);
      
      tankitemcnt += item.quantity;
      if(item.adultSize > 3){
        biggerFishesCount += item.quantity;
      }else{
        smallerFishesCount += item.quantity;
      }

    });
    //print(">>> Smaller Fishes in Tank = " + smallerFishesCount.toString());
    //print(">>> Bigger Fishes in Tank = " + biggerFishesCount.toString());

    biggerFishesCount = biggerFishesCount * 6;
    biggerFishesCount = biggerFishesCount + smallerFishesCount;
    Global.currentTankFishCount = biggerFishesCount;
    //print("Global.currenttankfishcount = " + Global.currentTankFishCount.toString());
    
    return biggerFishesCount;
  }

    Future<String> getUserAquariumItems() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(Constants.USER_COLLECTION)
        .doc(Global.aquabuildrUserId)
        .collection(Constants.USER_AQUARIUM)
        .doc(aquarium.aquariumId)
        .collection("tankitems")
        // .orderBy("date", descending: true)
        .get();

    final tankitems = snapshot.docs
        .map((item) => StarterAquariumItemViewModel.fromSnapshot(item))
        .toList();

    String items = "";
    tankitems.forEach((item) {
      print("item in aquarium = " + item.name);
      items += item.name + ",";
    });

    return items;
  }

  void saveTankItem(bool isStarterAquarium) {
    print("saving tank item");
    print(aquarium);
    print(aquarium.aquariumId);
    print(aquarium.aquariumName);
    print(photoURL);
    print("<<<<< iscompatible  >>>>>> " + isCompatible.toString());

    itemAddedDateTime = DateTime.now();
    print("## Item Added datetime = " + itemAddedDateTime.toString());

    final tankItem = StarterAquariumItem(aquabuildrFishId, name, aquariumType,prefNoInTank,
        price, adultSize, fishMinTankSize,temprU, temprL, pHU, pHL,quantity, isCompatible, gender, photoURL, itemAddedDateTime);

    if (isStarterAquarium) {
      FirebaseFirestore.instance
          .collection(Constants.STARTERAQUARIUMSLIST_COLLECTION)
          .doc(aquarium.aquariumId)
          .collection("tankitems")
          .add(tankItem.toMap());
    } else {
      FirebaseFirestore.instance
          .collection(Constants.USER_COLLECTION)
          .doc(Global.aquabuildrUserId)
          .collection(Constants.USER_AQUARIUM)
          .doc(aquarium.aquariumId)
          .collection("tankitems")
          .add(tankItem.toMap());
    }

    //notifyListeners();
  }

  Future<bool> saveUserTankItem() async {
    print("saving tank item");
    print(aquarium);
    print(aquarium.aquariumId);
    print(aquarium.aquariumName);
    print(photoURL);
    print("<<<<< iscompatible  >>>>>> " + isCompatible.toString());

    itemAddedDateTime = DateTime.now();
    print("## Item Added datetime = " + itemAddedDateTime.toString());

    bool isSaved = false;

    try {
      final tankItem = StarterAquariumItem(aquabuildrFishId, name, aquariumType,prefNoInTank,
          price, adultSize, fishMinTankSize,temprU, temprL, pHU, pHL, quantity, isCompatible, gender, photoURL, itemAddedDateTime);

      FirebaseFirestore.instance
          .collection(Constants.USER_COLLECTION)
          .doc(Global.aquabuildrUserId)
          .collection(Constants.USER_AQUARIUM)
          .doc(aquarium.aquariumId)
          .collection("tankitems")
          .add(tankItem.toMap());
      isSaved = true;
    } catch (e) {
      isSaved = false;
    }

    return isSaved;
  }

  void deleteTankItem(
      StarterAquariumItemViewModel tankItem, bool isStarterAquarium) {
    if (isStarterAquarium) {
      FirebaseFirestore.instance
          .collection(Constants.STARTERAQUARIUMSLIST_COLLECTION)
          .doc(aquarium.aquariumId)
          .collection(("tankitems"))
          .doc(tankItem.tankItemId)
          .delete();
    } else {
      FirebaseFirestore.instance
          .collection(Constants.USER_COLLECTION)
          .doc(Global.aquabuildrUserId)
          .collection(Constants.USER_AQUARIUM)
          .doc(aquarium.aquariumId)
          .collection("tankitems")
          .doc(tankItem.tankItemId)
          .delete();
    }

    //notifyListeners();
  }

  void updateTankQtyOfItem(StarterAquariumItemViewModel tankItem, bool isAdded,
      bool isStarterAquarium) {
    int itemQty = tankItem.quantity;
    if (isAdded) {
      itemQty += 1;
    } else {
      itemQty -= 1;
    }

    if (isStarterAquarium) {
      FirebaseFirestore.instance
          .collection(Constants.STARTERAQUARIUMSLIST_COLLECTION)
          .doc(aquarium.aquariumId)
          .collection(("tankitems"))
          .doc(tankItem.tankItemId)
          .update({"quantity": itemQty});
    } else {
      FirebaseFirestore.instance
          .collection(Constants.USER_COLLECTION)
          .doc(Global.aquabuildrUserId)
          .collection(Constants.USER_AQUARIUM)
          .doc(aquarium.aquariumId)
          .collection("tankitems")
          .doc(tankItem.tankItemId)
          .update({"quantity": itemQty});
    }
  }

  // Future<List<StarterAquariumViewModel>> getAllStarterAquariumsList() async {
  //   final QuerySnapshot snapshot = await FirebaseFirestore.instance
  //       .collection(Constants.STARTERAQUARIUMSLIST_COLLECTION)
  //       // .orderBy("aquariumType")
  //       .where("aquariumType", isNotEqualTo: "USER")
  //       .get();

  //   final starterAquariums =
  //       snapshot.docs.map((doc) => StarterAquarium.fromDocument(doc)).toList();

  //   return starterAquariums
  //       .map((starterAquarium) =>
  //           StarterAquariumViewModel(starterAquarium: starterAquarium))
  //       .toList();
  // }

  // Future<bool> checkIfUserAquariumHasFishNamed(
  //     String aquabuildrFishName) async {

  Future<FishGenderAdded> checkIfUserAquariumHasFishNamed(
      String aquabuildrFishName) async {
    QuerySnapshot ds = await FirebaseFirestore.instance
        .collection(Constants.USER_COLLECTION)
        .doc(Global.aquabuildrUserId)
        .collection(Constants.USER_AQUARIUM)
        .doc(aquarium.aquariumId)
        .collection("tankitems")
        .where("name", isEqualTo: aquabuildrFishName)
        .get();

    // final tankItem = ds.docs.map((doc) => StarterAquariumItem.fromSnapshot(doc));
    final tankItems =
        ds.docs.map((doc) => StarterAquariumItem.fromSnapshot(doc)).toList();
    //print("+++++++++++++ \n CHECKING FOR FISH NAME = " + tankItems[0].gender);

    if (tankItems.length == 1) {
      //print("ONE gender already only added = " + tankItems[0].gender);
      if (tankItems[0].gender == "male") {
        return FishGenderAdded.MALE_ADDED;
      } else {
        return FishGenderAdded.FEMALE_ADDED;
      }
    } else if (tankItems.length == 2) {
      //print("TWO genders already added = " + tankItems[0].gender);
      //print("TWO genders already added = " + tankItems[1].gender);
      return FishGenderAdded.BOTH_ADDED;
    } else {
      //print("No gender / No fish added ");
      return FishGenderAdded.NOT_ADDED;
    }

    // print("ds.docs = " + ds.docs.toString());
    // if (ds.docs.length == 1) {
    //   print("Fish with name $aquabuildrFishName ALREADY in user tank");
    //   return true;
    // } else {
    //   print("Fish with name $aquabuildrFishName NOT in user tank");
    //   return false;
    // }
  }

  Future<bool> checkIfUserAquariumHasMaleBetta() async {

    QuerySnapshot ds = await FirebaseFirestore.instance
        .collection(Constants.USER_COLLECTION)
        .doc(Global.aquabuildrUserId)
        .collection(Constants.USER_AQUARIUM)
        .doc(aquarium.aquariumId)
        .collection("tankitems")
        .get();

    // final tankItem = ds.docs.map((doc) => StarterAquariumItem.fromSnapshot(doc));
    final tankItems =
        ds.docs.map((doc) => StarterAquariumItem.fromSnapshot(doc)).toList();
    // print("+++++++++++++ \n CHECKING FOR FISH NAME = " + tankItems[0].gender);

    print("tankItems count = " + tankItems.length.toString());

    bool isMalePresent = false;
   
    for (var i = 0; i < tankItems.length; i++) {
      print("gender[$i] = " + tankItems[i].gender);
      if(tankItems[i].gender == "male"){
        isMalePresent = true;
      }
    }

    return isMalePresent;

    // if (tankItems.length == 1) {
    //   print("ONE gender already only added = " + tankItems[0].gender);
    //   if (tankItems[0].gender == "male") {
    //     return FishGenderAdded.MALE_ADDED;
    //   } else {
    //     return FishGenderAdded.FEMALE_ADDED;
    //   }
    // } else if (tankItems.length == 2) {
    //   print("TWO genders already added = " + tankItems[0].gender);
    //   print("TWO genders already added = " + tankItems[1].gender);
    //   return FishGenderAdded.BOTH_ADDED;
    // } else {
    //   print("No gender / No fish added ");
    //   return FishGenderAdded.NOT_ADDED;
    // }

    // print("ds.docs = " + ds.docs.toString());
    // if (ds.docs.length == 1) {
    //   print("Fish with name $aquabuildrFishName ALREADY in user tank");
    //   return true;
    // } else {
    //   print("Fish with name $aquabuildrFishName NOT in user tank");
    //   return false;
    // }
  }

  // void getUserAquariums(String deviceid) async {

  //   final QuerySnapshot snapshot = await FirebaseFirestore.instance
  //       .collection(Constants.USER_COLLECTION)
  //       .doc(deviceid)
  //       .collection(Constants.USER_AQUARIUM)
  //       .where("aquariumType", isEqualTo: "ANY")
  //       .get();

  //   final starterAquariums =
  //       snapshot.docs.map((doc) => StarterAquarium.fromDocument(doc)).toList();

  //   return starterAquariums
  //       .map((starterAquarium) =>
  //           StarterAquariumViewModel(starterAquarium: starterAquarium))
  //       .toList();
  // }

  Future<bool> updateUserAquariumType(String newAquariumType, double pHValL,
      double pHValU, double temprL, double temprU) async {
    bool isUpdated = false;

    try {
      Map<String, dynamic> userAquariumMap;

      if (pHValU == null) {
        userAquariumMap = {
          "aquariumType": newAquariumType,
        };
      } else {
        userAquariumMap = {
          "aquariumType": newAquariumType,
          "pHValueL": pHValL,
          "pHValueU": pHValU,
          "temprL": temprL,
          "temprU": temprU,
        };
      }

      FirebaseFirestore.instance
          .collection(Constants.USER_COLLECTION)
          .doc(Global.aquabuildrUserId)
          .collection(Constants.USER_AQUARIUM)
          .doc(Global.userAquarium.aquariumId)
          .update(userAquariumMap);

      isUpdated = true;
    } catch (e) {
      isUpdated = false;
    }

    return isUpdated;
  }

  void updateUserAquariumSize(int aquariumsize) {
    FirebaseFirestore.instance
        .collection(Constants.USER_COLLECTION)
        .doc(Global.aquabuildrUserId)
        .collection(Constants.USER_AQUARIUM)
        .doc(Global.userAquarium.aquariumId)
        .update({"aquariumSize": aquariumsize});
  }
}
