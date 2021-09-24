import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/Starter%20Aquarium%20Detail/viewmodel/starter_aquarium_item_list_view_model.dart';
import 'package:aquabuildr/Starter%20Aquariums/viewmodel/starter_aquarium_list_view_model.dart';
import 'package:aquabuildr/utils/Global.dart';
import 'package:aquabuildr/utils/app_navigator.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/utils/navigation_provider.dart';
import 'package:aquabuildr/utils/utils.dart';
import 'package:aquabuildr/widgets/custom_dialogue.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AquabuildrAddToTankFishList extends StatefulWidget {
  final List<AquabuildrFishViewModel> availablefishes;
  final StarterAquariumViewModel starterAquarium;
  final AquabuildrFishViewModel aquabuilderFish;
  final bool isStarterAquarium;
  final String fishTypeInTank;

  final updateTankItem;

  const AquabuildrAddToTankFishList(
      {Key key,
      this.availablefishes,
      this.starterAquarium,
      this.aquabuilderFish,
      this.isStarterAquarium,
      this.updateTankItem,
      this.fishTypeInTank})
      : super(key: key);

  _AquabuildrAddToTankFishListState createState() =>
      _AquabuildrAddToTankFishListState(
          availablefishes: this.availablefishes,
          starterAquarium: this.starterAquarium,
          aquabuilderFish: this.aquabuilderFish,
          isStarterAquarium: this.isStarterAquarium,
          updateTankItem: this.updateTankItem,
          fishTypeInTank: this.fishTypeInTank);
}

