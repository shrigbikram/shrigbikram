import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/Starter%20Aquariums/viewmodel/starter_aquarium_list_view_model.dart';
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {

  // bool _isCollapsed = Global.userAquariumType == "ANY" ? false : true;
  // bool get isCollapsed => _isCollapsed;

  // void toggleIsCollapsed() {
  //   _isCollapsed = !isCollapsed;
  //   print("iscollapsed toggled");
  //   print(_isCollapsed.toString());

  //   notifyListeners();
  // }


  //AQUABUILDR FISHES
  List<AquabuildrFishViewModel> _aquabuildrFishes = [];
  List<AquabuildrFishViewModel> get aquabuildrFishes => _aquabuildrFishes;

  void updateAquabuildrFishInTank(AquabuildrFishViewModel aqfish) {
    _aquabuildrFishes.add(aqfish);
  }

  void updateAllAquabuildrFishesInTank(List<AquabuildrFishViewModel> aqfishes) {
    _aquabuildrFishes = aqfishes;
  }


  //STARTER AQUARIUMS
  List<StarterAquariumViewModel> _starterAquariums = [];
  List<StarterAquariumViewModel> get starterAquariums => _starterAquariums;

  void updateStarterAquarium(StarterAquariumViewModel starteraq) {
    _starterAquariums.add(starteraq);
  }

  void updateAllStarterAquariums(List<StarterAquariumViewModel> starteraqs) {
    _starterAquariums = starteraqs;
  }


}
