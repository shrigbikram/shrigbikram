import 'package:aquabuildr/Add%20StarterAquarium/model/starter_aquarium.dart';
import 'package:aquabuildr/utils/Global.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StarterAquariumListViewModel extends ChangeNotifier {
  List<StarterAquariumViewModel> starterAquariums = [];

  void loadData(bool isRefresh) async {
    if (Global.starterAquariums.length == 0 || isRefresh) {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(Constants.STARTERAQUARIUMSLIST_COLLECTION)
          // .orderBy("aquariumType")
          .where("aquariumType", isNotEqualTo: "USER")
          .get();

      final starterAquariumslist = snapshot.docs
          .map((doc) => StarterAquarium.fromDocument(doc))
          .toList();

      // return starterAquariums
      //     .map((starterAquarium) =>
      //         StarterAquariumViewModel(starterAquarium: starterAquarium))
      //     .toList();
      starterAquariums = starterAquariumslist
          .map((starterAquarium) =>
              StarterAquariumViewModel(starterAquarium: starterAquarium))
          .toList();

      Global.starterAquariums = starterAquariums;
    } else {
      starterAquariums = Global.starterAquariums;
    }

    notifyListeners();
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

  Future<List<StarterAquariumViewModel>> getUserAquariums(String deviceid) async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(Constants.USER_COLLECTION)
        .doc(deviceid)
        .collection(Constants.USER_AQUARIUM)
        .get();

    final starterAquariums =
        snapshot.docs.map((doc) => StarterAquarium.fromDocument(doc)).toList();


        print("StarterAquariums = " + starterAquariums.length.toString());

    return starterAquariums
        .map((starterAquarium) =>
            StarterAquariumViewModel(starterAquarium: starterAquarium))
        .toList();
  }
}

class StarterAquariumViewModel {
  final StarterAquarium starterAquarium;

  StarterAquariumViewModel({this.starterAquarium});

  String get aquariumId {
    return starterAquarium.aquariumId;
  }

  DocumentReference get aquariumDocRefId {
    return starterAquarium.reference;
  }

  String get aquariumName {
    return starterAquarium.aquariumName;
  }

  String get aquariumType {
    return starterAquarium.aquariumType;
  }

  String get starterKitLabel {
    return starterAquarium.starterKitLabel;
  }

  String get aquariumDesciption {
    return starterAquarium.aquariumDesciption;
  }

  String get photoURL {
    return starterAquarium.photoURL;
  }

  int get aquariumSize {
    return starterAquarium.aquariumSize;
  }

  String get phValue {
    return starterAquarium.pHValue;
  }

  double get pHValueL {
    return starterAquarium.pHValueL;
  }

  double get pHValueU {
    return starterAquarium.pHValueU;
  }

  String get temperature {
    return starterAquarium.temperature;
  }

  double get temprL {
    return starterAquarium.temprL;
  }

  double get temprU {
    return starterAquarium.temprU;
  }

}
