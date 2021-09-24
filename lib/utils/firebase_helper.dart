import 'package:aquabuildr/Starter%20Aquarium%20Detail/viewmodel/starter_aquarium_item_view_model.dart';
import 'package:aquabuildr/utils/Global.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {

  static Future<int> getLogicalUserAquariumItemsCount() async {

    // if(Global.totalFishInCurrentTank > 0){
    //   return Global.totalFishInCurrentTank;
    // }

    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection(Constants.USER_COLLECTION)
        .doc(Global.aquabuildrUserId)
        .collection(Constants.USER_AQUARIUM)
        //.doc(aquarium.aquariumId)
        .doc(Global.userAquariumId)
        .collection("tankitems")
        // .orderBy("date", descending: true)
        .get();


       // print("hello");

    final tankitems = snapshot.docs
        .map((item) => StarterAquariumItemViewModel.fromSnapshot(item))
        .toList();

    int tankitemcnt = 0;



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
    
    Global.totalFishInCurrentTank = biggerFishesCount;

    return biggerFishesCount;
  }

}