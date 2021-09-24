import 'package:aquabuildr/Starter%20Aquarium%20Detail/viewmodel/starter_aquarium_item_list_view_model.dart';
import 'package:aquabuildr/Starter%20Aquarium%20Detail/viewmodel/starter_aquarium_item_view_model.dart';
import 'package:aquabuildr/Starter%20Aquariums/viewmodel/starter_aquarium_list_view_model.dart';
import 'package:aquabuildr/utils/Global.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/utils/navigation_provider.dart';
import 'package:aquabuildr/utils/utils.dart';
import 'package:aquabuildr/widgets/custom_dialogue.dart';
import 'package:aquabuildr/widgets/custom_overlay_view.dart';
import 'package:aquabuildr/widgets/tank_items_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:provider/provider.dart';

class TankExpandableViewWidget extends StatelessWidget {
  final StarterAquariumItemListViewModel _starterAquariumItemListVM;
  final StarterAquariumViewModel starterAquarium;
  final bool isStarterAquarium;

  final Function onTankItemDeleted;

  TankExpandableViewWidget(this._starterAquariumItemListVM,
      this.starterAquarium, this.isStarterAquarium, this.onTankItemDeleted);

  final padding = EdgeInsets.symmetric(horizontal: 20);
  int tankitemcnt = 0;

  bool isKeyboard = false; // = MediaQuery.of(context).viewInsets.bottom != 0;

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    final provider = Provider.of<NavigationProvider>(context, listen: true);
    // final provider2 =
    //     Provider.of<StarterAquariumItemListViewModel>(context, listen: true);
    final isCollapsed = provider.isCollapsed;
    final tankItemCounterN = provider.tankItemsCountN;

    final sliderValue = provider.sliderValue;

    //final provider = Provider.of<NavigationProvider>(context, listen: true);
    final ischeckoutpressed = provider.isCheckoutPressed;

