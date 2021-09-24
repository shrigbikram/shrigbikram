import 'package:aquabuildr/Starter%20Aquarium%20Detail/viewmodel/starter_aquarium_item_list_view_model.dart';
import 'package:aquabuildr/utils/Global.dart';
import 'package:aquabuildr/utils/app_navigator.dart';
import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/utils/utils.dart';
import 'package:aquabuildr/widgets/custom_dialogue.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AquabuildrFishDetailsPage extends StatefulWidget {
  final AquabuildrFishViewModel aquabuilderfish;
  final List<AquabuildrFishViewModel> aquabuilderFishes;
  final bool isDetailOnly;

  const AquabuildrFishDetailsPage(
      {Key key,
      this.aquabuilderfish,
      this.aquabuilderFishes,
      this.isDetailOnly})
      : super(key: key);

  _AquabuildrFishDetailsPageState createState() =>
      _AquabuildrFishDetailsPageState(
          aquabuilderfish: this.aquabuilderfish,
          aquabuilderFishes: this.aquabuilderFishes,
          isDetailOnly: this.isDetailOnly);
}

class _AquabuildrFishDetailsPageState extends State<AquabuildrFishDetailsPage> {
  final AquabuildrFishViewModel aquabuilderfish;
  final List<AquabuildrFishViewModel> aquabuilderFishes;
  final bool isDetailOnly;

  _AquabuildrFishDetailsPageState(
      {this.aquabuilderfish, this.aquabuilderFishes, this.isDetailOnly});

  StarterAquariumItemListViewModel _starterAquariumItemListVM;
  String fishTypeInTank;

  bool _isPairs = false;
  int _femaleRatio;

  bool _isDash = false;
  bool _isPlus = false;

  String fishTypeInTank_C;

  int _isOnlyMale = 0;
  int _tankSizeInGallons;
  String _preferredNoPerTankString;

