import 'package:aquabuildr/Starter%20Aquarium%20Detail/viewmodel/starter_aquarium_item_view_model.dart';
import 'package:aquabuildr/utils/Global.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/utils/firebase_helper.dart';
import 'package:aquabuildr/utils/navigation_provider.dart';
import 'package:aquabuildr/utils/utils.dart';
import 'package:aquabuildr/widgets/custom_dialogue.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TankItemsWidget extends StatelessWidget {
  final bool isCollapsed;
  final bool isCheckoutPressed;
  final bool isInCompatibleFish;

  final bool isStarterAquarium;

  final List<StarterAquariumItemViewModel> tankItems;
  final Function(StarterAquariumItemViewModel) onTankItemDeleted;
  final Function(StarterAquariumItemViewModel, bool) onTankItemQtyAdded;

  TankItemsWidget(
      {this.isCollapsed,
      this.isCheckoutPressed,
      this.isInCompatibleFish,
      this.isStarterAquarium,
      this.tankItems,
      this.onTankItemDeleted,
      this.onTankItemQtyAdded});

  Widget _buildItems(BuildContext context, int index) {
    final tankItem = tankItems[index];
    return Dismissible(
        key: Key(tankItem.tankItemId),
        onDismissed: (_) {
          onTankItemDeleted(tankItem);
        },
        background: Container(
          alignment: Alignment.center,
          color: Colors.red,
          child: Text(
            "Deleted",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ),
        child: Row(children: [
          isCheckoutPressed && !isStarterAquarium
              ? IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: () {
                    onTankItemDeleted(tankItem);
                  },
                )
              : SizedBox(
                  width: 0,
                ),
          Stack(
            alignment: Alignment.center,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                      //color: Colors.blue,
                      imageUrl: tankItem.photoURL,
                      height: 70,
                      width: 70,
                      fit: BoxFit.scaleDown),
                  isCollapsed
                      ? tankItem.gender == "male" || tankItem.gender == ""
                          ? Text("")
                          : Text(
                              "(female)",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade600),
                            )
                      : SizedBox(
                          width: 0,
                        ),
                ],
              ),
              tankItem.isCompatible == 0
                  ? Container(
                      alignment: Alignment.topRight,
                      width: MediaQuery.of(context).size.width * 0.22,
                      height: 80,
                      child: Icon(
                        Icons.warning_sharp,
                        color: Colors.redAccent,
                      ))
                  : Container(
                      alignment: Alignment.topRight,
                      width: MediaQuery.of(context).size.width * 0.22,
                      height: 80,
                      child: Container(
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(0.0),
                        decoration: BoxDecoration(
                            color: PrimaryColorBlue, shape: BoxShape.circle),
                        child: Text(
                          tankItem.quantity.toString(),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
            ],
          ),
          !isCollapsed
              ? Container(
                  //color: Colors.blue,
                  margin: EdgeInsets.only(left: 12),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width / 3 - 10, //120,
                  height: 100,
                  child: isCollapsed
                      ? Text(
                          tankItem.name,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                        )
                      : tankItem.gender == "male" || tankItem.gender == ""
                          ? Text(
                              tankItem.name,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            )
                          : Text.rich(TextSpan(children: [
                              TextSpan(
                                  text: tankItem.name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: " (female)",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black54))
                            ])),
                  /*
                  Text(tankItem.name + " (female)",

                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87),)
                        */
                )
              : Text(""),
          !isCollapsed
              ? SizedBox(
                  width: 0,
                )
              : Text(""),
          !isCollapsed
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    width: 20,
                  ),
                  !isStarterAquarium
                      ? GestureDetector(
                          onTap: () {
                            //
                            print("+ pressed in tank items");
                            // final provider = Provider.of<NavigationProvider>(context,
                            //     listen: false);
                            // provider.updateCounters(true);
                            checkIfTankItemCanBeAdded(context, tankItem, true);
                          },
                          child: Container(
                            child: Icon(
                              Icons.add,
                              color: PrimaryColorBlue,
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    tankItem.quantity.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  !isStarterAquarium
                      ? GestureDetector(
                          onTap: () {
                            print("- pressed");
                            if (tankItem.quantity > 1) {
                              // final provider = Provider.of<NavigationProvider>(
                              //     context,
                              //     listen: false);
                              // provider.updateCounters(false);
                              //onTankItemQtyAdded(tankItem, false);
                              checkIfTankItemCanBeAdded(
                                  context, tankItem, false);
                            } else {
                              print("show alert: to remove");
                              //show alert do you want to remove
                              _showSuggestionAlert(
                                  context,
                                  "Warning !",
                                  "Changing the quantity to 0 will remove this fish from this tank.\n\nAre you sure you want to remove?",
                                  "Yes",
                                  "No", (isOkPressed, context) {
                                if (isOkPressed) {
                                  //aquabuilderfish.tankQuantity = 2;
                                  //aquabuilderfish.tankQuantity = aquabuilderfish.tankQuantity;
                                  Navigator.pop(context);
                                  print(" <<< Yes pressed >>> ");
                                  onTankItemDeleted(tankItem);
                                  //_addFishToTank(context, aquabuilderfish);

                                  // _checkIfAddingFishNeedsTankUpdate(cxt, aquabuilderfish);
                                } else {
                                  Navigator.pop(context);
                                  print("No pressed");
                                }
                              });
                            }
                          },
                          child: Container(
                            child: Icon(
                              Icons.remove,
                              color: PrimaryColorBlue,
                            ),
                          ),
                        )
                      : Container(),
                ])
              : SizedBox(width: 0)
        ]));
  }

  //int _isOnlyMale = 0;
  //bool _isPairs = false;
  //int _femaleRatio;

  int TOTAL_FISHES_IN_CURRENT_TANK = 0;

  void checkIfTankItemCanBeAdded(BuildContext cxt,
      StarterAquariumItemViewModel tankItem, bool isAdd) async {
    //Total fishes in the current tank
    final provider = Provider.of<NavigationProvider>(cxt, listen: false);
    TOTAL_FISHES_IN_CURRENT_TANK = provider.tankItemsCountN;

    if (tankItem.aquariumType == "Goldfish") {
      //print("tank items count = " + provider.tankItemsCountN.toString());
      final provider = Provider.of<NavigationProvider>(cxt, listen: false);
      print(
          "++++ >>> tank items count = " + provider.tankItemsCountN.toString());

      int tankItemsCnt = provider.tankItemsCountN;
      int _tankSizeInGallons = Utils.tankSizeInGallons();

      int tanksizereq;
      if (isAdd) {
        tanksizereq = (1 + tankItemsCnt) * 20;
      } else {
        tanksizereq = (tankItemsCnt - 1) * 20;
      }

      int fishQty = tankItem.quantity;
      print("isAdd = " + isAdd.toString());

      if (_tankSizeInGallons >= tanksizereq) {
        print("Go Ahead!!");
        //okay add to tank
        //_addFishToTank(context, aquabuilderfish);
        if (isAdd) {
          onTankItemQtyAdded(tankItem, true);
        } else {
          onTankItemQtyAdded(tankItem, false);
        }
      } else {
        print("Noope!!");

        String goldfishmsg;
        if (tankItemsCnt > 0) {
          goldfishmsg = "more";
        } else {
          goldfishmsg = "";
        }

        // tanksizereq = tanksizereq - 1; //to show greater than

        //Ask user to increase tank size to add
        _showSuggestionAlert(
            cxt,
            "Aquabuildr Suggestion Tip",
            "Each goldfish requires minimum 20 gallons tank size.\n\nIncrease your tank size to $tanksizereq gallons or more to add 1 $goldfishmsg Goldfish.",
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
    } else if (tankItem.aquariumType == "Betta") {
      //print("tank items count = " + provider.tankItemsCountN.toString());
      final provider = Provider.of<NavigationProvider>(cxt, listen: false);
      print(
          "++++ >>> tank items count = " + provider.tankItemsCountN.toString());

      if (tankItem.gender == "male") {
        //show suggestion
        //Can't add or substract male count
        //only 1 is preferred
        _showSuggestionAlert(
            cxt,
            "Aquabuildr Suggestion Tip",
            "Only 1 Male Betta is preferred in the tank.",
            "OK",
            "", (isOkPressed, context) {
          if (isOkPressed) {
            Navigator.pop(cxt);
            //print(" <<< OK pressed >>> ");
          }
        });
      } else {
        int maxBettaFishesInThisCurrentTank = Utils.getMaxBettaFishInTank();
        int futureTankItemsCnt;
        if (isAdd) {
          futureTankItemsCnt = tankItem.quantity + 1;
          if (futureTankItemsCnt > maxBettaFishesInThisCurrentTank) {
            //show suggestion
            //Only bettacount is prefrred in tank

            _showSuggestionAlert(
                cxt,
                "Aquabuildr Suggestion Tip",
                "Only $maxBettaFishesInThisCurrentTank  Betta fishes are preferred in your current tank.\n\nTo add more fish increase your tank size or remove other fishes.",
                "OK",
                "", (isOkPressed, context) {
              if (isOkPressed) {
                Navigator.pop(cxt);
                //print(" <<< OK pressed >>> ");
              }
            });
          } else {
            onTankItemQtyAdded(tankItem, true);
          }
        } else {
          if (tankItem.quantity > 1) {
            futureTankItemsCnt = tankItem.quantity - 1;
            onTankItemQtyAdded(tankItem, false);
          }
        }
      }
      return;
    }

    print("\n\nGeneral fish -> + - pressed\n\n");

    if (isAdd) {
      int spaceOccupiedByFishInTank = Global.spaceUsedByCurrentFishesInTank;
      if (tankItem.adultSize + spaceOccupiedByFishInTank >
          Utils.tankSizeInGallons()) {
        //No space to add qty
        _showSuggestionAlert(
              cxt,
              "Aquabuildr Suggestion Tip",
              "Insufficient space, increase tank size to add more fish or remove other fishes.",
              "OK",
              "", (isOkPressed, context) {
            if (isOkPressed) {
              Navigator.pop(cxt);
            }
          });
        
      } else {
        // proceed
                  onTankItemQtyAdded(tankItem, true);

      }
    } else {
      onTankItemQtyAdded(tankItem, false);
    }

    return;

    String prefnointankpred = tankItem.prefNoInTank;
    List<String> result = prefnointankpred.split('#');
    int _prefNopertank;

    if (result[0].length != 0) {
      _prefNopertank = int.parse(result[0]);
    }

    bool _isDash = false;
    int _prefNopertankAppend;
    if (result[1] != "") {
      //- is present
      _isDash = true;
      _prefNopertankAppend = int.parse(result[2]);
    }

    bool _isPlus = false;
    if (result[3] != "") {
      //+ is present // you can have more than 2/3/4
      _isPlus = true;
    }

    int _isOnlyMale = 0;
    if (result[5] != "") {
      //warning -> only 1 Male
      _isOnlyMale = int.parse(result[5]);
    }

    bool _isPairs = false;
    if (result[4] != "") {
      //pairs so display M/F
      _isPairs = true;
    }

    bool _isEspecial = false;
    if (result[6] != "") {
      //this is especial // so display message in string - undisputedly
      _isEspecial = true;
    }

    String maleFemaleRatio;
    int _maleRatio;
    int _femaleRatio;
    if (result[7] != "") {
      maleFemaleRatio = result[7];

      List<String> resultratio = maleFemaleRatio.split(':');
      //print("male = " + resultratio[0]);
      //print("female = " + resultratio[1]);

      _maleRatio = int.parse(resultratio[0]);
      _femaleRatio = int.parse(resultratio[1]);

      //print("male ratio -> " + _maleRatio.toString());
      //print("female ratio -> " + _femaleRatio.toString());
    }

    int maxFishesInThisCurrentTank = Utils.getMaxFishInTank() * 6;

    int currentFishCountInTank =
        await FirebaseHelper.getLogicalUserAquariumItemsCount();
    print("## >> Current Fish Count In Tank = " +
        currentFishCountInTank.toString());

    int futureTankItemsCnt;
    if (isAdd) {
      futureTankItemsCnt = currentFishCountInTank + 1;
    } else {
      futureTankItemsCnt = currentFishCountInTank - 1;
    }

    String fishtoadd_name = tankItem.name;
    String is_areString = "is";
    if (_prefNopertank > 1) {
      is_areString = "are";
    }

    print("\n\nMax fishes in tank = " + maxFishesInThisCurrentTank.toString());
    print("futureTankItemsCnt = " + futureTankItemsCnt.toString());

    print("\n_isPairs = " + _isPairs.toString());
    print("_femaleRatio = " + _femaleRatio.toString());
    print("_isOnlyMale = " + _isOnlyMale.toString());

    //Only number is suggested
    if (!_isPlus && !_isDash && !_isEspecial) {
      print("Only number is suggested !");
      print("Preferred no. per tank for this fish = $_prefNopertank ");

      //if(futureTankItemsCnt > maxFishesInThisCurrentTank){
      if (futureTankItemsCnt > _prefNopertank) {
        //show suggestion that only this count is suggested in the tank

        _showSuggestionAlert(
            cxt,
            "Aquabuildr Suggestion Tip",
            "Only $_prefNopertank $fishtoadd_name $is_areString suggested in the tank. \n\nAquabuildr doesn't recommend adding more than $_prefNopertank $fishtoadd_name in the tank.",
            "OK",
            "", (isOkPressed, cxt) {
          if (isOkPressed) {
            //_quantitySelected = _prefNopertank;
            //aquabuilderfish.tankQuantity = _quantitySelected;
            Navigator.pop(cxt);
            //_checkIfAddingFishNeedsTankUpdate(context);
          } else {
            Navigator.pop(cxt);
          }
        });
      }

      return;
    }

    //Fish has some ratio like 1:2 or 1:4
    else if (_isPairs && _femaleRatio >= 1 && _isOnlyMale == 0 && !_isDash) {
      print("This fish has some ratio like 1:2 1:4 1:1");

      if (isAdd) {
        if (futureTankItemsCnt > maxFishesInThisCurrentTank) {
          _showSuggestionAlert(
              cxt,
              "Aquabuildr Suggestion Tip",
              "Insufficient space, increase tank size to add more fish or remove other fishes.",
              "OK",
              "", (isOkPressed, context) {
            if (isOkPressed) {
              Navigator.pop(cxt);
            }
          });
        } else {
          onTankItemQtyAdded(tankItem, true);
        }
      } else {
        onTankItemQtyAdded(tankItem, false);

        // int maxFish = 1;
        // if (tankItem.gender == "male") {
        // } else {
        //   maxFish = 2;
        // }
        // if (tankItem.quantity - 1 < maxFish) {
        //   //show alert to keep at least 6
        //   _showSuggestionAlert(
        //       cxt,
        //       "Aquabuildr Suggestion Tip",
        //       "$_prefNopertank + $fishtoadd_name are suggested in the tank with 1 male requiring $_femaleRatio females in the tank.",
        //       "OK",
        //       "", (isOkPressed, context) {
        //     if (isOkPressed) {
        //       Navigator.pop(cxt);
        //     }
        //   });
        // } else {
        //   //allow to substract
        //   onTankItemQtyAdded(tankItem, false);
        // }

      }

      return;
    } else if (_isPlus && !_isPairs) {
      //print("Preferred no. per tank for this fish = $_prefNopertank+ ");
      print("isplus but no pairs !");
      //int futurefishcnt = tankItem.quantity + 1;

      print("Future Tank Items Count = " + futureTankItemsCnt.toString());
      print("Max fishes in current tank = " +
          maxFishesInThisCurrentTank.toString());

      //int fishescountlogical = await FirebaseHelper.getLogicalUserAquariumItemsCount();

      //print("fishes count logica = " + fishescountlogical.toString());

      if (isAdd) {
        if (futureTankItemsCnt > maxFishesInThisCurrentTank) {
          _showSuggestionAlert(
              cxt,
              "Aquabuildr Suggestion Tip",
              "Insufficient space, increase tank size to add more fish or remove other fishes.",
              "OK",
              "", (isOkPressed, context) {
            if (isOkPressed) {
              Navigator.pop(cxt);
            }
          });
        } else {
          onTankItemQtyAdded(tankItem, true);
        }
      } else {
        if (tankItem.quantity - 1 < _prefNopertank) {
          //show alert to keep at least 6
          _showSuggestionAlert(
              cxt,
              "Aquabuildr Suggestion Tip",
              "$_prefNopertank + $fishtoadd_name are suggested in the tank.",
              "OK",
              "", (isOkPressed, context) {
            if (isOkPressed) {
              Navigator.pop(cxt);
            }
          });
        } else {
          //allow to substract
          onTankItemQtyAdded(tankItem, false);
        }
      }
      return;
    }

    //1-2 pairs
    else if (_isPairs && _isDash && !_isPlus && _isOnlyMale == 0) {
      //1-2 pairs

      print("ispairs - tank item list + -");

      int futurefishcnt = tankItem.quantity + 1;

      if (isAdd) {
        if (futureTankItemsCnt > maxFishesInThisCurrentTank) {
          _showSuggestionAlert(
              cxt,
              "Aquabuildr Suggestion Tip",
              "Insufficient space, increase tank size to add more fish or remove other fishes.",
              "OK",
              "", (isOkPressed, context) {
            if (isOkPressed) {
              Navigator.pop(cxt);
            }
          });
        } else {
          if (tankItem.quantity > 1) {
            //show suggestion ... can have 1-2 pairs for any gender
            _showSuggestionAlert(
                cxt,
                "Aquabuildr Suggestion Tip",
                "Only 1-2 pairs of $fishtoadd_name are preferred in the tank.",
                "OK",
                "", (isOkPressed, context) {
              if (isOkPressed) {
                Navigator.pop(cxt);
              }
            });
          } else {
            onTankItemQtyAdded(tankItem, true);
          }
        }
      } else {
        if (tankItem.quantity - 1 < _prefNopertank) {
          //show alert to keep at least 6
          _showSuggestionAlert(
              cxt,
              "Aquabuildr Suggestion Tip",
              "$_prefNopertank + $fishtoadd_name are suggested in the tank.",
              "OK",
              "", (isOkPressed, context) {
            if (isOkPressed) {
              Navigator.pop(cxt);
            }
          });
        } else {
          //allow to substract
          onTankItemQtyAdded(tankItem, false);
        }
      }

      return;
    }

    //1-2 pairs plus
    else if (_isPairs && _isDash && _isPlus) {
      //1-2 pairs plus

      print("ispairs PLUS - tank item list + -");

      int futurefishcnt = tankItem.quantity + 1;

      if (isAdd) {
        if (futureTankItemsCnt > maxFishesInThisCurrentTank) {
          _showSuggestionAlert(
              cxt,
              "Aquabuildr Suggestion Tip",
              "Insufficient space, increase tank size to add more fish or remove other fishes.",
              "OK",
              "", (isOkPressed, context) {
            if (isOkPressed) {
              Navigator.pop(cxt);
            }
          });
        } else {
          onTankItemQtyAdded(tankItem, true);
        }
      } else {
        if (tankItem.quantity - 1 < _prefNopertank) {
          //show alert to keep at least 6
          _showSuggestionAlert(
              cxt,
              "Aquabuildr Suggestion Tip",
              "$_prefNopertank + $fishtoadd_name are suggested in the tank.",
              "OK",
              "", (isOkPressed, context) {
            if (isOkPressed) {
              Navigator.pop(cxt);
            }
          });
        } else {
          //allow to substract
          onTankItemQtyAdded(tankItem, false);
        }
      }

      return;
    }

    //3+ (only 1 male)
    else if (_isOnlyMale != 0 && _isPlus && !_isDash) {
      print(">>>> $_prefNopertank + (only 1 male)");

      int futurefishcnt = tankItem.quantity + 1;

      print("maxFishesInThisCurrentTank = " +
          maxFishesInThisCurrentTank.toString());
      print("futurefishcnt = " + futurefishcnt.toString());

      if (isAdd) {
        futurefishcnt = TOTAL_FISHES_IN_CURRENT_TANK + 1;

        if (futurefishcnt > maxFishesInThisCurrentTank) {
          _showSuggestionAlert(
              cxt,
              "Aquabuildr Suggestion Tip",
              "Insufficient space, increase tank size to add more fish or remove other fishes.",
              "OK",
              "", (isOkPressed, context) {
            if (isOkPressed) {
              Navigator.pop(cxt);
            }
          });
        } else {
          int maxFish = maxFishesInThisCurrentTank;

          if (tankItem.gender == "male") {
            _showSuggestionAlert(
                cxt,
                "Aquabuildr Suggestion Tip",
                "For $fishtoadd_name only 1 male is preferred in the tank",
                "OK",
                "", (isOkPressed, context) {
              if (isOkPressed) {
                Navigator.pop(cxt);
              }
            });
          } else {
            onTankItemQtyAdded(tankItem, true);
          }
        }
      } else {
        //substract

        if (tankItem.gender == "female") {
          if (tankItem.quantity < 3) {
            //at least 2 are preferred
            _showSuggestionAlert(
                cxt,
                "Aquabuildr Suggestion Tip",
                "$_prefNopertank + $fishtoadd_name are suggested in the tank. So at least 2 females are preferred.",
                "OK",
                "", (isOkPressed, context) {
              if (isOkPressed) {
                Navigator.pop(cxt);
              }
            });
          } else {
            //allow to substract
            onTankItemQtyAdded(tankItem, false);
          }
        }
      }

      return;
    }

    //1-4(Only 1 Male)
    else if (_isDash && _isPairs && _isOnlyMale != 0) {
      print(">>>> 1-4 (Only 1 Male)  +++ ---");

      int futurefishcnt = tankItem.quantity + 1;

      print("maxFishesInThisCurrentTank = " +
          maxFishesInThisCurrentTank.toString());
      print("futurefishcnt = " + futurefishcnt.toString());

      if (isAdd) {
        futurefishcnt = TOTAL_FISHES_IN_CURRENT_TANK + 1;

        if (futurefishcnt > maxFishesInThisCurrentTank) {
          _showSuggestionAlert(
              cxt,
              "Aquabuildr Suggestion Tip",
              "Insufficient space, increase tank size to add more fish or remove other fishes.",
              "OK",
              "", (isOkPressed, context) {
            if (isOkPressed) {
              Navigator.pop(cxt);
            }
          });
        } else {
          int maxFish = maxFishesInThisCurrentTank;

          if (tankItem.gender == "male") {
            _showSuggestionAlert(
                cxt,
                "Aquabuildr Suggestion Tip",
                "For $fishtoadd_name only 1 male is preferred in the tank",
                "OK",
                "", (isOkPressed, context) {
              if (isOkPressed) {
                Navigator.pop(cxt);
              }
            });
          } else {
            if (tankItem.quantity < (_prefNopertankAppend - 1)) {
              onTankItemQtyAdded(tankItem, true);
            } else {
              _showSuggestionAlert(
                  cxt,
                  "Aquabuildr Suggestion Tip",
                  "$_prefNopertank - $_prefNopertankAppend $fishtoadd_name are preferred in the tank. So upto 3 females can be in the tank. ",
                  "OK",
                  "", (isOkPressed, context) {
                if (isOkPressed) {
                  Navigator.pop(cxt);
                }
              });
            }
          }
        }
      } else {
        //substract

        if (tankItem.gender == "female") {
          onTankItemQtyAdded(tankItem, false);
          // if (tankItem.quantity < 4) {
          //   //at least 2 are preferred
          //   _showSuggestionAlert(
          //       cxt,
          //       "Aquabuildr Suggestion Tip",
          //       "$_prefNopertank - $_prefNopertankAppend  $fishtoadd_name are suggested in the tank. So at least 3 females are preferred.",
          //       "OK",
          //       "", (isOkPressed, context) {
          //     if (isOkPressed) {
          //       Navigator.pop(cxt);
          //     }
          //   });
          // } else {
          //   //allow to substract
          //   onTankItemQtyAdded(tankItem, false);
          // }
        }
      }

      return;

      //
    }

    //1-2
    else if (_isDash && !_isPairs && !_isPlus && !_isEspecial) {
      print(">>>> hello bristlenose");

      int futurefishcnt = tankItem.quantity + 1;

      print("maxFishesInThisCurrentTank = " +
          maxFishesInThisCurrentTank.toString());
      print("futurefishcnt = " + futurefishcnt.toString());

      if (isAdd) {
        futurefishcnt = TOTAL_FISHES_IN_CURRENT_TANK + 1;

        if (futurefishcnt > maxFishesInThisCurrentTank) {
          _showSuggestionAlert(
              cxt,
              "Aquabuildr Suggestion Tip",
              "Insufficient space, increase tank size to add more fish or remove other fishes.",
              "OK",
              "", (isOkPressed, context) {
            if (isOkPressed) {
              Navigator.pop(cxt);
            }
          });
        } else {
          if (tankItem.quantity + 1 > 2) {
            //only 1-2 are preferred
            _showSuggestionAlert(
                cxt,
                "Aquabuildr Suggestion Tip",
                "Only 1 - 2 $fishtoadd_name are preferred in the tank.",
                "OK",
                "", (isOkPressed, context) {
              if (isOkPressed) {
                Navigator.pop(cxt);
              }
            });
          } else {
            onTankItemQtyAdded(tankItem, true);
          }
        }
      } else {
        //substract
        onTankItemQtyAdded(tankItem, false);
      }

      return;
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
      context: cxt,
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tankItems.length,
      itemBuilder: _buildItems,
    );
  }
}