    Widget _buildStoreItems(bool isCollapsed) {
      print("isStarterAquarium = " + isStarterAquarium.toString());
      return StreamBuilder<QuerySnapshot>(
        stream: isStarterAquarium
            ? _starterAquariumItemListVM.tankItemsAsStream
            : _starterAquariumItemListVM.usertankItemsAsStream,
        builder: (context, snapshot) {

          print("Stream object lenght >>>>> " + snapshot.data.docs.length.toString());

          if (!snapshot.hasData) return Text("No items found!");

          snapshot.data.docs.forEach((doc){
            //print(doc.data().toString());
          });
          
           print("dsfsdf");
          final tankItems = snapshot.data.docs
              .map((item) => StarterAquariumItemViewModel.fromSnapshot(item))
              .toList();

              //  List<StarterAquariumItemViewModel> tankItems;
              //   snapshot.data.docs.forEach((item) {
              //     print("hell");
              //     tankItems.add(StarterAquariumItemViewModel.fromSnapshot(item));
              //     print(item.toString());
              //     });

              //.map((item) => StarterAquariumItemViewModel.fromSnapshot(item))
             // .toList();

          print("dsfsdf test");


          provider.updateAllFishesInTank(tankItems);
          provider.updateFishesToLoadList("Compatible");

          // tankItems.map((item) {
          //   //print(item.toString());
          // });

          print("come on");

          tankitemcnt = 0;

          bool iscompatible = true;
          String aquariumtyp = "ANY";

          int minTankSizeForFish = 0;

          Global.spaceUsedByCurrentFishesInTank = 0;

          tankItems.forEach((item) {
            if (item.isCompatible == 0) {
              iscompatible = false;
            } else {
              aquariumtyp = item.aquariumType;
            }

            tankitemcnt += item.quantity;

            if (item.fishMinTankSize > minTankSizeForFish) {
              minTankSizeForFish = item.fishMinTankSize;
            }
           // print("adultsize = " + item.adultSize.toString());
            Global.spaceUsedByCurrentFishesInTank += (item.adultSize * item.quantity);
           // print("adultsize after = " + item.adultSize.toString());

            Global.minTankSizeForFishInTank = minTankSizeForFish;
          });
          // print("Total items in tank = " + tankitemcnt.toString());

          print(">>>> spaceUsedByCurrentFishesInTank = " + Global.spaceUsedByCurrentFishesInTank.toString());

          if (!isStarterAquarium) {
            if (tankitemcnt == 0) {
              //updateAquariumType of UserAquarium to ANY
              _starterAquariumItemListVM.updateUserAquariumType(
                  "ANY", 6.0, 9.0, 15, 28); //TODO //todo
              Global.userAquariumType = "ANY";
              Global.userAquariumLowerpHvalue = 6;
              Global.userAquariumUpperpHvalue = 9;
              Global.userAquariumLowerTemprValue = 15;
              Global.userAquariumUpperTemprValue = 28;
              //Global.userAquariumSize = 2;

              Global.minTankSizeForFishInTank = 0;
            }

            if (!iscompatible) {
              _starterAquariumItemListVM.updateUserAquariumType(
                  "INCOMPATIBLE",
                  Global.userAquariumLowerpHvalue,
                  Global.userAquariumUpperpHvalue,
                  Global.userAquariumLowerTemprValue,
                  Global.userAquariumUpperTemprValue);
              Global.userAquariumType = "INCOMPATIBLE";
            } else {
              _starterAquariumItemListVM.updateUserAquariumType(
                  aquariumtyp,
                  Global.userAquariumLowerpHvalue,
                  Global.userAquariumUpperpHvalue,
                  Global.userAquariumLowerTemprValue,
                  Global.userAquariumUpperTemprValue);
              Global.userAquariumType = aquariumtyp;
            }
          }

          final provider2 =
              Provider.of<NavigationProvider>(context, listen: false);
          provider2.updateTankItemsCountN(tankitemcnt);

          //#now

          return TankItemsWidget(
              isCollapsed: isCollapsed,
              isCheckoutPressed: ischeckoutpressed,
              isStarterAquarium: isStarterAquarium,
              tankItems: tankItems,
              onTankItemDeleted: (tankItem) {
                //
                Future.delayed(const Duration(milliseconds: 500), () {
                  int count = 0;
                  //count = -tankItem.quantity;
                  final provider =
                      Provider.of<NavigationProvider>(context, listen: false);
                  provider.updateCounters(count);

                  print("calling from delete");
                  provider.updateFishesToLoadList("Compatible");

                  //provider.tankSizeChanged();

                  _starterAquariumItemListVM.getLogicalUserAquariumItemsCount();
                  provider.tankSizeChanged();

                  provider.updateIndexTop(Global.userAquariumSize);

                  //item deleted
                  print("Tank Item deleting.... ");

                  //print(tankItem.temprL);
                  //print(tankItem.temprU);
                  print("Deleted TankItem temprU = " +
                      tankItem.temprU.toString());
                  print("Deleted TankItem temprL = " +
                      tankItem.temprL.toString());

                  String deletedTankItemName = tankItem.name;

                  if (tankItems.length > 1) {
                    int j = 0;
                    double newTemprL;
                    double newTemprU;

                    double newpHL;
                    double newpHU;

                    List<StarterAquariumItemViewModel> revTankItems;
                    revTankItems = tankItems.reversed.toList();

                    for (StarterAquariumItemViewModel item in revTankItems) {
                      if (deletedTankItemName == item.name) {
                        print("1 continue");
                        continue;
                      }

                      if (j == 0) {
                        newTemprL = item.temprL;
                        newTemprU = item.temprU;

                        newpHL = item.pHL;
                        newpHU = item.pHU;
                      }

                      print("\nTankItem name = " + item.name);
                      print("TankItem temprU = " + item.temprU.toString());
                      print("TankItem temprL = " + item.temprL.toString());

                      if (item.temprL > newTemprL) {
                        newTemprL = item.temprL;
                      }

                      if (item.temprU < newTemprU) {
                        newTemprU = item.temprU;
                      }

                      if (item.pHL > newpHL) {
                        newpHL = item.pHL;
                      }

                      if (item.pHU < newpHU) {
                        newpHU = item.pHU;
                      }
                    }

                    Global.userAquariumUpperTemprValue = newTemprU;
                    Global.userAquariumLowerTemprValue = newTemprL;

                    Global.userAquariumUpperpHvalue = newpHU;
                    Global.userAquariumLowerpHvalue = newpHL;
                  } else {
                    Global.userAquariumUpperTemprValue = 40;
                    Global.userAquariumLowerTemprValue = 10;

                    Global.userAquariumUpperpHvalue = 14;
                    Global.userAquariumLowerpHvalue = 0;
                  }

                  this.onTankItemDeleted();

                  // provider.updateCompatibilityFishesList();
                });
                _starterAquariumItemListVM.deleteTankItem(
                    tankItem, isStarterAquarium);
              },
              onTankItemQtyAdded: (tankItem, isAdded) {
                int count = 0;
                if (isAdded) {
                  count += 1;
                  //Global.currentTankFishCount +=1;

                } else {
                  count -= 1;
                  //Global.currentTankFishCount -=1;

                }

                final provider =
                    Provider.of<NavigationProvider>(context, listen: false);
                provider.updateCounters(count);
                _starterAquariumItemListVM.updateTankQtyOfItem(
                    tankItem, isAdded, isStarterAquarium);
                _starterAquariumItemListVM.getLogicalUserAquariumItemsCount();
                provider.updateAddedFishesInTank(tankItem);
                provider.tankSizeChanged();
              });
        },
      );
    }

    isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      width: isCollapsed
          ? MediaQuery.of(context).size.width * 0.24
          : !isStarterAquarium
              ? ischeckoutpressed
                  ? MediaQuery.of(context).size.width * 1 //0.96
                  : MediaQuery.of(context).size.width * 1 //0.88
              : MediaQuery.of(context).size.width * 1,
      child: Column(
        children: [
          isCollapsed
              ? Column(
                  children: [
                    SizedBox(height: 24),
                    Text(
                      "Tank",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8),
                    Stack(
                      //alignment: Alignment.center,
                      children: [
                        Image.asset(
                          "assets/images/fishpot.png",
                          width: 70,
                          height: 70,
                        ),
                        Container(
                          alignment: Alignment.center,
                          //color: Colors.red,
                          width: 70,
                          height: 70,
                          child: Text(
                            //tankitemcnt.toString(),
                            tankItemCounterN.toString(),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: PrimaryColorBlue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )
              : Column(
                  children: [
                    //SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 16),
                            Text(
                              "My Tank",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              " (" + tankItemCounterN.toString() + ")",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black45),
                            ),
                          ],
                        ),
                        Global.isAdmin || !isStarterAquarium
                            ? InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: PrimaryColorGreen,//Colors.green,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.6),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: Offset(-1,
                                            2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  //color: Colors.green,
                                  width: 95,
                                  height: 75,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(!ischeckoutpressed ? "Close Tank" : "Checkout",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700)),
                                              SizedBox(height: 7,),
                                      ischeckoutpressed ?
                                      Icon(Icons.arrow_back_ios,
                                          color: Colors.white):
                                          Icon(Icons.close,
                                          color: Colors.white)
                                          ,
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  print("back pressed inside tank = " +
                                      ischeckoutpressed.toString());
                                  ischeckoutpressed
                                      ? provider.checkoutPressed()
                                      : provider.toggleIsCollapsed();
                                },
                              )
                            : Container(
                                height: 75,
                                color: Colors.red,
                              ),
                      ],
                    ),
                    /*
                    Container(
                      height: 100,
                      color: Colors.grey.shade100,
                      child: Slider(
                        value: sliderValue,
                        min: 30,
                        max: 120,
                        divisions: 3,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.blue.shade100,
                        label: sliderValue.round().toString(),
                        onChanged: (value) {
                          //final provider = Provider.of<NavigationProvider>(context, listen: true);
                          provider.updateSlider(value);
                        },
                      ),
                    ),*/

                    !provider.isKeyboard
                        ?
                        //HEERERERERER

                        ischeckoutpressed
                            ? SizedBox()
                            : Column(children: [
                                Container(
                                  color: Colors.grey.shade100,
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    // Container(
                                    //     margin: EdgeInsets.only(left: 16),
                                    //     //color: Colors.grey,
                                    //     child: Stack(
                                    //       children: [
                                    //         Text("Tank Size",
                                    //             style: TextStyle(
                                    //               fontSize: 16,
                                    //               fontWeight: FontWeight.w600,
                                    //             )),

                                    //       ],
                                    //     )),

                                    !isStarterAquarium
                                        ? Expanded(
                                            child: Container(
                                              color: Colors.grey.shade100,
                                              child: buildSlider(context),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                Container(
                                  color: Colors.grey.shade100,
                                  height: 10,
                                ),
                                Container(
                                  color: Colors.grey.shade100,
                                  child: Row(
                                    children: [
                                      Container(
                                        //color: Colors.red,
                                        width: 150,
                                        margin: EdgeInsets.only(left: 16),
                                        child: Text(
                                          "Tank Size",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Text(
                                                !isStarterAquarium
                                                    ? Utils.tankSizeInGallons()
                                                            .toString() +
                                                        " Gallons"
                                                    : starterAquarium
                                                            .aquariumSize
                                                            .toString() +
                                                        " Gallons",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            provider.isTankSizeCompatible
                                                ? Container(
                                                    height: 22,
                                                  )
                                                : IconButton(
                                                    //iconSize: 22,
                                                    color: Colors.blue,
                                                    onPressed: () {
                                                      print(
                                                          "Show Tank Size Warning !!");
                                                      _showSuggestionAlert(
                                                          context,
                                                          "Tank Size Warning!",
                                                          "Insufficient space for the fishes in your tank. Consider increasing tank size to remove this warning.",
                                                          "Ok",
                                                          "",
                                                          null);
                                                    },
                                                    icon: Icon(
                                                      Icons.warning_sharp,
                                                      color: Colors.redAccent,
                                                    ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.grey.shade100,
                                  height: 10,
                                ),
                                Container(
                                  color: Colors.grey.shade100,
                                  child: Row(
                                    children: [
                                      Container(
                                          //color: Colors.red,
                                          width: 150,
                                          margin: EdgeInsets.only(left: 16),
                                          child: Text("pH Value",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ))),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                            !isStarterAquarium
                                                ? Global.userAquariumLowerpHvalue
                                                        .toString() +
                                                    " - " +
                                                    Global
                                                        .userAquariumUpperpHvalue
                                                        .toString()
                                                : starterAquarium.phValue
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.grey.shade100,
                                  height: 10,
                                ),
                                Container(
                                  color: Colors.grey.shade100,
                                  child: Row(
                                    children: [
                                      Container(
                                          //color: Colors.red,
                                          width: 150,
                                          margin: EdgeInsets.only(left: 16),
                                          child: Text("Temperature",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ))),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Container(
                                          child: Text(
                                            !isStarterAquarium
                                                ? calculateTemp()
                                                : starterAquarium.temperature
                                                        .toString() +
                                                    "  °C/°F",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: Offset(0,
                                              2), // changes position of shadow
                                        ),
                                      ],
                                    ) //borderRadius: BorderRadius.all(Radius.circular(6))   )

                                    ),
                              ])
                        : Container()

                    //HEERERERERER

                    //Container(padding: EdgeInsets.only(top: 14), height: 84, color: Colors.grey.shade100,child: buildSliderTopLabel(context)),
                  ],
                ),
          Expanded(
            child: Container(
                width: isCollapsed
                    ? MediaQuery.of(context).size.width * 0.24
                    : MediaQuery.of(context).size.width * 1,
                child: _buildStoreItems(isCollapsed)),
          ),
          ischeckoutpressed
              ? buildTextInputFields(
                  context, isCollapsed, Global.fullname, Global.email)
              : SizedBox(
                  height: 0,
                ),
          buildCollapseIcon(context, isCollapsed),
        ],
      ),
    );
  }

  String calculateTemp() {
    String newTemp;


    if (Global.userAquariumLowerTemprValue == null) {
      return "";
    }

    newTemp = (Global.userAquariumLowerTemprValue * 2 + 30).floor().toString() +
        " - " +
        (Global.userAquariumUpperTemprValue * 2 + 30).floor().toString() +
        " °F" +
        "  /  " +
        Global.userAquariumLowerTemprValue.floor().toString() +
        " - " +
        Global.userAquariumUpperTemprValue.floor().toString() +
        " °C";

    return newTemp;
  }

  void _showSuggestionAlert(
      BuildContext cxt,
      String title,
      String desc,
      String okbtntxt,
      String cancelbtntxt,
      void Function(bool, BuildContext) onOkBtnPressed) {
    ABAlertType abalerttype;
    abalerttype = ABAlertType.COMPATIBILITYWARNING;
    showDialog(
      context: cxt,
      builder: (context) => CustomDialog(
        title: title,
        description: desc,
        okButtonText: okbtntxt,
        cancelButtonText: cancelbtntxt,
        abAlertType: abalerttype,
        onOkBtnPressed: (isOkPressed, context) {
          //onOkBtnPressed(isOkPressed, context);
          // if (isOkPressed) {
          Navigator.pop(cxt);
          // } else {
          //   Navigator.pop(cxt);
          //   //_addToTankPressed_After(cxt);
          //   _checkIfAddingFishNeedsTankUpdate(cxt);
          // }
        },
      ),
    );
  }

  Widget buildSlider(BuildContext context) => SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: PrimaryColorBlue,//Colors.blue[100],
        inactiveTrackColor: Colors.grey.shade400,//Colors.blue[100],
        trackShape: RoundedRectSliderTrackShape(),
        trackHeight: 4.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
        thumbColor: PrimaryColorBlue,//Colors.lightBlue,
        overlayColor: PrimaryColorBlue.withAlpha(32),//Colors.blue.withAlpha(32),
        // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
        tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 6),
        activeTickMarkColor: PrimaryColorBlue,//Colors.blue[100],
        inactiveTickMarkColor: Colors.grey.shade400,//Colors.blue[100],
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: Colors.redAccent,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [buildSliderTopLabel(context)],
      ));

  Widget buildSliderTopLabel(BuildContext context) {
    final labels = ['10', '20', '30', '50', '80', '120', '180'];
    //final labels = ['30', '50', '80', '120', '180'];

    final double min = 0;
    final double max = labels.length - 1.0;
    final divisions = labels.length - 1;

    final provider = Provider.of<NavigationProvider>(context, listen: true);

    return Column(children: [
      Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: Utils.modelBuilder(labels, (index, label) {
              final selectedColor = Colors.black;
              final unselectedColor = Colors.black.withOpacity(0.3);
              final isSelected = index == provider.indexTop;
              final color = isSelected ? selectedColor : unselectedColor;

              return buildLabel(label: label, color: color, width: 46); //54
            }) //[],
            ),
      ),
      Slider(
          //value: Global.userAquariumSize.toDouble(),//provider.indexTop.toDouble(),
          value: provider.indexTop.toDouble(),
          min: min,
          max: max,
          divisions: divisions,
          onChanged: (val) {
            Global.userAquariumSize = val.toInt();
            _starterAquariumItemListVM.updateUserAquariumSize(val.toInt());
            provider.updateIndexTop(val.toInt());
            provider.tankSizeChanged();
          })
    ]);
  }

  Widget buildLabel({
    @required String label,
    @required double width,
    @required Color color,
  }) =>
      Container(
        width: width,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: Colors.blue)
              .copyWith(color: color),
        ),
      );

  // Widget buildSideLabel(double value) => Container(
  //       width: 25,
  //       child: Text(
  //         value.round().toString(),
  //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //       ),
  //     );

  static final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailAddrsController = TextEditingController();

  Widget buildTextInputFields(
      BuildContext context, bool isCollapsed, String name, String email) {
    bool valuefirst = false;

    final provider = Provider.of<NavigationProvider>(context, listen: true);
    final isAgreeChecked = provider.isAgreeChecked;

    _fullNameController.text = Global.fullname;
    _emailAddrsController.text = Global.email;

    return Container(
      height: 220,
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Your Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 50,
                child: TextFormField(
                  onTap: () {
                    print("Name clicked");
                    provider.updateIsKeyboardShown(true);
                  },
                  onFieldSubmitted: (val) {
                    print("final val of name = " + val);
                    Global.fullname = val;
                    provider.updateIsKeyboardShown(false);
                  },
                  controller: _fullNameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Full name is required!";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Full Name",
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                child: TextFormField(
                  controller: _emailAddrsController,
                  onTap: () {
                    print("Email clicked");
                    provider.updateIsKeyboardShown(true);
                  },
                  onFieldSubmitted: (val) {
                    print("final val of email = " + val);
                    Global.email = val;
                    provider.updateIsKeyboardShown(false);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Email address is required!";
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return 'Please a valid Email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Email Address",
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  //Icon(Icons.check_box_outline_blank),
                  Checkbox(
                    checkColor: Colors.greenAccent,
                    activeColor: Colors.green,
                    value: isAgreeChecked,
                    onChanged: (bool value) {
                      valuefirst = value;
                      print(" value checkbox  => " + value.toString());

                      if (_fullNameController.text.length > 0) {
                        Global.fullname = _fullNameController.text;
                      }

                      if (_emailAddrsController.text.length > 0) {
                        Global.email = _emailAddrsController.text;
                      }

                      final provider = Provider.of<NavigationProvider>(context,
                          listen: false);
                      provider.toggleAgreeChecked();

                      // provider.toggleIsCollapsed();
                      // setState(() {
                      //   this.valuefirst = value;
                      // });
                    },
                  ),
                  SizedBox(width: 0),
                  Container(
                    width: MediaQuery.of(context).size.width - 98,
                    child: Text(
                        "Yes, I would like to recieve promotions and occasional emails from your company.",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                        textAlign: TextAlign.left),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
    final double size = 82; //92;
    final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    final margin = isCollapsed ? null : EdgeInsets.only(right: 0);
    final width =
        isCollapsed ? double.infinity : double.infinity; //270.0;//size;

    final provider = Provider.of<NavigationProvider>(context, listen: true);
    final ischeckoutpressed = provider.isCheckoutPressed;

    //final _formKey = GlobalKey<FormState>();

    final isKeyb = MediaQuery.of(context).viewInsets.bottom != 0;

    void _placeOrderButtonPressed() async {
      print("place order called");

      if (_formKey.currentState.validate()) {
        print("validation success !");

        print("Email = " + _emailAddrsController.text);
        print("name = " + _fullNameController.text);

        //final bool canSend = await canSendMail();

        // if (!canSend && Platform.isIOS) {
        //   final url = 'mailto:$recipient?body=$body&subject=$subject';
        //   if (await canLaunch(url)) {
        //     await launch(url);
        //   } else {
        //     throw 'Could not launch $url';
        //   }
        // }
        String name = _fullNameController.text;

        final boughtfisheslist =
            await _starterAquariumItemListVM.loadTankItems(isStarterAquarium);

        print(boughtfisheslist);

        String msgbody = "Dear $name,<br>" +
            "Thank you for using AquaBuildr for your compatibility needs. Please see your order confirmation below:<br>" +
            "$boughtfisheslist" +
            "<br><br>Sincerely," +
            "<br>The AquaBuildr Team/Your local pet store";

        print("formated msgbody = ");
        print(msgbody);

        final MailOptions mailOptions = MailOptions(
          body: msgbody,
          subject: 'Your Aquabuildr Order Placed',
          recipients: ["aquabuildr2021@gmail.com"],
          isHTML: true,
          //bccRecipients: ['aquabuildr2021@gmail.com'],
          ccRecipients: [Global.email],
          // attachments: [
          //   'path/to/image.png',
          // ],
        );

        print("boughtfisheslist = " + boughtfisheslist);

        MailerResponse response;
        try {
          response = await FlutterMailer.send(mailOptions);
        } catch (error) {
          showDialog(
              useRootNavigator: true,
              context: context,
              builder: (context) => CustomOverlayView(
                    title: "Error Sending Mail!",
                    description:
                        "Check if you got apple default mail app. If you got default mail app, please try later.",
                    okButtonText: "OK",
                    onOkBtnPressed: (isok, cxt) {
                      print("OK pressed");
                      Navigator.pop(cxt);
                    },
                  ));

          print("ERROR SENDING EMAIL = " + error.toString());
          return;
        }

        String platformResponse;
        // print("response while sending mail = " + response.toString());

        switch (response) {
          case MailerResponse.saved:

            /// ios only
            platformResponse = 'mail was saved to draft';
            print("mail was saved to draft");
            break;
          case MailerResponse.sent:

            /// ios only
            platformResponse = 'mail was sent';
            print("platformresponse = " + platformResponse);

            showDialog(
                useRootNavigator: true,
                context: context,
                builder: (context) => CustomOverlayView(
                      title: "Order Placed!",
                      description:
                          "Your order has been submitted for fulfillment. A copy of your order has been emailed to you for your records.\n\nTo ensure your order is completed in a timely manner, please verify with an aquarium associate that your request has been received and is being processed.\n\nThanks for using Aquabuildr.",
                      okButtonText: "OK",
                      onOkBtnPressed: (isok, cxt) {
                        print("OK pressed");
                        Navigator.pop(cxt);
                      },
                    ));
            break;
          case MailerResponse.cancelled:

            /// ios only
            platformResponse = 'mail was cancelled';
            print("mail was cancelled");
            break;
          case MailerResponse.android:
            platformResponse = 'intent was successful';

            break;
          default:
            platformResponse = 'unknown';
            print("error unknown");
            break;
        }
      } else {
        print("Error enter name /address");
        showDialog(
            useRootNavigator: true,
            context: context,
            builder: (context) => CustomOverlayView(
                  title: "Mail Failed!",
                  description: "Verify your email address or Try Again.",
                  okButtonText: "OK",
                  onOkBtnPressed: (isok, cxt) {
                    print("OK pressed");
                    Navigator.pop(cxt);
                  },
                ));
      }

      // final MailOptions mailOptions = MailOptions(
      //   body: 'a long body for the email <br> with a subset of HTML',
      //   subject: 'the Email Subject',
      //   recipients: ['example@example.com'],
      //   isHTML: true,
      //   bccRecipients: ['other@example.com'],
      //   ccRecipients: ['third@example.com'],
      //   // attachments: [
      //   //   'path/to/image.png',
      //   // ],
      // );
    }

    if (provider.isKeyboard) {
      print("iskeyboard");
      return Container();
    } else {
      print("no keyboard");
    }
    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: isCollapsed
            ? InkWell(
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.24,
                        height: 38,
                        //color: PrimaryColorGreen,//Colors.green,
                         decoration: BoxDecoration(
                                    color: PrimaryColorGreen,//Colors.green,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.6),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: Offset(-1,
                                            -1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                        child: Text(
                          "Open Tank",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              //decoration: TextDecoration.underline,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        )),
                    Container(
                      color: PrimaryColorGreen,//Colors.green, //bottom color
                      width: width,
                      height: size,
                      child: Icon(icon, size: 26, color: Colors.white),
                    ),
                  ],
                ),
                onTap: () {
                  final provider =
                      Provider.of<NavigationProvider>(context, listen: false);

                  provider.toggleIsCollapsed();
                },
              )
            : ischeckoutpressed
                ? InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 00),
                      //color: PrimaryColorGreen,//Colors.green.shade400,
                       decoration: BoxDecoration(
                                    color: PrimaryColorGreen,//Colors.green,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.6),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: Offset(-1,
                                            2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                      width: width,
                      height: size,
                      child: Center(
                        child: Text(
                          "Place Order",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      //Icon(icon, color: Colors.white),
                    ),
                    onTap: () {
                      print("Place Order Pressed!");
                      FocusScope.of(context).requestFocus(FocusNode());
                      _placeOrderButtonPressed();
                      // final provider =
                      //     Provider.of<NavigationProvider>(context, listen: false);
                      // provider.checkoutPressed();
                    },
                  )
                : InkWell(
                    child: Container(
                      //color: PrimaryColorGreen,//Colors.green,
                      width: width,
                      height: size,
 decoration: BoxDecoration(
                                    color: PrimaryColorGreen,//Colors.green,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.6),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: Offset(-1,
                                            -1), // changes position of shadow
                                      ),
                                    ],
                                  ),                      child: Center(
                        child: Text(
                          "Checkout",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      //Icon(icon, color: Colors.white),
                    ),
                    onTap: () {
                      print("Checkout Pressed!");
                      final provider = Provider.of<NavigationProvider>(context,
                          listen: false);
                      provider.checkoutPressed();
                    },
                  ),
      ),
    );
  }

  Widget buildHeader(bool isCollapsed) => isCollapsed
      ? FlutterLogo(size: 48)
      : Row(
          children: [
            const SizedBox(width: 24),
            FlutterLogo(size: 48),
            const SizedBox(width: 16),
            Text(
              'Flutter',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
          ],
        );
}
