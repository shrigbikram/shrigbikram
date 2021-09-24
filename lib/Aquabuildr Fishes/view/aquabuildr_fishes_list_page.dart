import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/utils/app_navigator.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/widgets/aquabuildr_available_fish_list.dart';
import 'package:aquabuildr/widgets/empty_or_no_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AquabuildrFishesListPage extends StatefulWidget {
  final List<AquabuildrFishViewModel> aquabuildrFishes;

  const AquabuildrFishesListPage({Key key, this.aquabuildrFishes})
      : super(key: key);

  @override
  _AquabuildrFishesListPage createState() =>
      _AquabuildrFishesListPage(aquabuildrFishes: this.aquabuildrFishes);
}

class _AquabuildrFishesListPage extends State<AquabuildrFishesListPage> {
  List<AquabuildrFishViewModel> aquabuildrFishes;

  _AquabuildrFishesListPage({this.aquabuildrFishes});

  AvailableAquabuildrFishListViewModel _availableAquabuildrFishListVM =
      AvailableAquabuildrFishListViewModel();

  int selectedFishIndex = 0;

  @override
  void initState() {
    super.initState();
    _availableAquabuildrFishListVM.availableAquabuildrFishes =
        this.aquabuildrFishes;
  }
  

  void _navigateToAddFishPage(BuildContext context, bool isFishUpdate,
      AquabuildrFishViewModel aquabuildrFish, Function onFishChanged) async {
    final bool isFishAdded = await AppNavigator.navigateToAddAquabuildrFishPage(
        context, isFishUpdate, aquabuildrFish);

    if (isFishAdded != null) {
      if (isFishAdded) {
        //refresh new fish added/updated
        _availableAquabuildrFishListVM.loadData(true);

        setState(() {});
      }
    }
  }

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AvailableAquabuildrFishListViewModel>(
      create: (context) => _availableAquabuildrFishListVM,
      child: Consumer<AvailableAquabuildrFishListViewModel>(
        builder: (context, availableAquabuildrFishListViewModel, child) =>
            Scaffold(
              backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: PrimaryColorBlue,
            title: Text(
              "Aquabuildr Fishes",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Icon(Icons.add),
                  onTap: () {
                    _navigateToAddFishPage(context, false, null, () {
                      //update new fish added/updated
                    });
                  },
                ),
              )
            ],
          ),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _availableAquabuildrFishListVM
                            .availableAquabuildrFishes.length >
                        0
                    ? AquabuildrAvailableFishList(
                        availablefishes: _availableAquabuildrFishListVM
                            .availableAquabuildrFishes,
                        isFromUpdateFish: true,
                        onAddToTankPressed: (selectedIndex) {
                          print("on add to tank pressed editing ");
                          selectedFishIndex = selectedIndex;
                          print("fishid = " +
                              aquabuildrFishes[selectedFishIndex].fishId);
                          _navigateToAddFishPage(context, true,
                              aquabuildrFishes[selectedFishIndex], () {
                                
                              });
                          setState(() {});
                        })
                    : EmptyOrNoItems(message: "No fishes found!"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
