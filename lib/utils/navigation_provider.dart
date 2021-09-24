import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/Starter%20Aquarium%20Detail/viewmodel/starter_aquarium_item_view_model.dart';
import 'package:aquabuildr/utils/Global.dart';
import 'package:aquabuildr/utils/utils.dart';
import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  //bool _isCollapsed = Global.userAquariumType == "ANY" ? false : true;

  bool _isCollapsed =  Global.isStarterAq ? false : true;//Global.userAquariumType == "ANY" ? false : true;

  bool get isCollapsed => _isCollapsed;

  void toggleIsCollapsed() {
    _isCollapsed = !isCollapsed;
    print("iscollapsed toggled");
    print(_isCollapsed.toString());

    notifyListeners();
  }

  bool _isCheckoutPressed = false;
  bool get isCheckoutPressed => _isCheckoutPressed;

  void checkoutPressed() {
    _isCheckoutPressed = !isCheckoutPressed;
    print("checkout notifier activated");

    notifyListeners();
  }


  bool _isKeyboard =  false;

  bool get isKeyboard => _isKeyboard;

  // void toggleIsKeyboard() {
  //   _isKeyboard = !isKeyboard;
  //   print("isKeyboard toggled");
  //   print(_isKeyboard.toString());

  //   notifyListeners();
  // }

  void updateIsKeyboardShown(bool isShown){
      _isKeyboard = isShown;
      notifyListeners();
  }

  bool _isTankSizeCompatible = true;
  bool get isTankSizeCompatible => _isTankSizeCompatible;

  void tankSizeChanged() {
    //_isCheckoutPressed = !isCheckoutPressed;
    //print("checkout notifier activated");
    //_isTankSizeCompatible = !_isTankSizeCompatible;

    print("MaxFishInTank = " + (Utils.getMaxFishInTank() * 6).toString());
    print("currentTankFishCount = " + Global.currentTankFishCount.toString());

    if (Global.userAquariumType == "Goldfish") {
      //int totalGoldFishesInCurrentTank = (Global.currentTankFishCount / 6).floor();
      int totalGoldFishesInCurrentTank = tankItemsCountN;
      int maxGoldFishInTank = Utils.getMaxGoldFishInTank();

      print("totalGoldFishesInCurrentTank = " +
          totalGoldFishesInCurrentTank.toString());
      print("maxGoldFishInTank = " + maxGoldFishInTank.toString());

      if (totalGoldFishesInCurrentTank > maxGoldFishInTank) {
        _isTankSizeCompatible = false;
      } else {
        _isTankSizeCompatible = true;
      }
    } else if (Global.userAquariumType == "Betta") {
      int totalBettaFishesInCurrentTank = tankItemsCountN;
      int maxBettaFishInTank = Utils.getMaxBettaFishInTank();

      print("totalGoldFishesInCurrentTank = " +
          totalBettaFishesInCurrentTank.toString());
      print("maxGoldFishInTank = " + maxBettaFishInTank.toString());

      if (totalBettaFishesInCurrentTank > maxBettaFishInTank) {
        _isTankSizeCompatible = false;
      } else {
        _isTankSizeCompatible = true;
      }
    } else {
      //print("######## NAV PROVIDER #######");
      int currentTankFishCnt = Global.currentTankFishCount;
      int maxFishInTank = Utils.getMaxFishInTank() * 6;

      //print("Current Tank Fish Count = " + Global.currentTankFishCount.toString());
      //print("Max Fish In Tank = " + maxFishInTank.toString());

      if (currentTankFishCnt > maxFishInTank) {
        _isTankSizeCompatible = false;
      } else {
        //_isTankSizeCompatible = true;
        if (Utils.tankSizeInGallons() >= Global.minTankSizeForFishInTank) {
          _isTankSizeCompatible = true;
        } else {
          _isTankSizeCompatible = false;
        }
      }
    }

    notifyListeners();
  }

  int _tankItemsCountN = 0;
  int get tankItemsCountN => _tankItemsCountN;

  void updateTankItemsCountN(int count) {
    _tankItemsCountN = count;
  }

  int _tankItemsCountN_LOGICAL = 0;
  int get tankItemsCountN_LOGICAL => _tankItemsCountN_LOGICAL;

  void updateTankItemsCountN_LOGICAL(int count) {
    _tankItemsCountN_LOGICAL = count;
  }

  void updateCounters(int count) {
    // print("_tankItemsCountN = >>>>>> $_tankItemsCountN");
    // print("count = >>>>>> $count");
    _tankItemsCountN += count;
    // print("after _tankItemsCountN = >>>>>> $_tankItemsCountN");
    notifyListeners();
  }

  bool _isAgreeChecked = false;
  bool get isAgreeChecked => _isAgreeChecked;

  void toggleAgreeChecked() {
    _isAgreeChecked = !isAgreeChecked;
    notifyListeners();
  }

  double _sliderValue = 50;
  double get sliderValue => _sliderValue;

  void updateSlider(double val) {
    _sliderValue = val;
    notifyListeners();
  }

  int _indexTop = Global.userAquariumSize;
  int get indexTop => _indexTop;

  void updateIndexTop(int indextopval) {
    _indexTop = indextopval;
    notifyListeners();
  }

  // List<AquabuildrFishViewModel> _compatibleFishes = [];
  // List<AquabuildrFishViewModel> get compatibleFishes => _compatibleFishes;

  // void setcompatibleFishes(bool isInitial) {
  //   print("********* updateCompatibilityFishesList called  ---------->>> ");
  //   print("********* Global.userAquariumType = " + Global.userAquariumType);

  //   if (Global.userAquariumType == "ANY") {
  //     _compatibleFishes = _fishes;
  //   } else if (Global.userAquariumType == "INCOMPATIBLE") {
  //     _compatibleFishes = [];
  //   } else {
  //     _compatibleFishes = _fishes
  //         .where((aquabuildrfish) =>
  //             aquabuildrfish.aquariumType == Global.userAquariumType)
  //         .toList();
  //     _compatibleFishes = compatibleFishes;
  //   }
  //   print("compatiblefishes lenght beofre notifying = " +
  //       compatibleFishes.length.toString());
  //   if (!isInitial) {
  //     notifyListeners();
  //     print("notifying listernes : compatible fishes lenght = " +
  //         _compatibleFishes.length.toString());
  //   }
  // }

  List<StarterAquariumItemViewModel> _fishItemsInCurrentTank = [];
  List<StarterAquariumItemViewModel> get fishItemsInCurrentTank =>
      _fishItemsInCurrentTank;

  void updateAddedFishesInTank(StarterAquariumItemViewModel tankItem) {
    _fishItemsInCurrentTank.add(tankItem);
  }

  void updateAllFishesInTank(List<StarterAquariumItemViewModel> tankItems) {
    _fishItemsInCurrentTank = tankItems;
  }

  List<AquabuildrFishViewModel> _fishes = [];
  List<AquabuildrFishViewModel> get fishes => _fishes;
  void updateFishesList(List<AquabuildrFishViewModel> availablefishes) {
    _fishes = availablefishes;
    //updateFishesToLoadList("Compatible");
  }

  List<AquabuildrFishViewModel> _compatibleFishes = [];
  List<AquabuildrFishViewModel> get compatibleFishes => _compatibleFishes;

  List<AquabuildrFishViewModel> _fishesToLoad = [];
  List<AquabuildrFishViewModel> get fishesToLoad => _fishesToLoad;

  void updateFishesToLoadList(String fishtype) {

    print("update fishes to load list called ");
    print("------>>>>> Global.userAquariumType = " + Global.userAquariumType);
    print("Fishtype = " + fishtype);

    if (fishtype == "Compatible") {
      if (Global.userAquariumType == "ANY") {
        _fishesToLoad = _fishes;
      } else if (Global.userAquariumType == "INCOMPATIBLE") {
        _fishesToLoad = [];
      } else {
        _fishesToLoad = _fishes
            .where((aquabuildrfish) =>
                aquabuildrfish.aquariumType == Global.userAquariumType)
            .toList();

        int index = 0;
        List<AquabuildrFishViewModel> newFishes = [];

        _fishesToLoad.forEach((aquabuildrFish) {
          //print("index = " + index.toString());
          //print("ForEach = " + aquabuildrFish.species);

          bool isAdd = true;
          fishItemsInCurrentTank.forEach((tankItem) {
            if (tankItem.name == aquabuildrFish.species) {
              //remove from _fishesToLoad
              isAdd = false;
              print("TankItem to remove = " + tankItem.name);
            }
          });
          // isRemove ? newFishes.removeAt(index):
          if (isAdd) {

            //Check for temp compatibility
            if(aquabuildrFish.celsiumTemprU < Global.userAquariumLowerTemprValue || 
            aquabuildrFish.celsiusTemprL > Global.userAquariumUpperTemprValue ){
                print("tempr out of bound");
            }else{
              newFishes.add(aquabuildrFish);

            }
          }
          index++;
        });
        _fishesToLoad = newFishes;
      }
      _compatibleFishes = _fishesToLoad;
    } else if (fishtype == "Freshwater") {
      _fishesToLoad = _fishes
          .where(
              (aquabuildrfish) => aquabuildrfish.aquariumType == "Freshwater")
          .toList();
    } else if (fishtype == "Saltwater") {
      _fishesToLoad = _fishes
          .where((aquabuildrfish) => aquabuildrfish.aquariumType == "Saltwater")
          .toList();
    } else if (fishtype == "Betta") {
      _fishesToLoad = _fishes
          .where((aquabuildrfish) => aquabuildrfish.aquariumType == "Betta")
          .toList();
    } else if (fishtype == "Goldfish") {
      _fishesToLoad = _fishes
          .where((aquabuildrfish) => aquabuildrfish.aquariumType == "Goldfish")
          .toList();
    } else if (fishtype == "All") {
      _fishesToLoad = _fishes;
    }

  }



}
