import 'package:aquabuildr/Add%20StarterAquarium/viewmodel/add_starteraquarium_view_model.dart';
import 'package:aquabuildr/Fish%20Home/search.dart';
import 'package:aquabuildr/Starter%20Aquariums/viewmodel/starter_aquarium_list_view_model.dart';
import 'package:aquabuildr/Starter%20Aquariums/model/starter_aquarium_view_state.dart';
import 'package:aquabuildr/utils/Global.dart';
import 'package:aquabuildr/utils/app_navigator.dart';
import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/widgets/aquabuildr_available_fish_list.dart';
import 'package:aquabuildr/widgets/empty_or_no_items.dart';
import 'package:aquabuildr/widgets/starter_aquariums_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:device_info_plus/device_info_plus.dart';

class AquabuildrFishHomePage extends StatefulWidget {
  @override
  _AquabuildrFishHomePage createState() => _AquabuildrFishHomePage();
}

class _AquabuildrFishHomePage extends State<AquabuildrFishHomePage> {
  AvailableAquabuildrFishListViewModel _availableAquabuildrFishListVM =
      AvailableAquabuildrFishListViewModel();

  StarterAquariumListViewModel _starterAquariumListVM =
      StarterAquariumListViewModel();

  bool _isSignedIn = true;

  @override
  void initState() {
    super.initState();
    _populateAllAquabuildrFishes();
    _populateAllStarterAquariums();

    //Global.isAdmin = false;
    print(">>>>>>> HOME INIT <<<<<<<<");
  }

  void _checkIfYouAreAdmin(String aqUserId) async {
    print("YOUR USER ID = " + aqUserId);
    _availableAquabuildrFishListVM.checkIfAdminUser(aqUserId);
  }

  void _populateAllAquabuildrFishes() async {
    _availableAquabuildrFishListVM.loadData(false);
  }

  void _populateAllStarterAquariums() async {
    _starterAquariumListVM.loadData(false);

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

    String userId = "devsimulator";
    if (iosInfo.isPhysicalDevice) {
      userId = iosInfo.identifierForVendor;
    }

    if (Global.userAquarium == null) {
      print("HOME >> APP STARTED ...");
      final userAquariums =
          await _starterAquariumListVM.getUserAquariums(userId);

      if (userAquariums.length == 0) {
        print("HOME >> No User Aquarium!! Creating...");

        AddStarterAquariumViewModel _addStarterAquariumViewModel =
            AddStarterAquariumViewModel();

        //todo
        final _starterAquariumVS = StarterAquariumViewState(
          aquariumName: "ANY",
          starterKitLabel: "",
          aquariumDesciption: "This is the user customized aquarium",
          aquariumSize: 1,
          photoURL: "",
          phValue: "",
          pHValueL: 0,
          pHValueU: 14,
          temperature: "",
          temprL: 0,
          temprU: 50,
        );

        final isSaved = await _addStarterAquariumViewModel.saveUserAquarium(
            _starterAquariumVS, userId);

        if (isSaved) {
          final userAquariums =
              await _starterAquariumListVM.getUserAquariums(userId);

          if (userAquariums.length != 0) {
            Global.aquabuildrUserId = userId;
            Global.userAquarium = userAquariums[0];
            Global.userAquariumType = Global.userAquarium.aquariumName;
            Global.userAquariumSize = Global.userAquarium.aquariumSize;

            Global.userAquariumId = userAquariums[0].aquariumId;

            Global.userAquariumLowerpHvalue = Global.userAquarium.pHValueL;
            Global.userAquariumUpperpHvalue = Global.userAquarium.pHValueU;

            Global.userAquariumLowerTemprValue = Global.userAquarium.temprL;
            Global.userAquariumUpperTemprValue = Global.userAquarium.temprU;

            print("HOME >> UserAquariumType(newly Created) = " +
                Global.userAquariumType);
          }
        }
      } else {
        Global.userAquariumId = userAquariums[0].aquariumId;

        Global.aquabuildrUserId = userId;
        Global.userAquarium = userAquariums[0];
        Global.userAquariumType =
            userAquariums[0].aquariumType; //Global.userAquarium.aquariumName;
        Global.userAquariumSize = Global.userAquarium.aquariumSize;

        Global.userAquariumLowerpHvalue = Global.userAquarium.pHValueL;
        Global.userAquariumUpperpHvalue = Global.userAquarium.pHValueU;

        Global.userAquariumLowerTemprValue = Global.userAquarium.temprL;
        Global.userAquariumUpperTemprValue = Global.userAquarium.temprU;

        print(
            "HOME >> UserAquariumType(existing) = " + Global.userAquariumType);
        // print("HOME >> GLOBAL.USERAQUARIUMSIZE = " +
        //     Global.userAquariumSize.toString());
      }

      _checkIfYouAreAdmin(Global.aquabuildrUserId);
    }
  }