class _AquabuildrAddToTankFishListState
    extends State<AquabuildrAddToTankFishList> {
  StarterAquariumItemListViewModel _starterAquariumItemListVM;

  _AquabuildrAddToTankFishListState(
      {this.availablefishes,
      this.starterAquarium,
      this.aquabuilderFish,
      this.isStarterAquarium,
      this.updateTankItem,
      this.fishTypeInTank}) {
    _starterAquariumItemListVM =
        StarterAquariumItemListViewModel(aquarium: starterAquarium);
  }

  final StarterAquariumViewModel starterAquarium;
  final AquabuildrFishViewModel aquabuilderFish;
  final List<AquabuildrFishViewModel> availablefishes;
  final bool isStarterAquarium;
  final String fishTypeInTank;

  final Function updateTankItem;
  int fishQuantity = 0;

  List<AquabuildrFishViewModel> freshwaterFishes = [];
  List<AquabuildrFishViewModel> saltwaterFishes = [];
  List<AquabuildrFishViewModel> bettaFishes = [];
  List<AquabuildrFishViewModel> goldFishes = [];
  //List<AquabuildrFishViewModel> compatibleFishes = [];
  //List<AquabuildrFishViewModel> fishes = [];

  String selectedHeaderTitle = "Compatible Fish";
  NavigationProvider provider;

  @override
  void initState() {
    super.initState();

    if (Global.userAquariumSize == 0) {
      _tankSizeInGallons = 10;
    } else if (Global.userAquariumSize == 1) {
      _tankSizeInGallons = 30;
    } else if (Global.userAquariumSize == 2) {
      _tankSizeInGallons = 50;
    } else if (Global.userAquariumSize == 3) {
      _tankSizeInGallons = 80;
    } else if (Global.userAquariumSize == 4) {
      _tankSizeInGallons = 120;
    } else if (Global.userAquariumSize == 5) {
      _tankSizeInGallons = 180;
    } else {
      _tankSizeInGallons = 30;
    }

    setState(() {
      String aquariumtype;

      if (isStarterAquarium) {
        aquariumtype = starterAquarium.aquariumName;
      } else {
        if (aquabuilderFish == null) {
          aquariumtype = Global.userAquariumType;
        } else {
          aquariumtype = aquabuilderFish.aquariumType;
        }
      }

      fishTypeInTank_C = aquariumtype;

      freshwaterFishes = this
          .availablefishes
          .where(
              (aquabuildrfish) => aquabuildrfish.aquariumType == "Freshwater")
          .toList();

      //print("freshwaterfishes count = " + freshwaterFishes.length.toString());

      saltwaterFishes = this
          .availablefishes
          .where((aquabuildrfish) => aquabuildrfish.aquariumType == "Saltwater")
          .toList();

      // compatibleFishes = this
      //     .availablefishes
      //     .where(
      //         (aquabuildrfish) => aquabuildrfish.aquariumType == aquariumtype)
      //     .toList();

      //Provider.value(value: value) //.updateFishesList(availablefishes);

      provider = Provider.of<NavigationProvider>(context,
          listen: false); //.updateFishesList(availablefishes);
      provider.updateFishesList(availablefishes);
      print("Wow >>>>> " + availablefishes.length.toString());
      print("Wow provider>>>>> " + provider.fishes.length.toString());

      provider
          .updateFishesToLoadList("Compatible"); //setcompatibleFishes(true);
      print("Wow provider complate>>>>> " +
          provider.compatibleFishes.length.toString());

      // final provider = Provider.of<NavigationProvider>(context, listen: false);
      // provider.updateFishesList(availablefishes);
      // provider.updateCompatibilityFishesList();

      //final compatiblefishes = provider.compatibleFishes;
      //compatibleFishes = compatiblefishes;
      //print("compatibles fishes lenght = " + compatibleFishes.length.toString());

      bettaFishes = this
          .availablefishes
          .where((aquabuildrfish) => aquabuildrfish.aquariumType == "Betta")
          .toList();

      goldFishes = this
          .availablefishes
          .where((aquabuildrfish) => aquabuildrfish.aquariumType == "Goldfish")
          .toList();
    });

    updateHeader("Compatible Fish");
  }

  void updateHeader(selectedhtitle) {
    //print("callback to update set state clalled");

    final navprovider = context.read<NavigationProvider>();

    setState(() {
      selectedHeaderTitle = selectedhtitle;

      if (selectedHeaderTitle == "Compatible Fish") {
        navprovider.updateFishesToLoadList("Compatible");
      } else if (selectedHeaderTitle == "Freshwater") {
        //fishes = freshwaterFishes;
        navprovider.updateFishesToLoadList("Freshwater");
      } else if (selectedHeaderTitle == "Saltwater") {
        //fishes = saltwaterFishes;
        navprovider.updateFishesToLoadList("Saltwater");
      } else if (selectedHeaderTitle == "Betta") {
        //fishes = bettaFishes;
        navprovider.updateFishesToLoadList("Betta");
      } else if (selectedHeaderTitle == "Goldfish") {
        //fishes = goldFishes;
        navprovider.updateFishesToLoadList("Goldfish");
      } else if (selectedHeaderTitle == "All") {
        //fishes = availablefishes;
        navprovider.updateFishesToLoadList("All");
      }
    });
  }

  bool _isMaleBettaPresent = false;

  void _checkIfMaleBettaIsPresent(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) async {
    bool isMalePresent =
        await _starterAquariumItemListVM.checkIfUserAquariumHasMaleBetta();
    print("isMalePrsent = " + isMalePresent.toString());

    _isMaleBettaPresent = isMalePresent;

    if (isMalePresent) {
      //Show suggestion that there can only be on Betta Male in the aquarium
      _showSuggestionAlert(
          cxt,
          Constants.SUGGESTION_TIP_TITLE,
          "Only 1 Male Betta is preferred in the tank.\n\nRemove another male betta fish if you wish to add this male fish.",
          "OK",
          "", (isOkPressed, context) {
        if (isOkPressed) {
          //aquabuilderfish.tankQuantity = 1;
          //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
          Navigator.pop(cxt);
          //_checkIfFishAlreadyExists(cxt, aquabuilderfish);

          //print(" <<< Yes pressed >>> ");
          //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          Global.isFishAddingInProgress = false;
        } else {
          Navigator.pop(cxt);
          print("No pressed");
          Global.isFishAddingInProgress = false;
        }
      });
    } else {
      // _checkIfFishIsCompatibleWithCurrentTank(cxt, aquabuilderfish);
      _checkIfFishAlreadyExists(cxt, aquabuilderfish);
    }
  }

  void addToTankPressed(
      BuildContext cxt, AquabuildrFishViewModel availableFish) {
    //print("availableFish.gender = " + availableFish.gender);
    if (isStarterAquarium) {
      _addFishToStarterAquarium(cxt, availableFish);
    } else {
      print("ADD TO TANK PRESSED - DETAILS");
      print("Global.userAquariumType = " + Global.userAquariumType);
      if (Global.userAquariumType != "ANY") {
        if (Global.userAquariumType == "Betta") {
          if (availableFish.gender == "male") {
            _checkIfMaleBettaIsPresent(cxt, availableFish);
          } else {
            _checkIfFishAlreadyExists(cxt, availableFish);
          }
        } else {
          _checkIfFishAlreadyExists(cxt, availableFish);
        }
      } else {
        _checkIfFishAlreadyExists(cxt, availableFish);
      }
      // if (availableFish.aquariumType == "Betta") {
      //   if (availableFish.gender == "male") {
      //     _checkIfMaleBettaIsPresent(cxt, availableFish);
      //   } else {
      //     _checkIfFishAlreadyExists(cxt, availableFish);
      //   }
      // } else {
      //   _checkIfFishAlreadyExists(cxt, availableFish);
      // }
    }
  }

  FishGenderAdded _fishGenderAdded;
  //bool _isPairs = true; //false;
  //String _genderSelected = "male";
  final List<String> _genderItemList = ["male", "female"];

  int _isOnlyMale = 0;
  int _femaleRatio = 0; //def
  //int _quantitySelected = 1;
  int _tankSizeInGallons;
  String _preferredNoPerTankString;
  String fishTypeInTank_C;

  bool _isDash = false;
  bool _isPlus = false;

  void _checkIfFishAlreadyExists(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) async {
    print("Step 1: Checking If Fish Already Exists.");

    bool isExist = true;

    _fishGenderAdded = await _starterAquariumItemListVM
        .checkIfUserAquariumHasFishNamed(aquabuilderfish.species);

    if (aquabuilderfish.gender != "") {
      if (_fishGenderAdded == FishGenderAdded.BOTH_ADDED) {
        //print(">BOTH ADDED");
        isExist = true;
      } else if (_fishGenderAdded == FishGenderAdded.MALE_ADDED) {
        //print(">MALE ADDED");

        if (aquabuilderfish.gender == "male") {
          //display message to add female
          _showDismissAlert(cxt, "Male Fish Already Exists!",
              "You can add female from the droplist.", "Ok", "", false);
          return;
        } else {
          isExist = false; //and add female
        }
      } else if (_fishGenderAdded == FishGenderAdded.FEMALE_ADDED) {
        //print(">FEMALE ADDED");
        if (aquabuilderfish.gender == "male") {
          isExist = false; // and add male
        } else {
          //display message to add male cause female is already added
          _showDismissAlert(cxt, "Female Fish Already Exists!",
              "You can add male from the droplist.", "Ok", "", false);
          return;
        }
      } else {
        //print(">NOT ADDED");
        isExist = false;
      }

      if (isExist) {
        //Fish is already there
        //update item count from the tank
        _showDismissAlert(
            cxt,
            "Fish Already Exists!",
            "If you want to update its quantity then you can change from the tank.",
            "Ok",
            "",
            true);
      } else {
        //_checkIfQtyAddedIsAcceptable(cxt);
        //_checkIfpHofFishIsAcceptable(cxt, aquabuilderfish);
        _checkIfFishIsCompatibleWithCurrentTank(cxt, aquabuilderfish);
      }
    } else {
      if (_fishGenderAdded == FishGenderAdded.BOTH_ADDED ||
          _fishGenderAdded == FishGenderAdded.MALE_ADDED ||
          _fishGenderAdded == FishGenderAdded.FEMALE_ADDED) {
        _showDismissAlert(
            cxt,
            "Fish Already Exists!",
            "If you want to update its quantity then you can change from the tank.",
            "Ok",
            "",
            true);
      } else {
        //_checkIfQtyAddedIsAcceptable(cxt);
        //_checkIfpHofFishIsAcceptable(cxt, aquabuilderfish);
        _checkIfFishIsCompatibleWithCurrentTank(cxt, aquabuilderfish);
      }
    }
  }

  void _checkIfFishIsCompatibleWithCurrentTank(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) {
    print("Step 2: Checking If Fish Is Compatible with Current Tank");

    if (Global.userAquariumType == "ANY") {
      _checkIfpHofFishIsAcceptable(cxt, aquabuilderfish);
    } else {
      if (Global.userAquariumType != aquabuilderfish.aquariumType ||
          Global.userAquariumType == "INCOMPATIBLE") {
        //Show warning
        //There are already fishes not compatible with current fish
        //Do you like to create your new aquarium and replace
        _addIncompatibleFish(cxt, aquabuilderfish);
      } else {
        //Fish in the tank matches with selected tank
        //Add fish to tank
        //Green Signal
        //Add fish to tank
        //_addFish(cxt);
        _checkIfpHofFishIsAcceptable(cxt, aquabuilderfish);
      }
    }
  }

  void _checkIfpHofFishIsAcceptable(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) {
    print("Step 3: Checking If pH is Acceptable");

    String message = "";

    double fL = aquabuilderfish.pHValueL;
    double fU = aquabuilderfish.pHValueU;

    double aqL = Global.userAquariumLowerpHvalue;
    double aqU = Global.userAquariumUpperpHvalue;

    if (fU < aqL) {
      //user aquarium has pH higher than this fish requirement
      //delete all other fishes in the tank to add this fish
      message =
          "Your current tank has pH higher than this fish's preferred pH.\n\nYou will have to delete all other fishes in the tank to add this fish.";
    } else if (fL > aqU) {
      //user aquarium has pH lower than this fish to add
      //delete all other fishes in the tank to add this fish
      message =
          "Your current tank has pH lower than this fish's preferred pH.\n\nYou will have to delete all other fishes in the tank to add this fish.";
    } else {
      //there is intersection
      //find the new pH for aquarium

      if (fL < aqL && fU < aqU) {
        Global.userAquariumUpperpHvalue = fU;
      } else if (aqL < fL && aqU < fU) {
        Global.userAquariumLowerpHvalue = fL;
      } else if (aqL < fL && aqU > fU) {
        Global.userAquariumLowerpHvalue = fL;
        Global.userAquariumUpperpHvalue = fU;
      } else {
        //Good-> same as prev
      }
    }

    if (message != "") {
      _showSuggestionAlert(
          cxt,
          Constants.SUGGESTION_TIP_TITLE,
          message +
              "\n\nAquabuildr doesn't recommend adding this fish to your current tank.",
          "Ok",
          "", (isOkPressed, context) {
        if (isOkPressed) {
          //_quantitySelected = _prefNopertank;
          //aquabuilderfish.tankQuantity = _quantitySelected;
          //Navigator.pop(cxt);
          //_checkIfAddingFishNeedsTankUpdate(cxt);
        } else {
          //Navigator.pop(cxt);
          //_checkIfAddingFishNeedsTankUpdate(cxt);
        }
      });
    } else {
      _checkIfTemprofFishIsAcceptable(cxt, aquabuilderfish);
    }
  }

  void _checkIfTemprofFishIsAcceptable(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) {
    print("Step 4: Checking If temperature is Acceptable");

    String message = "";

    double fL = aquabuilderfish.celsiusTemprL;
    double fU = aquabuilderfish.celsiumTemprU;

    double aqL = Global.userAquariumLowerTemprValue;
    double aqU = Global.userAquariumUpperTemprValue;

    if (fU < aqL) {
      //user aquarium has pH higher than this fish requirement
      //delete all other fishes in the tank to add this fish
      message =
          "Your current tank has temperature higher than this fish's preferred temperature.\n\nYou will have to remove other fishes in the tank to add this fish.";
    } else if (fL > aqU) {
      //user aquarium has pH lower than this fish to add
      //delete all other fishes in the tank to add this fish
      message =
          "Your current tank has temperature lower than this fish's preferred temperature.\n\nYou will have to remove other fishes in the tank to add this fish.";
    } else {
      //there is intersection
      //find the new pH for aquarium

      if (fL < aqL && fU < aqU) {
        Global.userAquariumUpperTemprValue = fU;
      } else if (aqL < fL && aqU < fU) {
        Global.userAquariumLowerTemprValue = fL;
      } else if (aqL < fL && aqU > fU) {
        Global.userAquariumLowerTemprValue = fL;
        Global.userAquariumUpperTemprValue = fU;
      } else {
        //Good-> same as prev
      }
    }

    if (message != "") {
      _showSuggestionAlert(
          cxt,
          Constants.SUGGESTION_TIP_TITLE,
          message +
              "\n\nAquabuildr doesn't recommend adding this fish to your current tank.",
          "Ok",
          "", (isOkPressed, context) {
        if (isOkPressed) {
          //_quantitySelected = _prefNopertank;
          //aquabuilderfish.tankQuantity = _quantitySelected;
          Navigator.pop(cxt);
          //_checkIfAddingFishNeedsTankUpdate(cxt);
        } else {
          // Navigator.pop(cxt);
          //_checkIfAddingFishNeedsTankUpdate(cxt);
        }
      });
    } else {
      _checkIfTankSizeIsSufficientToAddNewFish(cxt, aquabuilderfish);
    }
  }

  void _checkIfTankSizeIsSufficientToAddNewFish(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) async {
    
    print("Step 5: Checking If TankSize is Sufficient for New Fish");

    if (aquabuilderfish.aquariumType == "Betta") {
      int maxNoOfBettaFish = Utils.getMaxBettaFishInTank(); //10 - 2 ota
      int totalBettafishesintank =
          await _starterAquariumItemListVM.getLogicalUserAquariumItemsCount();

      print("Total Betta Fish in tank = " + totalBettafishesintank.toString());

      int futureFieshCountInTank;
      futureFieshCountInTank =
          totalBettafishesintank + aquabuilderfish.tankQuantity;

      int currentTankSize = Utils.tankSizeInGallons();

      print("BETTA >>> Future Fish Count in Tank = " +
          futureFieshCountInTank.toString());
      print("Max No of Betta Fish = " + maxNoOfBettaFish.toString());

      if (futureFieshCountInTank > maxNoOfBettaFish) {
        //show alert to increase tank size or decrease qty
        _showSuggestionAlert(
            cxt,
            "Insufficient Space!",
            "Your current tank size is $currentTankSize gallons where we recommend $maxNoOfBettaFish Betta fishes.\n\nRemove other fishes in the tank or increase your tank size to add this.",
            //"You will have to increase your tank size or decrease the quantity of this fish to add into your current tank.",
            "OK",
            "", (isOkPressed, context) {
          if (isOkPressed) {
            //aquabuilderfish.tankQuantity = _prefNopertank;
            //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
            //Global.userAquariumSize = Global.userAquariumSize + 1;
            //_starterAquariumItemListVM.updateUserAquariumSize(Global.userAquariumSize);
            Navigator.pop(cxt);
            Global.isFishAddingInProgress = false;

            provider.toggleIsCollapsed();
            //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          } else {
            Global.isFishAddingInProgress = false;

            Navigator.pop(cxt);
          }
        });
      } else {
        _checkIfQtyAddedIsAcceptable(cxt, aquabuilderfish);
      }

      return;
    }

    int currentTankSize = Utils.tankSizeInGallons();
    int spaceUsedByFishes = Global.spaceUsedByCurrentFishesInTank;

    print("aquabuilderFish.adultsize = " + aquabuilderfish.adultSize.toString());

    if(spaceUsedByFishes + aquabuilderfish.adultSize > currentTankSize){

      int spaceRemained = currentTankSize - spaceUsedByFishes;


      // Insufficient space
      _showSuggestionAlert(
            cxt,
            "Insufficient Space!",
            "Your current tank size is $currentTankSize gallons where $spaceUsedByFishes gallons is already occupied.\n\nYou can have fish whose adult size is less than or equal to $spaceRemained inches or you can remove other fishes.",
            //"You will have to increase your tank size or decrease the quantity of this fish to add into your current tank.",
            "OK",
            "", (isOkPressed, context) {
          if (isOkPressed) {
            //aquabuilderfish.tankQuantity = _prefNopertank;
            //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
            Navigator.pop(cxt);
            Global.isFishAddingInProgress = false;
            //provider.toggleIsCollapsed();

            //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          }
        });
    }else{
       //new
      _checkIfQtyAddedIsAcceptable(cxt, aquabuilderfish);
    }

   
    return;


    // _checkIfQtyAddedIsAcceptable(cxt, aquabuilderfish);
    // return;

    int maxNoOfFish = Utils.getMaxFishInTank();
    int maxNoOfFish_smaller = maxNoOfFish * 6;

    //int currentTankSize = Utils.tankSizeInGallons();
    int nextTankSize = Utils.getNextTankSizeInGallons();

    int totalfishesintank =
        await _starterAquariumItemListVM.getLogicalUserAquariumItemsCount();

    int futureFieshCountInTank;
    if (aquabuilderfish.adultSize > 3) {
      futureFieshCountInTank =
          totalfishesintank + (aquabuilderfish.tankQuantity * 6);
    } else {
      futureFieshCountInTank = totalfishesintank + aquabuilderfish.tankQuantity;
    }

    // print("Future fishes count in this tank = " +
    //     futureFieshCountInTank.toString());
    // print("Current Fishes in Tank = " + totalfishesintank.toString());
    // print(
    //     "Max fishes in this Tank(smaller) = " + maxNoOfFish_smaller.toString());

    if (futureFieshCountInTank > maxNoOfFish_smaller) {
      if (nextTankSize == 200) {
        _showSuggestionAlert(
            cxt,
            "Insufficient Space!",
            "Your current tank size is $currentTankSize gallons where we recommend around $maxNoOfFish relatively bigger fishes or $maxNoOfFish_smaller smaller ones.\n\nRemove other fishes in your tank to add this one.",
            //"You will have to increase your tank size or decrease the quantity of this fish to add into your current tank.",
            "OK",
            "", (isOkPressed, context) {
          if (isOkPressed) {
            //aquabuilderfish.tankQuantity = _prefNopertank;
            //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
            Navigator.pop(cxt);
            Global.isFishAddingInProgress = false;
            provider.toggleIsCollapsed();

            //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          }
        });
      } else {
        int qtyf = aquabuilderfish.tankQuantity;
        String fishNam = aquabuilderfish.species;
        _showSuggestionAlert(
            cxt,
            "Insufficient Space!",
            "You can increase your tank size or decrease the quantity to add $qtyf $fishNam.",
            //"Your current tank size is $currentTankSize gallons where we recommend around $maxNoOfFish relatively bigger fishes or $maxNoOfFish_smaller smaller ones.",
            //"You will have to increase your tank size or decrease the quantity of this fish to add into your current tank.",
            "OK",
            "", (isOkPressed, context) {
          if (isOkPressed) {
            //aquabuilderfish.tankQuantity = _prefNopertank;
            //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
            //Global.userAquariumSize = Global.userAquariumSize + 1;
            //_starterAquariumItemListVM.updateUserAquariumSize(Global.userAquariumSize);
            Navigator.pop(cxt);
            Global.isFishAddingInProgress = false;
            provider.toggleIsCollapsed();

            //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          } else {
            Global.isFishAddingInProgress = false;

            Navigator.pop(cxt);
          }
        });
      }
    } else {
      _checkIfQtyAddedIsAcceptable(cxt, aquabuilderfish);
    }

    //#thistime
  }

  void _checkIfQtyAddedIsAcceptable(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) {
    print("Step 6: Checking If Qty Added Is Acceptable");

    if (aquabuilderfish.aquariumType == "Goldfish") {
      if (provider.tankItemsCountN < 2) {
        //show suggestion to add at least 2 Goldfish
        _showSuggestionAlert(
            cxt,
            Constants.SUGGESTION_TIP_TITLE,
            "2+ Goldfish are suggested in the tank. \n\nDo you want to change quantity to 2 and add ?",
            "YES",
            "NO", (isOkPressed, context) {
          if (isOkPressed) {
            aquabuilderfish.tankQuantity = 2;
            //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
            Navigator.pop(cxt);
            print(" <<< Yes pressed >>> ");
            _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            Global.isFishAddingInProgress = false;
          } else {
            Navigator.pop(cxt);
            print("No pressed");
            Global.isFishAddingInProgress = false;
          }
        });
      } else {
        //simple add the selected quantity
        _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
      }
      // if (aquabuilderfish.tankQuantity < 2) {
      //   //Pref # per tank: 2+ (similar species)

      // } else {
      //   //add and check for tank
      // }
      return;
    }

    if (aquabuilderfish.aquariumType == "Betta") {
      //Pref # per tank: 1 male and up to 6 females

      if (aquabuilderfish.gender == "female") {
        if (aquabuilderfish.tankQuantity < 6) {
          //okay add
          _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
        } else {
          //show suggestion
          _showSuggestionAlert(
              cxt,
              Constants.SUGGESTION_TIP_TITLE,
              "For Betta fish 1 Male and Upto 6 Females are preferred in the tank.\n\nDo you want to change quantity to 6 and add?",
              "YES",
              "NO", (isOkPressed, context) {
            if (isOkPressed) {
              //aquabuilderfish.tankQuantity = 7;
              //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
              Navigator.pop(cxt);
              Global.isFishAddingInProgress = false;

              //print(" <<< Yes pressed >>> ");
              //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            } else {
              Navigator.pop(cxt);
              print("No pressed");
              Global.isFishAddingInProgress = false;
            }
          });
        }
      } else {
        //male fish
        if (aquabuilderfish.tankQuantity > 1) {
          //show suggestion -> Only 1 M is recommended
          //show suggestion
          _showSuggestionAlert(
              cxt,
              Constants.SUGGESTION_TIP_TITLE,
              "For Betta, only 1 Male is preferred in the tank.\n\nDo you want to change quantity to 1 and add?",
              "YES",
              "NO", (isOkPressed, context) {
            if (isOkPressed) {
              aquabuilderfish.tankQuantity = 1;
              //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
              Navigator.pop(cxt);
              Global.isFishAddingInProgress = false;

              //print(" <<< Yes pressed >>> ");
              _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            } else {
              Navigator.pop(cxt);
              print("No pressed");
              Global.isFishAddingInProgress = false;
            }
          });
        } else {
          //okay add
          _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
        }
      }

      return;
    }

    String prefnointankpred = aquabuilderfish.preferredNoPerTankPred;
    print(" >>>>> Pref No. In Tank = " + prefnointankpred);

    List<String> result = prefnointankpred.split('#');
    int _prefNopertank;
    if (result[0].length != 0) {
      _prefNopertank = int.parse(result[0]);
    } else {
      print("NA");
    }
    _isDash = false;
    int _prefNopertankAppend;
    if (result[1] != "") {
      //- is present
      _isDash = true;
      _prefNopertankAppend = int.parse(result[2]);
      print("_prefNopertankAppend = " + _prefNopertankAppend.toString());
      print("result[1] = " + result[1]);
    }

    _isPlus = false;
    if (result[3] != "") {
      //+ is present // you can have more than 2/3/4
      _isPlus = true;
    }

    _isOnlyMale = 0;
    if (result[5] != "") {
      //warning -> only 1 Male
      print("result[5] = " + result[5]);
      _isOnlyMale = int.parse(result[5]);
    }

    bool _isPairs = false;
    if (result[4] != "") {
      //pairs so display M/F
      _isPairs = true; //result[4];//biknew

    }

    bool _isEspecial = false;
    if (result[6] != "") {
      //this is especial // so display message in string - undisputedly
      _isEspecial = true;
    }

    String maleFemaleRatio;
    int _maleRatio;
    //int _femaleRatio;
    _femaleRatio = 0;
    if (result[7] != "") {
      maleFemaleRatio = result[7];

      List<String> resultratio = maleFemaleRatio.split(':');
      //print("male = " + resultratio[0]);
      //print("female = " + resultratio[1]);

      _maleRatio = int.parse(resultratio[0]);
      _femaleRatio = int.parse(resultratio[1]);
    }

    String fishtoadd_name = aquabuilderfish.species;
    String is_areString = "is";
    if (_prefNopertank > 1) {
      is_areString = "are";
    }

    print("CHECKING FOR GENERAL FISHES\n");

    print("_isPairs = " + _isPairs.toString());
    print("_isPlus = " + _isPlus.toString());
    print("_isDash = " + _isDash.toString());
    print("_isOnlyMale = " + _isOnlyMale.toString());

    //print(_maleRatio.toString());

    // if (_maleRatio > 0) {
    //   print("_maleRatio : _femaleRatio = " +
    //       _maleRatio.toString() +
    //       ":" +
    //       _femaleRatio.toString());
    // }

    // if(aquabuilderfish.gender != null){
    //     print("gender = " + aquabuilderfish.gender);
    // }

    print("\n");

    //Only number is preferred
    if (!_isPlus && !_isDash && !_isEspecial) {
      //Only number is suggested
      print("only number is suggested !");
      print("Preferred no. per tank for this fish = $_prefNopertank ");

      if (aquabuilderfish.tankQuantity > _prefNopertank) {
        print("Preferred no. per tank = $_prefNopertank");

        _showSuggestionAlert(
            cxt,
            Constants.SUGGESTION_TIP_TITLE,
            "Only $_prefNopertank $fishtoadd_name $is_areString suggested in the tank. \n\nDo you want to change quantity to $_prefNopertank and add ?",
            "YES",
            "", (isOkPressed, context) {
          if (isOkPressed) {
            aquabuilderfish.tankQuantity = _prefNopertank;
            //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
            Navigator.pop(cxt);
            print(" <<< Yes pressed >>> ");

            // Future.delayed(const Duration(milliseconds: 500), () {

            _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);

            Global.isFishAddingInProgress = false;

            //});

          } else {
            //Navigator.pop(cxt);
            //_addToTankPressed_After(cxt);
            //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            print("No pressed");
            Global.isFishAddingInProgress = false;
          }
        });
        return;
      } else {
        //_addToTankPressed_After(cxt);
        //_addFishToTank(cxt);
        _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
      }
      return;
    }

    //Fish has ratio 1:2 or 1:4 or 1:1
    else if (aquabuilderfish.gender != "" &&
        _femaleRatio >= 1 &&
        _isOnlyMale == 0 &&
        _isPairs &&
        !_isDash) {
      print("This fish has some ratio like 1:2 1:4");

      _showSuggestionAlert(
          cxt,
          Constants.SUGGESTION_TIP_TITLE,
          "You can have $_prefNopertank+ $fishtoadd_name where 1 male requires $_femaleRatio female.",
          "OK",
          "", (isOkPressed, context) {
        if (isOkPressed) {
          //_quantitySelected = _prefNopertank;
          Navigator.pop(cxt);
          _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
        } else {
          //Navigator.pop(cxt);
          //_addToTankPressed_After(cxt);
          //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
        }
      });
    }

    //number plus  is preferred
    else if (_isPlus && !_isPairs) {
      //print("Preferred no. per tank for this fish = $_prefNopertank+ ");
      print("isplus but no pairs !");

      if (aquabuilderfish.tankQuantity < _prefNopertank) {
        //print("Preferred no. per tank = $_prefNopertank+");
        _showSuggestionAlert(
            cxt,
            Constants.SUGGESTION_TIP_TITLE,
            "$_prefNopertank + fish are suggested to add in the tank for this fish type. \n\n Do you want to change quantity to at least $_prefNopertank now ?",
            "YES",
            "NO", (isOkPressed, context) {
          if (isOkPressed) {
            //_quantitySelected = _prefNopertank;
            aquabuilderfish.tankQuantity = _prefNopertank;
            print("quantity selected = " +
                aquabuilderfish.tankQuantity.toString());

            Navigator.pop(cxt);
            _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          } else {
            Navigator.pop(cxt);
            //_addToTankPressed_After(cxt);
            _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          }
        });
      } else {
        //_addToTankPressed_After(cxt);
        //_addFishToTank(cxt);
        _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
      }

      return;
    }

    //1-2 pairs
    else if (aquabuilderfish.gender != "" &&
        _isPairs &&
        _isDash &&
        !_isPlus &&
        _isOnlyMale == 0) {
      //1-2 pairs

      print("1-2 pairs type fish");

      if (aquabuilderfish.tankQuantity > _prefNopertankAppend) {
        _showSuggestionAlert(
            cxt,
            Constants.SUGGESTION_TIP_TITLE,
            "It is recommended to keep $_prefNopertank - $_prefNopertankAppend pairs of $fishtoadd_name.\n\nDo you like to update it's quantity to $_prefNopertankAppend and add?",
            "OK",
            "Cancel", (isOkPressed, context) {
          if (isOkPressed) {
            aquabuilderfish.tankQuantity = _prefNopertankAppend;
            //aquabuilderfish.tankQuantity = _quantitySelected;
            Navigator.pop(cxt);
            _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          } else {
            Navigator.pop(cxt);
            //_addToTankPressed_After(cxt);
            //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          }
        });
      } else {
        _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
      }
      return;
    }

    //1-2 pairs PLUS
    else if (aquabuilderfish.gender != "" && _isDash && _isPlus) {
      //1-2 pairs PLUS

      print("1-2 PLUS pairs type fish");
      _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
      return;
    }

    //3+ (only 1 male)
    else if (_isOnlyMale != 0 && _isPlus) {
      print("$_prefNopertank + (only 1 male)");

      if (aquabuilderfish.gender == "male") {
        if (aquabuilderfish.tankQuantity > 1) {
          _showSuggestionAlert(
              cxt,
              Constants.SUGGESTION_TIP_TITLE,
              "Only 1 male of $fishtoadd_name is preferred in the tank.\n\nDo you like to update it's quantity to 1 and add?",
              "OK",
              "Cancel", (isOkPressed, context) {
            if (isOkPressed) {
              aquabuilderfish.tankQuantity = 1;
              //aquabuilderfish.tankQuantity = _quantitySelected;
              Navigator.pop(cxt);
              _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            } else {
              Navigator.pop(cxt);
              //_addToTankPressed_After(cxt);
              //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            }
          });
        } else {
          //ok add
          _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
        }
      } else {
        //female

        if (aquabuilderfish.tankQuantity > 1) {
          //allow add
          _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
        } else {
          //show alert
          _showSuggestionAlert(
              cxt,
              Constants.SUGGESTION_TIP_TITLE,
              "It is recommended to keep $_prefNopertank + of $fishtoadd_name.\n\nDo you like to update it's quantity to at least 2 and add?",
              "OK",
              "Cancel", (isOkPressed, context) {
            if (isOkPressed) {
              aquabuilderfish.tankQuantity = 2;
              //aquabuilderfish.tankQuantity = _quantitySelected;
              Navigator.pop(cxt);
              _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            } else {
              Navigator.pop(cxt);
              //_addToTankPressed_After(cxt);
              //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            }
          });
        }
      }
      return;
    }

    //1-4(Only 1 Male)
    else if (_isDash && aquabuilderfish.gender != "" && _isOnlyMale != 0) {
      print(
          "Pref. no. in tank >> = $_prefNopertank - $_prefNopertankAppend ($_isOnlyMale Male only)");

      if (aquabuilderfish.gender == "male") {
        if (aquabuilderfish.tankQuantity > 1) {
          _showSuggestionAlert(
              cxt,
              Constants.SUGGESTION_TIP_TITLE,
              "Only 1 male of $fishtoadd_name is preferred in the tank.\n\nDo you like to update it's quantity to 1 and add?",
              "OK",
              "Cancel", (isOkPressed, context) {
            if (isOkPressed) {
              aquabuilderfish.tankQuantity = 1;
              Navigator.pop(cxt);
              _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            } else {
              Navigator.pop(cxt);
            }
          });
        } else {
          //ok add
          _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
        }
      } else {
        //female

        if (aquabuilderfish.tankQuantity < _prefNopertankAppend) {
          //allow add
          _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
        } else {
          //show alert
          _showSuggestionAlert(
              cxt,
              Constants.SUGGESTION_TIP_TITLE,
              "It is recommended to keep $_prefNopertank - $_prefNopertankAppend (only 1 Male)  of $fishtoadd_name.\n\nDo you like to update it's quantity to at least 3 and add?",
              "OK",
              "Cancel", (isOkPressed, context) {
            if (isOkPressed) {
              aquabuilderfish.tankQuantity = 3;
              //aquabuilderfish.tankQuantity = _quantitySelected;
              Navigator.pop(cxt);
              _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            } else {
              Navigator.pop(cxt);
              //_addToTankPressed_After(cxt);
              //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            }
          });
        }
      }
      return;
    }

    //1-2
    else if (_isDash && !_isPairs && !_isPlus && !_isEspecial) {
      print("##Pref. no. in tank >> = $_prefNopertank - $_prefNopertankAppend");

      if (aquabuilderfish.tankQuantity > 2) {
        _showSuggestionAlert(
            cxt,
            Constants.SUGGESTION_TIP_TITLE,
            "Only $_prefNopertank - $_prefNopertankAppend $fishtoadd_name are preferred in the tank.\n\nDo you like to update it's quantity to at least 2 and add?",
            "OK",
            "Cancel", (isOkPressed, context) {
          if (isOkPressed) {
            aquabuilderfish.tankQuantity = 2;
            Navigator.pop(cxt);
            _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          } else {
            Navigator.pop(cxt);
          }
        });
      } else {
        //ok add
        _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
      }
      return;
    }

    //NA
    else {
      print("Not general type detected ");
      print("$prefnointankpred");
    }
  }

  void _checkIfAddingFishNeedsTankUpdate(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) {
    print("\nStep 7: Checking If Adding this Fish Needs Tank Update");

    print(
        "Fish MinimunTankSize = " + aquabuilderfish.minimumTankSize.toString());
    _tankSizeInGallons = Utils.tankSizeInGallons();
    print("Current Tank Size = " + _tankSizeInGallons.toString());

    if (aquabuilderfish.aquariumType == "Goldfish") {
      print("tank items count = " + provider.tankItemsCountN.toString());

      int tankItemsCnt = provider.tankItemsCountN;

      int tanksizereq = (aquabuilderfish.tankQuantity + tankItemsCnt) * 20;

      int fishQty = aquabuilderfish.tankQuantity;

      if (_tankSizeInGallons >= tanksizereq) {
        //okay add to tank
        _addFishToTank(context, aquabuilderfish);
      } else {
        String goldfishmsg;
        if (tankItemsCnt > 0) {
          goldfishmsg = "more";
        } else {
          goldfishmsg = "";
        }

        //tanksizereq = tanksizereq - 1; // to show greater than
        //Ask user to increase tank size to add
        _showSuggestionAlert(
            cxt,
            Constants.SUGGESTION_TIP_TITLE,
            "Each goldfish requires minimum 20 gallons tank size.\n\nIncrease your tank size to $tanksizereq gallons or more to add $fishQty $goldfishmsg Goldfish.",
            "OK",
            "", (isOkPressed, context) {
          if (isOkPressed) {
            //aquabuilderfish.tankQuantity = 2;
            //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
            Navigator.pop(cxt);
            print(" <<< Yes pressed >>> ");
            //_addFishToTank(context, aquabuilderfish);

            Global.isFishAddingInProgress = false;

            // _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          } else {
            Navigator.pop(cxt);
            print("No pressed");
            Global.isFishAddingInProgress = false;
          }
        });
      }

      return;
    }

    if (aquabuilderfish.aquariumType == "Betta") {
      print("tank items count = " + provider.tankItemsCountN.toString());

      int tankItemsCnt = provider.tankItemsCountN;
      int tanksizereq =
          (aquabuilderfish.tankQuantity + 1 + tankItemsCnt); //+1 female pair
      int fishQty = aquabuilderfish.tankQuantity + 1;

      if (_tankSizeInGallons >= tanksizereq) {
        //okay add to tank
        _addFishToTank(context, aquabuilderfish);
      } else {
        String goldfishmsg;
        if (tankItemsCnt > 0) {
          goldfishmsg = "more";
        } else {
          goldfishmsg = "";
        }

        //Ask user to increase tank size to add
        _showSuggestionAlert(
            cxt,
            Constants.SUGGESTION_TIP_TITLE,
            "Each Betta fish requires minimum 5 gallons tank size.\n\nIncrease your tank size to $tanksizereq to add $fishQty $goldfishmsg Betta fish.",
            "OK",
            "", (isOkPressed, context) {
          if (isOkPressed) {
            //aquabuilderfish.tankQuantity = 2;
            //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
            Navigator.pop(cxt);
            print(" <<< Yes pressed >>> ");
            //_addFishToTank(context, aquabuilderfish);
            Global.isFishAddingInProgress = false;

            // _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          } else {
            Global.isFishAddingInProgress = false;

            Navigator.pop(cxt);
            print("No pressed");
          }
        });
      }

      return;
    }

    if (aquabuilderfish.minimumTankSize > _tankSizeInGallons) {
      print("This fish needs bigger tank size than your current tank ");
      //print("Your tank size = " + _tankSizeInGallons.toString());
      //print("Tank size for this fish  = " +
      //    aquabuilderfish.minimumTankSize.toString());

      String yourtanksize = Global.userAquariumSize.toString();
      String minTankSizeForFish = aquabuilderfish.minimumTankSize.toString();
      String selectedfishname = aquabuilderfish.species;

      // showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Text("Wifi"),
      //       content: Text("Wifi not detected. Please activate it."),
      //     )
      // );

      //show advisory to increase your tank
      // _showFishAdvisoryDismissAlert(context, "FISH ADVISORY", "$selectedfishname requires minimum of $minTankSizeForFish gallons tank size but your tank has size of $yourtanksize. Consider increase your tank size if you wish to add this fish.", "Ok", "", false);
      String tankSizeForFish = aquabuilderfish.minimumTankSize.toString();

      int recomTankSizeInGallons =
          Utils.getTankSizeinGalllonsForFishMinTankSize(
              aquabuilderfish.minimumTankSize);

      //String tankSizeForFish = aquabuilderfish.minimumTankSize.toString();
      String title = "Warning, Tank Size!";
      String desc =
          "Your current tank size is $_tankSizeInGallons gallons, but the fish you are adding requires tank size of $minTankSizeForFish gallons." +
              "\n\nDo you want to increase your tank size to $recomTankSizeInGallons gallons and add this fish?";
      String okBtnText = "YES";
      String cancelBtnText = "NO";
      bool isNavigating = false;

      ABAlertType abalerttype;
      abalerttype = ABAlertType.DISMISSALERT;
      showDialog(
        context: cxt,
        builder: (context) => CustomDialog(
          title: title,
          description: desc,
          okButtonText: okBtnText,
          cancelButtonText: cancelBtnText,
          abAlertType: abalerttype,
          onOkBtnPressed: (isOkPressed, context) {
            if (isOkPressed) {
              Navigator.pop(context);
              //_addFishToUserAquarium(cxt);
              int recomTankSize = Utils.getuserAquariumSizeForFishMinTankSize(
                  aquabuilderfish.minimumTankSize);

              Global.userAquariumSize = recomTankSize;
              _starterAquariumItemListVM.updateUserAquariumSize(recomTankSize);

              provider
                  .updateIndexTop(Global.userAquariumSize); //to update slider

              _addFishToTank(context, aquabuilderfish);
            } else {
              Navigator.pop(context);
              //_addFishToUserAquarium(cxt);
              //_addFishToTank(cxt);

            }
          },
        ),
      );
    } else {
      print("Adding fish to tank because tank size is good for this fish");
      //_addFishToUserAquarium(context);
      _addFishToTank(cxt, aquabuilderfish);
    }
  }

  void _showSuggestionAlert(
      BuildContext cxt,
      String title,
      String desc,
      String okbtntxt,
      String cancelbtntxt,
      void Function(bool, BuildContext) onOkBtnPressed) {
    ABAlertType abalerttype;
    abalerttype = ABAlertType.DISMISSALERT;
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        description: desc,
        okButtonText: okbtntxt,
        cancelButtonText: cancelbtntxt,
        abAlertType: abalerttype,
        onOkBtnPressed: (isOkPressed, context) {
          onOkBtnPressed(isOkPressed, context);
          // if (isOkPressed) {
          //Navigator.pop(cxt);
          // } else {
          //   Navigator.pop(cxt);
          //   //_addToTankPressed_After(cxt);
          //   _checkIfAddingFishNeedsTankUpdate(cxt);
          // }
        },
      ),
    );
  }

  void _showDismissAlert(BuildContext cxt, String title, String desc,
      String okBtnText, String cancelBtnText, bool isNavigating) {
    ABAlertType abalerttype;
    abalerttype = ABAlertType.DISMISSALERT;
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: title,
        description: desc,
        okButtonText: okBtnText,
        cancelButtonText: cancelBtnText,
        abAlertType: abalerttype,
        onOkBtnPressed: (isOkPressed, context) {
          if (isOkPressed) {
            print("OK PRESSED !");
            Navigator.pop(context);
            Global.isFishAddingInProgress = false;

            if (isNavigating) {
              // AppNavigator.navigateToStarterAquariumDetailPage(
              //     context,
              //     Global.userAquarium,
              //     aquabuilderfish,
              //     false,
              //     aquabuilderfish.aquariumType);
              //Navigator.pop(context);
            }
          } else {
            Global.isFishAddingInProgress = false;

            print("NO PRESSED !");
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final provider = Provider.of<NavigationProvider>(context, listen: true);
    // final compatible_fishes = provider.compatibleFishes;

    final navprovider = context.watch<NavigationProvider>();

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.red, 
          //border: Border.all(color: Colors.red, width: 1),
          //Colors.grey.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 0.1,
              blurRadius: 0.1,
            ),
          ],
        ),
        //color: Colors.red,
        child: Column(
          children: [
            //Text(provider.compatibleFishes.length.toString(), style: TextStyle(fontSize: 30,),),
            Container(
                height: 70,
                child: buildCompatibleFishesHeader(
                    //provider.compatibleFishes.length,
                    navprovider.fishesToLoad.length,
                    freshwaterFishes.length,
                    selectedHeaderTitle,
                    (selectetitle) => {
                          // print("Selected title = " + selectetitle)
                          updateHeader(selectetitle)
                        })),
            Expanded(
              child: Container(
                color: Colors.white,
                child: navprovider.fishesToLoad.length == 0
                    ? Container(
                        margin: EdgeInsets.fromLTRB(40, 0, 10, 0),

                        //color: Colors.black87,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //#now
                            Image.asset(
                              "assets/images/aq_logo.png",
                              width: 100,
                              height: 100,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Oh no, there are no compatible fish!",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w800),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 20,
                            ),

                            Text(
                              "There are no fish in our inverntory that are compatible with the fish you currently have in your tank. Try removing one or more fish from your tank to see more compatible fish options.",
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey.shade600),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: navprovider.fishesToLoad.length,
                        itemBuilder: (context, index) {
                          final availableFish = navprovider.fishesToLoad[index];
                          if (availableFish.tankQuantity == null) {
                            availableFish.tankQuantity = 0;
                          }

                          // String prefnointankpred = availableFish.preferredNoPerTankPred;

                          // List<String> result = prefnointankpred.split('#');
                          // print("result = " + result.toString());

                          // if (result[4] != "") {
                          //   //pairs so display M/F
                          //   _isPairs = true; //result[4];
                          // }

                          // if(availableFish.gender != ""){
                          //   _isPairs = true;
                          // }

                          return GestureDetector(
                            onTap: () {
                              print("index tapped = " + index.toString());
                              AppNavigator.navigateToAquabuildrFishDetailPage(
                                  context,
                                  availableFish,
                                  availablefishes,
                                  true);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white, //Colors.grey.shade100,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 1.9,
                                    blurRadius: 1,
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.fromLTRB(36, 16, 26, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: CachedNetworkImage(
                                        imageUrl: availableFish.photoURL,
                                        height: 130,
                                        width: 150,
                                        fit: BoxFit.scaleDown),
                                  ),
                                  Text(
                                    availableFish.aquariumType,
                                    style: TextStyle(
                                        color: Colors.lightBlue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  SizedBox(height: 4),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18),
                                    child: Text(
                                      availableFish.species,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print("+ pressed");
                                            setState(() {
                                              if (availableFish.tankQuantity <
                                                  availableFish.quantity) {
                                                availableFish.tankQuantity =
                                                    availableFish.tankQuantity +
                                                        1;
                                              }
                                            });
                                          },
                                          child: Container(
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          availableFish.tankQuantity.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            print("- pressed");

                                            setState(() {
                                              if (availableFish.tankQuantity >
                                                  0) {
                                                availableFish.tankQuantity =
                                                    availableFish.tankQuantity -
                                                        1;
                                              }
                                            });
                                          },
                                          child: Container(
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ]),
                                  availableFish.gender != ""
                                      ? DropdownButton(
                                          hint: Text(
                                            "Male",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          value: availableFish.gender,
                                          onChanged: (newValue) {
                                            setState(() {
                                              availableFish.gender = newValue;
                                              //_genderSelected = newValue;
                                            });
                                          },
                                          items: _genderItemList.map((gender) {
                                            return DropdownMenuItem(
                                              child: new Text(
                                                gender,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              value: gender,
                                            );
                                          }).toList(),
                                        )
                                      : Container(),
                                  SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      //#addtotank
                                      print(
                                          "-------- Add to Tank pressed! ---------");

                                      if (availableFish.tankQuantity > 0) {
                                        if (Global.isFishAddingInProgress ==
                                            null) {
                                          Global.isFishAddingInProgress = false;
                                        }

                                        if (!Global.isFishAddingInProgress) {
                                          //Global.isFishAddingInProgress = true;

                                          addToTankPressed(
                                              context, availableFish);
                                        } else {
                                          print(
                                              "Wait !!... fish adding in progress.....");
                                        }
                                      }
                                    },
                                    child: Container(
                                        // optional
                                        padding:
                                            const EdgeInsets.only(bottom: 1.0),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 2.0,
                                                    color:
                                                        Colors.greenAccent))),
                                        child: Text(
                                          'Add to Tank',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        )),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addFishToTank(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) async {
    print("\nStep 8: Checking If Adding this Fish Needs Tank Update");

    //add fish to tank

    fishTypeInTank_C = Global.userAquariumType;

    if (fishTypeInTank_C == "ANY") {
      //Green Signal
      //Add fish to tank
      _addFish(cxt, aquabuilderfish);
    } else {
      if (Global.userAquariumType != aquabuilderfish.aquariumType ||
          Global.userAquariumType == "INCOMPATIBLE") {
        //Show warning
        //There are already fishes not compatible with current fish
        //Do you like to create your new aquarium and replace
        _addIncompatibleFish(cxt, aquabuilderfish);
      } else {
        //Fish in the tank matches with selected tank
        //Add fish to tank
        //Green Signal
        //Add fish to tank
        _addFish(cxt, aquabuilderfish);
      }
    }
  }

  void _addFish(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) async {
    ABAlertType abalerttype;

    bool isAdded = await addSuggestedAquabuildrFish(cxt, aquabuilderfish, 1);
    print("isAdded = " + isAdded.toString());

    if (isAdded) {
      // _reloadCompatibleFishesList();
//#now
      Global.userAquariumType = aquabuilderfish.aquariumType;

      //provider = Provider.of<NavigationProvider>(context, listen: false);
      provider.updateCounters(aquabuilderfish.tankQuantity);

      provider.tankSizeChanged();

      //provider.setcompatibleFishes(false);
      provider.updateFishesToLoadList("Compatible");
      // provider.updateCompatibilityFishesList(false);
      updateHeader("Compatible Fish");
      setState(() {});
      print("Calling update compatibiblity #########");

      print("proovider.complatiblefishe = " +
          provider.fishesToLoad.length.toString());

      bool isUpdated = await _starterAquariumItemListVM.updateUserAquariumType(
        Global.userAquariumType,
        Global.userAquariumLowerpHvalue,
        Global.userAquariumUpperpHvalue,
        Global.userAquariumLowerTemprValue,
        Global.userAquariumUpperTemprValue,
      );

      if (isUpdated) {}

      print("isUpdated = " + isUpdated.toString());
      if (_fishGenderAdded != FishGenderAdded.NOT_ADDED) {
        //navigate to details
        //Navigator.pop(context);
        // AppNavigator.navigateToStarterAquariumDetailPage(
        //     context,
        //     Global.userAquarium,
        //     aquabuilderfish,
        //     false,
        //     aquabuilderfish.aquariumType);//biknew
        return; //if both added / male added / female added return
      }

      if (isUpdated) {
        if (aquabuilderfish.gender == "") {
          //if (!_isPairs) {
          //Check if Tank of user is smaller than that of fish requirements

          //navigate to details and return
          // Navigator.pop(context);
          // AppNavigator.navigateToStarterAquariumDetailPage(
          //     context,
          //     Global.userAquarium,
          //     aquabuilderfish,
          //     false,
          //     aquabuilderfish.aquariumType);//biknew

          return;
        }

        //for betta fish only no pairing if male is already present
        if (_isMaleBettaPresent) {
          return;
        }

        abalerttype = ABAlertType.PAIRFISH;

        //Todo - PAIRING LOGIC
        String fishname = aquabuilderfish.species;
        String descTxt;
        String titleTxt;

        if (aquabuilderfish.gender == "male") {
          if (_isOnlyMale != 0) {
            //isOnlyMale

            titleTxt = "Add Fish?";

            if (!_isDash && _isPlus) {
              //3+(1male)
              descTxt =
                  "We recommend adding $fishname along with at least 2 female companion for optimal life span.\n\nWould you like to add it to your tank?";
            } else {
              descTxt =
                  "We recommend adding $fishname along with at least 1 female companion for optimal life span.\n\nWould you like to add it to your tank?";
            }
          } else {
            titleTxt = "Pair Fish?";

            descTxt =
                "We recommend pairing $fishname with its female companion for optimal life span. Would you like to add both to your tank?";
          }
        } else {
          if (_isOnlyMale != 0) {
            titleTxt = "Add Fish?";

            descTxt =
                "We recommend adding $fishname along with 1 male companion for optimal life span. Would you like to add both to your tank?";
          } else {
            titleTxt = "Pair Fish?";

            descTxt =
                "We recommend pairing $fishname with its male companion for optimal life span. Would you like to add both to your tank?";
          }
        }

        showDialog(
          context: context,
          builder: (context) => CustomDialog(
            title: titleTxt,
            description: descTxt,
            okButtonText: "YES",
            cancelButtonText: "NO",
            abAlertType: abalerttype,
            onOkBtnPressed: (isOkPressed, context) {
              if (isOkPressed) {
                print("OK PRESSED !");
                _addPairingFish(cxt, aquabuilderfish, 1);

                //addSuggestedPairingFish(cxt, suggestedfish)
                //bool isAdded = await addSuggestedAquabuildrFish(cxt, aquabuilderfish, 1);
              } else {
                print("Cancel PRESSED !");
                Navigator.pop(context);

                // AppNavigator.navigateToStarterAquariumDetailPage(
                //     context,
                //     Global.userAquarium,
                //     aquabuilderfish,
                //     false,
                //     aquabuilderfish.aquariumType);//biknew
              }
            },
          ),
        );
      } else {
        print("Aquarium type not updated !!");
      }
    } else {
      print("fish item not added !!");
    }
  }

  void _addFishToStarterAquarium(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) async {
    bool isAdded = await addSuggestedAquabuildrFish(cxt, aquabuilderfish, 1);
    print("isAdded = " + isAdded.toString());

    if (isAdded) {
      print("Fish added to aquarium");
      // _reloadCompatibleFishesList();

    }
  }

  void _addIncopatibleFishOnPressingYes(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) async {
    bool isAdded = await addSuggestedAquabuildrFish(cxt, aquabuilderfish, 0);
    if (isAdded) {
      //_reloadCompatibleFishesList();

      // AppNavigator.navigateToStarterAquariumDetailPage(
      //     context,
      //     Global.userAquarium,
      //     aquabuilderfish,
      //     false,
      //     aquabuilderfish.aquariumType);//biknew
    } else {
      print("couldn't add incompatible fish on add");
    }
  }

  void _addIncompatibleFish(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) async {
    ABAlertType abalerttype;

    abalerttype = ABAlertType.COMPATIBILITYWARNING;
    showDialog(
      useRootNavigator: true,
      context: context,
      builder: (context) => CustomDialog(
        title: "Compatibility Warning!",
        description:
            "The fish you have selected is not compatible with the fish you currently have in your tank.\n\nAre you sure you want to proceed?",
        okButtonText: "YES",
        cancelButtonText: "NO",
        abAlertType: abalerttype,
        onOkBtnPressed: (isOkPressed, context) {
          if (isOkPressed) {
            // {print("OK PRESSED !")}
            Global.userAquariumType = "INCOMPATIBLE";
            _starterAquariumItemListVM.updateUserAquariumType(
                "INCOMPATIBLE",
                aquabuilderfish.pHValueL,
                aquabuilderfish.pHValueU,
                aquabuilderfish.celsiusTemprL,
                aquabuilderfish.celsiumTemprU);

            Navigator.pop(cxt);

            _addIncopatibleFishOnPressingYes(cxt, aquabuilderfish);
            provider.updateFishesToLoadList("Compatible");
            setState(() {});
          } else {
            //print("Cancel PRESSED !")
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  void _addPairingFish(BuildContext cxt,
      AquabuildrFishViewModel aquabuilderfish, int iscompatible) async {
    //toggle gender to pair
    if (aquabuilderfish.gender == "male") {
      aquabuilderfish.gender = "female";
    } else {
      aquabuilderfish.gender = "male";
    }

    //set quantity to 1
    if (aquabuilderfish.gender == "male") {
      if (_isOnlyMale != 0) {
        aquabuilderfish.tankQuantity = 1;
        //aquabuilderfish.tankQuantity = _quantitySelected;

        if (_isPlus && !_isDash) {
          //3+(only 1 M)
          aquabuilderfish.tankQuantity = 1;
        }
      } else {
        if (_femaleRatio >= 1) {
          aquabuilderfish.tankQuantity =
              (aquabuilderfish.tankQuantity / 2).truncate();
          //aquabuilderfish.tankQuantity = _quantitySelected;
        }
      }
    } else {
      if (_isPlus && !_isDash && _femaleRatio == 0) {
        //3+(only 1 M)
        aquabuilderfish.tankQuantity = 2;
      }

      if (_femaleRatio >= 1) {
        aquabuilderfish.tankQuantity =
            aquabuilderfish.tankQuantity * _femaleRatio;
        //aquabuilderfish.tankQuantity = _quantitySelected;
      }
    }

    bool isAdded =
        await addSuggestedAquabuildrFish(cxt, aquabuilderfish, iscompatible);
    print("isAdded pairing fish = " + isAdded.toString());

    if (isAdded) {
      print("pairing fish also added");
      Navigator.pop(context);
      // AppNavigator.navigateToStarterAquariumDetailPage(
      //     context,
      //     Global.userAquarium,
      //     aquabuilderfish,
      //     false,
      //     aquabuilderfish.aquariumType);//biknew
    } else {
      print("couldn't added pairing fish");
      //Navigator.pop(context);
      // AppNavigator.navigateToStarterAquariumDetailPage(
      //     context,
      //     Global.userAquarium,
      //     aquabuilderfish,
      //     false,
      //     aquabuilderfish.aquariumType);//biknew
    }
  }

  Future<bool> addSuggestedAquabuildrFish(BuildContext cxt,
      AquabuildrFishViewModel availableFish, int iscompatible) async {
    //Global.isFishAdded = false;

    print("Adding fish!");
    print(availableFish.gender);
    print("test");

    _starterAquariumItemListVM.aquabuildrFishId = "VP7ZcCpmwXNdQOTcind4";
    _starterAquariumItemListVM.name = availableFish.species;
    _starterAquariumItemListVM.aquariumType = availableFish.aquariumType;
    _starterAquariumItemListVM.prefNoInTank =
        availableFish.preferredNoPerTankPred;

    _starterAquariumItemListVM.temprU = availableFish.celsiumTemprU;
    _starterAquariumItemListVM.temprL = availableFish.celsiusTemprL;

    _starterAquariumItemListVM.pHU = availableFish.pHValueU;
    _starterAquariumItemListVM.pHL = availableFish.pHValueL;

    _starterAquariumItemListVM.quantity = availableFish.tankQuantity;
    _starterAquariumItemListVM.isCompatible =
        iscompatible; //todo for other normal fish

    //print("availableFish(saving)>>>>>>>>> = " + availableFish.gender);
    _starterAquariumItemListVM.gender = availableFish.gender;
    _starterAquariumItemListVM.adultSize = availableFish.adultSize;
    _starterAquariumItemListVM.fishMinTankSize = availableFish.minimumTankSize;
    _starterAquariumItemListVM.price = availableFish.price;
    _starterAquariumItemListVM.photoURL = availableFish.photoURL;

    bool isSaved;
    if (isStarterAquarium) {
      _starterAquariumItemListVM.saveTankItem(true);
      return true;
    } else {
      isSaved = await _starterAquariumItemListVM.saveUserTankItem();
    }

    print("isSaved = " + isSaved.toString());

    provider.updateFishesToLoadList("Compatible");

    Global.isFishAddingInProgress = false;

    return isSaved;
  }

  Widget buildCompatibleFishesHeader(
      int compatiblefishescount,
      int freshwaterfishescount,
      String selectedHeaderTitle,
      Function onHeaderSelected) {
    ScrollController _scrollController = ScrollController();

    void scrollToIndex(selectedHeaderTitle) {
      onHeaderSelected(selectedHeaderTitle);

      double offsetS = _scrollController.initialScrollOffset;

      if (selectedHeaderTitle == "Compatible Fish") {
        offsetS = offsetS;
      } else if (selectedHeaderTitle == "Freshwater") {
        offsetS = offsetS + 130;
      } else if (selectedHeaderTitle == "Saltwater") {
        offsetS = offsetS + 280;
      } else if (selectedHeaderTitle == "Betta") {
        offsetS = offsetS + 420;
      } else if (selectedHeaderTitle == "Goldfish") {
        offsetS = offsetS + 580;
      } else if (selectedHeaderTitle == "All") {
        offsetS = _scrollController.position.maxScrollExtent;
      }

      _scrollController.animateTo(offsetS,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          buildCompatibleFishesHeaderList(
              "Compatible Fish",
              provider.compatibleFishes.length,
              selectedHeaderTitle,
              (seltitle) => {scrollToIndex(seltitle)}),
          buildCompatibleFishesHeaderList("Freshwater", freshwaterFishes.length,
              selectedHeaderTitle, (seltitle) => {scrollToIndex(seltitle)}),
          buildCompatibleFishesHeaderList("Saltwater", saltwaterFishes.length,
              selectedHeaderTitle, (seltitle) => {scrollToIndex(seltitle)}),
          buildCompatibleFishesHeaderList("Betta", bettaFishes.length,
              selectedHeaderTitle, (seltitle) => {scrollToIndex(seltitle)}),
          buildCompatibleFishesHeaderList("Goldfish", goldFishes.length,
              selectedHeaderTitle, (seltitle) => {scrollToIndex(seltitle)}),
          buildCompatibleFishesHeaderList("All", availablefishes.length,
              selectedHeaderTitle, (seltitle) => {scrollToIndex(seltitle)}),
        ],
      ),
    );
  }

  Widget buildCompatibleFishesHeaderList(String headerTitle, int fishescount,
      String selectedTitle, Function onHeaderSelected) {
    return GestureDetector(
      onTap: () => {onHeaderSelected(headerTitle)},
      child: Row(
        children: [
          SizedBox(
            width: 30,
          ),
          Text(
            headerTitle,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: headerTitle == selectedTitle
                    ? Colors.black87
                    : Colors.black26),
          ),
          Text(
            headerTitle == "All"
                ? " (" + fishescount.toString() + ")           "
                : "(" + fishescount.toString() + ")",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: headerTitle == selectedTitle
                  ? Colors.black45
                  : Colors.black12,
            ),
          ),
        ],
      ),
    );
  }
}