  FishGenderAdded _fishGenderAdded;

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
            print("NO PRESSED !");
            Navigator.pop(context);
          }
        },
      ),
    );
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
          "Aquabuildr Suggestion Tip",
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
        } else {
          Navigator.pop(cxt);
          print("No pressed");
        }
      });
    } else {
      // _checkIfFishIsCompatibleWithCurrentTank(cxt, aquabuilderfish);
      _checkIfFishAlreadyExists(cxt, aquabuilderfish);
    }
  }

  //Start
  void _addToTankPressed(
      BuildContext cxt, AquabuildrFishViewModel availableFish) {
    //print("availableFish.gender = " + availableFish.gender);
    // if (isStarterAquarium) {
    //   _addFishToStarterAquarium(cxt, availableFish);
    // } else {
    print("ADD TO TANK PRESSED - DETAILS");
    print("Global.userAquariumType = " + Global.userAquariumType);
    if (Global.userAquariumType != "ANY") {
      if (Global.userAquariumType == "Betta") {
        if (availableFish.gender == "male") {
          _checkIfMaleBettaIsPresent(cxt, availableFish);
        } else {
          _checkIfFishAlreadyExists(cxt, availableFish);
        }
      }else{
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

    //}
  }

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
          "Aquabuildr Suggestion Tip",
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
          "Aquabuildr Suggestion Tip",
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
      int totalBettafishesintank = TOTAL_FISHES_IN_CURRENT_TANK;

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
            
            //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          } else {
            Navigator.pop(cxt);
          }
        });
      } else {
        _checkIfQtyAddedIsAcceptable(cxt, aquabuilderfish);
      }

      return;
    }

    // _checkIfQtyAddedIsAcceptable(cxt, aquabuilderfish);
    // return;

    int maxNoOfFish = Utils.getMaxFishInTank();
    int maxNoOfFish_smaller = maxNoOfFish * 6;

    int currentTankSize = Utils.tankSizeInGallons();
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
            //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          } else {
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
      int tankItemsCountN = TOTAL_FISHES_IN_CURRENT_TANK; //2; //todo provider.tankItemsCountN;

      if (tankItemsCountN < 2) {
        //show suggestion to add at least 2 Goldfish
        _showSuggestionAlert(
            cxt,
            "Aquabuildr Suggestion Tip",
            "2+ Goldfish are suggested in the tank. \n\nDo you want to change quantity to 2 and add ?",
            "YES",
            "NO", (isOkPressed, context) {
          if (isOkPressed) {
            aquabuilderfish.tankQuantity = 2;
            //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
            Navigator.pop(cxt);
            print(" <<< Yes pressed >>> ");
            _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          } else {
            Navigator.pop(cxt);
            print("No pressed");
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
              "Aquabuildr Suggestion Tip",
              "For Betta fish 1 Male and Upto 6 Females are preferred in the tank.\n\nDo you want to change quantity to 6 and add?",
              "YES",
              "NO", (isOkPressed, context) {
            if (isOkPressed) {
              //aquabuilderfish.tankQuantity = 7;
              //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
              Navigator.pop(cxt);
              //print(" <<< Yes pressed >>> ");
              //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            } else {
              Navigator.pop(cxt);
              print("No pressed");
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
              "Aquabuildr Suggestion Tip",
              "For Betta, only 1 Male is preferred in the tank.\n\nDo you want to change quantity to 1 and add?",
              "YES",
              "NO", (isOkPressed, context) {
            if (isOkPressed) {
              aquabuilderfish.tankQuantity = 1;
              //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
              Navigator.pop(cxt);
              //print(" <<< Yes pressed >>> ");
              _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            } else {
              Navigator.pop(cxt);
              print("No pressed");
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
    // print("_maleRatio : _femaleRatio = " +
    //     _maleRatio.toString() +
    //     ":" +
    //     _femaleRatio.toString());
    // print("gender = " + aquabuilderfish.gender);

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
            "Aquabuildr Suggestion Tip",
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

            //});

          } else {
            //Navigator.pop(cxt);
            //_addToTankPressed_After(cxt);
            //_checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
            print("No pressed");
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
          "Aquabuildr Suggestion Tip",
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
            "Aquabuildr Suggestion Tip",
            "$_prefNopertank + fish are suggested to add in the tank for this fish type. \n\nDo you want to change quantity to at least $_prefNopertank now ?",
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
            "Aquabuildr Suggestion Tip",
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
              "Aquabuildr Suggestion Tip",
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
              "Aquabuildr Suggestion Tip",
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
              "Aquabuildr Suggestion Tip",
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
              "Aquabuildr Suggestion Tip",
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
            "Aquabuildr Suggestion Tip",
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
      //print("tank items count = " + provider.tankItemsCountN.toString());

      int tankItemsCnt = TOTAL_FISHES_IN_CURRENT_TANK;//100; //todo bik //provider.tankItemsCountN;

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
            "Aquabuildr Suggestion Tip",
            "Each goldfish requires minimum 20 gallons tank size.\n\nIncrease your tank size to $tanksizereq gallons or more to add $fishQty $goldfishmsg Goldfish.",
            "OK",
            "", (isOkPressed, context) {
          if (isOkPressed) {
            //aquabuilderfish.tankQuantity = 2;
            //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
            Navigator.pop(cxt);
            print(" <<< Yes pressed >>> ");
            //_addFishToTank(context, aquabuilderfish);

            // _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          } else {
            Navigator.pop(cxt);
            print("No pressed");
          }
        });
      }

      return;
    }

    if (aquabuilderfish.aquariumType == "Betta") {
      //print("tank items count = " + provider.tankItemsCountN.toString());

      int tankItemsCnt = TOTAL_FISHES_IN_CURRENT_TANK;//100; //todo bik//provider.tankItemsCountN;

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
            "Aquabuildr Suggestion Tip",
            "Each Betta fish requires minimum 5 gallons tank size.\n\nIncrease your tank size to $tanksizereq to add $fishQty $goldfishmsg Betta fish.",
            "OK",
            "", (isOkPressed, context) {
          if (isOkPressed) {
            //aquabuilderfish.tankQuantity = 2;
            //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
            Navigator.pop(cxt);
            print(" <<< Yes pressed >>> ");
            //_addFishToTank(context, aquabuilderfish);

            // _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
          } else {
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

              // provider
              //     .updateIndexTop(Global.userAquariumSize); //to update slider

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
      /*bik
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
  */
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

        if(isDetailOnly){
            Navigator.pop(context);
        }else{

           AppNavigator.navigateToStarterAquariumDetailPage(
            context,
            Global.userAquarium,
            aquabuilderfish,
            false,
            aquabuilderfish.aquariumType); //biknew

        }
       



        return; //if both added / male added / female added return
      }

      if (isUpdated) {
        if (aquabuilderfish.gender == "") {
          //if (!_isPairs) {
          //Check if Tank of user is smaller than that of fish requirements

          //navigate to details and return
          // Navigator.pop(context);

          if(isDetailOnly){
            Navigator.pop(context);
        }else{
          AppNavigator.navigateToStarterAquariumDetailPage(
              context,
              Global.userAquarium,
              aquabuilderfish,
              false,
              aquabuilderfish.aquariumType); //biknew

        }

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

  void _addIncopatibleFishOnPressingYes(
      BuildContext cxt, AquabuildrFishViewModel aquabuilderfish) async {
    bool isAdded = await addSuggestedAquabuildrFish(cxt, aquabuilderfish, 0);
    if (isAdded) {
      //_reloadCompatibleFishesList();
if(isDetailOnly){
            Navigator.pop(context);
        }else{
      AppNavigator.navigateToStarterAquariumDetailPage(
          context,
          Global.userAquarium,
          aquabuilderfish,
          false,
          aquabuilderfish.aquariumType); //biknew

        }
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
            //bikprovider.updateFishesToLoadList("Compatible");
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

      if(isDetailOnly){
            Navigator.pop(context);
        }else{
      AppNavigator.navigateToStarterAquariumDetailPage(
          context,
          Global.userAquarium,
          aquabuilderfish,
          false,
          aquabuilderfish.aquariumType); //biknew

        }
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
    print("Adding fish!");
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

   // print("availableFish(saving)>>>>>>>>> = " + availableFish.gender);
    _starterAquariumItemListVM.gender = availableFish.gender;
    _starterAquariumItemListVM.adultSize = availableFish.adultSize;
    _starterAquariumItemListVM.fishMinTankSize = availableFish.minimumTankSize;
    _starterAquariumItemListVM.price = availableFish.price;
    _starterAquariumItemListVM.photoURL = availableFish.photoURL;

    bool isSaved;
    // if (isStarterAquarium) {
    //   _starterAquariumItemListVM.saveTankItem(true);
    //   return true;
    // } else {
    isSaved = await _starterAquariumItemListVM.saveUserTankItem();
    //}

    print("isSaved = " + isSaved.toString());

    return isSaved;
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
          //   Navigator.pop(cxt);
          // } else {
          //   Navigator.pop(cxt);
          //   //_addToTankPressed_After(cxt);
          //   _checkIfAddingFishNeedsTankUpdate(cxt);
          // }
        },
      ),
    );
  }

  int TOTAL_FISHES_IN_CURRENT_TANK = 0;
  void getCurrentFishesInTankCount() async {
      TOTAL_FISHES_IN_CURRENT_TANK = 
          await _starterAquariumItemListVM.getLogicalUserAquariumItemsCount();
  }

  @override
  void initState() {
    super.initState();


    aquabuilderfish.tankQuantity = 1;

    print(">>>>>>>>>>>> FISH DETAILS <<<<<<<<<<<<");
    print("aquabuildrfish.aquariumType = " + aquabuilderfish.aquariumType);
    print("UserAquariumType = " + Global.userAquariumType);

    _starterAquariumItemListVM =
        StarterAquariumItemListViewModel(aquarium: Global.userAquarium);
    // getCurrentFishesInTankCount();

    // if (Global.userAquariumSize == 0) {
    //   _tankSizeInGallons = 10;
    // } else if (Global.userAquariumSize == 1) {
    //   _tankSizeInGallons = 30;
    // } else if (Global.userAquariumSize == 2) {
    //   _tankSizeInGallons = 50;
    // } else if (Global.userAquariumSize == 3) {
    //   _tankSizeInGallons = 80;
    // } else if (Global.userAquariumSize == 4) {
    //   _tankSizeInGallons = 120;
    // } else if (Global.userAquariumSize == 5) {
    //   _tankSizeInGallons = 180;
    // } else {
    //   _tankSizeInGallons = 30;
    // }

    _tankSizeInGallons = Utils.tankSizeInGallons();
    print("Global.userAquariumSize ( ingallons ) = " +
        _tankSizeInGallons.toString());

    String prefnointankpred = aquabuilderfish.preferredNoPerTankPred;

    List<String> result = prefnointankpred.split('#');
    print("result = " + result.toString());

    if (result[4] != "") {
      //pairs so display M/F
      _isPairs = true; //result[4];
    }
    _preferredNoPerTankString = aquabuilderfish.preferredNoPerTankString;

    getCurrentFishesInTankCount();
  }

  final List<int> _qtyItemList = [1, 2, 3, 4, 5, 6];
  int _quantitySelected = 1;

  final List<String> _genderItemList = ["male", "female"];
  String _genderSelected = "male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: PrimaryColorBlue,
          title: Text(
            "Fish Details",
            style: TextStyle(
                fontSize: 21, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          actions: [
            Container(
              //color: Colors.red,
              //padding: const EdgeInsets.all(0.0),
              child: GestureDetector(
                child: Container(
                  //margin:EdgeInsets.only(top: 4),
                  padding: EdgeInsets.only(top: 6),
                  //color: Colors.green,
                  width: 120,
                  //height: 130,
                  child: Text(
                    isDetailOnly ? "" : "TANK\nBUILDR",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ), //Icon(Icons.check_box),
                onTap: () {
                  //_navigateToAddFishPage(context, false, null);
                  AppNavigator.navigateToStarterAquariumDetailPage(
                      context,
                      Global.userAquarium,
                      null,
                      false,
                      Global.userAquariumType);
                },
              ),
            )
          ]),
      body: Stack(
        children: [
          Container(
            height: isDetailOnly
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.height - (MediaQuery.of(context).padding.top + kToolbarHeight) - 80,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(

                    alignment: Alignment.center,
                    child: CachedNetworkImage(
                      imageUrl: aquabuilderfish.photoURL,
                      height: 280,
                      width: MediaQuery.of(context).size.width - 32,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          aquabuilderfish.aquariumType.toUpperCase(),
                          style: TextStyle(
                              fontSize: 18,
                              color: PrimaryColorBlue,//Colors.lightBlue,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8),
                        Text(
                          aquabuilderfish.species,
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.black87,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // isDetailOnly
                        //     ? Container()
                        //     : showDropDownPriceAndQuantity(context),
                            showDropDownPriceAndQuantity(context),
                        SizedBox(
                          height: 10,
                        ),
                        showDetailTile(
                          "",
                          aquabuilderfish.description,
                          // 'The Ocellaris Clownfish may be one of the aquarium industrys most popular marine fish.Its beautirufl orange body dressed with Can be kept with a variety of other captive-bred clownfish in black instatnsly distinguiesh the occelearis clownfish.',
                        ),
                        // showDetailTile(
                        //   "Environment: ",
                        //   'A hardy fish variety that lives best if in male/female paris. Can be kept with a variety of other captive-bred clownfish.',
                        // ),
                        SizedBox(height: 10),

                        showDetailTile(
                          "Minimum Tank Size: ",
                          aquabuilderfish.minimumTankSize.toString() +
                              " gallons",
                        ),

                        showDetailTile(
                          "Preffered No. in Tank: ",
                          aquabuilderfish.preferredNoPerTankString.toString(),
                        ),

                        showDetailTile(
                          "Preferred pH: ",
                          aquabuilderfish.pHValueL.toString() +
                              "-" +
                              aquabuilderfish.pHValueU.toString(),
                        ),

                        showDetailTile(
                          "Preferred Temperature: ",
                          aquabuilderfish.celsiusTemprL.toString() +
                              "-" +
                              aquabuilderfish.celsiumTemprU.toString() +
                              "°C / " +
                              aquabuilderfish.farenheitTemperature +
                              "°F",
                        ),

                        showDetailTile(
                          "Preffered Swim Depth: ",
                          aquabuilderfish.preferredSwimDepth.toString(),
                        ),

                        SizedBox(height: 20),

                        showDetailTile(
                          "Maturity Size: ",
                          aquabuilderfish.adultSize.toString() + " inches",
                        ),
                        showDetailTile(
                          "Average Lifespan: ",
                          aquabuilderfish.minimumTankSize.toString() +
                              " months",
                        ),
                        showDetailTile(
                          "Experience Level: ",
                          aquabuilderfish.aquariumType.toString(),
                        ),
                        showDetailTile(
                          "Activity: ",
                          aquabuilderfish.activityLevel.toString(),
                        ),
                        showDetailTile(
                          "Eating Characteristics: ",
                          aquabuilderfish.experienceLevel.toString(),
                        ),
                        SizedBox(height: 10),

                        isDetailOnly
                            ? SizedBox(
                                height: 20,
                              )
                            : SizedBox(
                                height: 20,
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          // isDetailOnly
          //     ? Container()
          //     :
              
               Container(
                  //color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //SizedBox(height: 20,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width, //- 32,
                        height: 80,
                        child: ElevatedButton(
                          onPressed: () {
                            //print("Add to tank pressed !");
                            //_addFishToUserAquarium(context);
                            _addToTankPressed(context, aquabuilderfish);
                          },
                          child: const Text('Add To Tank',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(
                            primary: PrimaryColorGreen,//Colors.green.shade400,
                            onPrimary: Colors.white,
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget showDropDownPriceAndQuantity(BuildContext cxt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              "Gender:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              width: 4,
            ),
            Container(
                alignment: Alignment.center,
                color: Colors.grey.shade200,
                width: 130,
                height: 44,
                child: _isPairs
                    ? DropdownButton(
                        hint: Text(
                          "Male",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        value: _genderSelected,
                        onChanged: (newValue) {
                          setState(() {
                            _genderSelected = newValue;
                          });
                        },
                        items: _genderItemList.map((gender) {
                          return DropdownMenuItem(
                            child: new Text(
                              gender,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            value: gender,
                          );
                        }).toList(),
                      )
                    : Text(
                        "NA",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      )),
          ],
        ),
        Row(
          children: [
            Text(
              "Qty:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              width: 4,
            ),
            Container(
              alignment: Alignment.center,
              color: Colors.grey.shade200,
              width: 90,
              height: 44,
              child: DropdownButton(
                hint: Text(
                  '1',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
                value: _quantitySelected,
                onChanged: (newValue) {
                  print("newValue = " + newValue.toString());
                  //print("aquabuilderfish.preferredNoPerTank = " + aquabuilderfish.preferredNoPerTank.toString());

                  //#biknow
                  // if(newValue > aquabuilderfish.preferredNoPerTank){
                  //   String fishname = aquabuilderfish.species;
                  //   String prefnointank = aquabuilderfish.preferredNoPerTank.toString();
                  //   //show Fish Advisory Warning
                  //   _showFishAdvisoryDismissAlert(cxt, "FISH ADVISORY", "It is suggested to keep $prefnointank $fishname in the tank for its optimal life.", "Ok", "", false);
                  // }

                  setState(() {
                    aquabuilderfish.tankQuantity = newValue;
                    _quantitySelected = newValue;
                  });
                },
                items: _qtyItemList.map((qty) {
                  return DropdownMenuItem(
                    child: new Text(
                      qty.toString(),
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    value: qty,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget showDetailTile(String title, String description) {
    return Column(
      children: [
        SizedBox(height: 5),
        Text.rich(TextSpan(children: [
          TextSpan(
              text: title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextSpan(
              text: description,
              style: TextStyle(fontSize: 14, color: Colors.black54))
        ])),
        SizedBox(height: 5),
      ],
    );
  }
}