  void _navigateToAddFishPage(BuildContext context, bool isFishUpdate,
      AquabuildrFishViewModel aquabuldrFish) async {
    final bool isAquabuildrFishAdded =
        await AppNavigator.navigateToAddAquabuildrFishPage(
            context, isFishUpdate, aquabuldrFish);

    if (isAquabuildrFishAdded != null) {
      if (isAquabuildrFishAdded) {
        _populateAllAquabuildrFishes();
      }
    }
  }

  void _navigateToAquabuildrFishesPage(BuildContext context) {
    AppNavigator.navigateToAquabuildrFishesPage(
        context, Global.aquabuildrFishes);
  }

  void _navigateToStarterAquariumsPage(
      BuildContext context, List<AquabuildrFishViewModel> aquabuildrFishes) {
    AppNavigator.navigateToStarterAquariumsPage(context, aquabuildrFishes);
  }

  void _navigateToMyAquarium(BuildContext context) async {
    AppNavigator.navigateToStarterAquariumDetailPage(
        context, Global.userAquarium, null, false, Global.userAquariumType);

/*
    String fishtypeintank = "BETTA";
    bool isTankCreated = true;
    //AppNavigator.navigateToStarterAquariumDetailPage(context, Global.userAquarium, null, true, fishtypeintank);
    print("## NAVIGATE TO MY AQUARIUM ## ");

    // print("## deviceId ## " + deviceId.toString());

    if (!isTankCreated) {
      //create tank
      AddStarterAquariumViewModel _addStarterAquariumViewModel =
          AddStarterAquariumViewModel();

      //save the aquabuildr to firestore database
      final _starterAquariumVS = StarterAquariumViewState(
        aquariumType: "USER",
        aquariumDesciption: "This is the user customized aquarium",
        photoURL: "",
      );
      final isSaved = await _addStarterAquariumViewModel.saveUserAquarium(
          _starterAquariumVS, "deviceid");

      if (isSaved) {
        //Navigator.pop(context, true);
        // get the myaquariuma ans pass to aquarium detail page

      }
    }else{
        AppNavigator.navigateToStarterAquariumDetailPage(context, Global.userAquarium, null, false, fishtypeintank);

    }

    */

    //My Aquarium
  }

  final cities = [
    "Kathmandu",
    "Pokhara",
    "Birgunj",
    "Gulmi",
    "Biratnagar",
    "Lalitpur",
    "Bhaktapur"
  ];

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

// AppBar(centerTitle: true, title: AppImages.logoSvg)

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AvailableAquabuildrFishListViewModel>(
        create: (context) => _availableAquabuildrFishListVM,
        child: Consumer<AvailableAquabuildrFishListViewModel>(
          builder: (context, availableAquabuildrFishListViewModel, child) =>
              Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: PrimaryColorBlue,//Colors.lightBlue,
              leading: IconButton(
                icon: Icon(Icons.menu, size: 30), // change this size and style
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
              ),
              title: ColorFiltered(
                child: Image.asset(
                  "assets/images/ab_logo-removebg-text.png",
                  width: 160,
                  height: 90,
                ),
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.search),
                    iconSize: 30,
                    padding: EdgeInsets.only(right: 10),
                    onPressed: () async {
                      print("search clicked");
                      setState(() {});
                      final result = await showSearch<AquabuildrFishViewModel>(
                          context: context,
                          delegate: DataSearch(Global.aquabuildrFishes));

                      if (result != null) {
                        print("Search result >>>> " + result.species);
                        AppNavigator.navigateToAquabuildrFishDetailPage(
                            context, result, Global.aquabuildrFishes, false);
                      }
                    })
              ],
            ),
            drawer: Drawer(
                child: Container(
              color: Colors.white,
              child: ListView(
                children: [
                  DrawerHeader(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: <Color>[
                        Colors.white,
                        Colors.white,
                        // Colors.lightBlue,
                        // Colors.lightBlue
                      ])),
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Material(
                                //borderRadius: BorderRadius.all(
                                //  Radius.circular(50.0)),
                                //elevation: 2,
                                child: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Image.asset(
                                "assets/images/app_bar_logo.png",
                                //width: 140,
                                height: 100,
                              ),
                            )),
                            // Padding(
                            //   padding: const EdgeInsets.all(12.0),
                            //   child: Text("aquabuildr",
                            //       style: TextStyle(
                            //           fontSize: 22,
                            //           color: Colors.white70)),
                            // ),
                          ],
                        ),
                      )),
                  CustomMenuListTile(Icons.home_outlined, 'Home', () {
                    Navigator.pop(context);
                    // _availableAquabuildrFishListVM.loadData(true);
                    // _starterAquariumListVM.loadData(true);

                    setState(() {
                      //a = Global.aquabuildrFishes;
                      _isSignedIn = true;
                    });
                    //_navigateToHomePage(context)
                  }),
                  CustomMenuListTile(Icons.add_box_outlined, 'My Tank', () {
                    Global.isStarterAq = false;
                    _navigateToMyAquarium(context);
                    // AppNavigator
                    //     .navigateToStarterAquariumDetailPage(
                    //         context, Global.userAquarium, null,true, )
                    //_navigateToMyIncidentsPage(context)
                  }),

                  //_isSignedIn
                  _availableAquabuildrFishListVM.isAdmin
                      ? CustomMenuListTile(Icons.waves_outlined, 'Add Fish',
                          () => {_navigateToAquabuildrFishesPage(context)})
                      : SizedBox(
                          height: 0,
                        ),
                  _availableAquabuildrFishListVM.isAdmin
                      ? CustomMenuListTile(
                          Icons.collections_bookmark_outlined,
                          'Add Aquariums',
                          () => {
                                _navigateToStarterAquariumsPage(
                                    context,
                                    availableAquabuildrFishListViewModel
                                        .availableAquabuildrFishes)
                              })
                      : SizedBox(
                          height: 0,
                        ),

                  CustomMenuListTile(
                      Icons.laptop_outlined,
                      'Elite builders',
                      () => {AppNavigator.navigateToEliteBuildersPage(context)}),

                  CustomMenuListTile(
                      Icons.feedback_sharp,
                      'Feedback',
                      () => {AppNavigator.navigateToFeedbackPage(context)}),

                  //CustomMenuListTile(Icons.settings_outlined, 'Settings', () => {}),
                  CustomMenuListTile(
                      Icons.privacy_tip_outlined,
                      'Aquarium Tips',
                      () => {AppNavigator.navigateToAquariumTipsPage(context)}),

                  CustomMenuListTile(Icons.description_outlined, 'About Us',
                      () => {AppNavigator.navigateToAboutUsPage(context)}),

                  Container(
                    margin: EdgeInsets.only(top: 250),
                    //color: Colors.white,
                    height: 100,
                    child: Text(
                      "aquabuildr\nv 1.0",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            )),
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _availableAquabuildrFishListVM.isShowUpperSection
                      ? Container(
                          //height: 70,
                          padding: EdgeInsets.only(left: 20, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // _availableAquabuildrFishListVM.isShowUpperSection ? "SHOW UPPER" : "HIDE UPPER",
                                "Available Fish",
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(height: 2),
                              Container(
                                width: MediaQuery.of(context).size.width -
                                    2 * Constants.kPadding,
                                child: Text(
                                  "(Pick any fish to start building your first aquarium)",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  _availableAquabuildrFishListVM.isShowUpperSection
                      ? _availableAquabuildrFishListVM
                                  .availableAquabuildrFishes.length >
                              0
                          ?
                          // AquabuildrAvailableFishList(
                          //     availableAquabuildrFishListViewModel
                          //         .availableAquabuildrFishes)
                          AquabuildrAvailableFishList(
                              availablefishes: _availableAquabuildrFishListVM
                                  .availableAquabuildrFishes,
                              isFromUpdateFish: false,
                              onAddToTankPressed: (istru) => {
                                    //AppNavigator.navigateToAquabuildrFishDetailPage(context,availableFish, availablefishes);
                                    print("on add to tank pressed")
                                  })
                          : EmptyOrNoItems(message: "Loading fishes... ")
                      : Container(),
                  Container(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Starter Aquariums",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 2),
                            Container(
                              width: MediaQuery.of(context).size.width -
                                  Constants.kPadding * 2 -
                                  36,
                              child: Text(
                                "(Choose your first aquarium from Aquabuildr)",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        !_availableAquabuildrFishListVM.isShowUpperSection
                            ? IconButton(
                                padding: EdgeInsets.only(right: 10),
                                onPressed: () {
                                  print("close");
                                  _availableAquabuildrFishListVM
                                      .updateShowUpperSection(true);
                                },
                                icon: Icon(Icons.cancel_outlined),
                                iconSize: 32,
                                color: PrimaryColorGreen,//Colors.grey.shade600,
                              )
                            : Container(
                                width: 0,
                              ),
                      ],
                    ),
                  ),
                  _starterAquariumListVM.starterAquariums.length > 0
                      ? Expanded(
                          child: Container(
                              //height: 380,
                              child: StarterAquariumsList(
                                  false,
                                  _starterAquariumListVM.starterAquariums,
                                  _availableAquabuildrFishListVM)),
                        )
                      : EmptyOrNoItems(
                          message: "Loading starter aquariums..."),
                ],
              ),
            ),
          ),
        ));
  }
}

class CustomMenuListTile extends StatelessWidget {
  IconData icon;
  String text;
  Function onTap;

  CustomMenuListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 8.0, 8.0, 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
        child: InkWell(
          splashColor: Colors.lightBlueAccent,
          onTap: onTap, //() => {},
          child: Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: PrimaryColorBlue,//Colors.blue,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 8.0, 0),
                      child: Text(
                        text,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_right,
                  color: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
