import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/Starter%20Aquariums/viewmodel/starter_aquarium_list_view_model.dart';
import 'package:aquabuildr/utils/app_navigator.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/widgets/empty_or_no_items.dart';
import 'package:aquabuildr/widgets/starter_aquariums_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StarterAquariumsListPage extends StatefulWidget {
  final List<AquabuildrFishViewModel> aquabuildrFishes;

  const StarterAquariumsListPage({Key key, this.aquabuildrFishes})
      : super(key: key);

  @override
  _StarterAquariumsListPage createState() =>
      _StarterAquariumsListPage(aquabuildrFishes: this.aquabuildrFishes);
}

class _StarterAquariumsListPage extends State<StarterAquariumsListPage> {
  List<AquabuildrFishViewModel> aquabuildrFishes;

  AvailableAquabuildrFishListViewModel av;

  _StarterAquariumsListPage({this.aquabuildrFishes});

  StarterAquariumListViewModel _starterAquariumListVM =
      StarterAquariumListViewModel();
  List<StarterAquariumViewModel> _starterAquariums = [];

  @override
  void initState() {
    super.initState();
    _populateAllStarterAquariums();
  }

  void _populateAllStarterAquariums() async {

    _starterAquariumListVM.loadData(false);

   
  }

  void _navigateToAddStarterAquariumPage(BuildContext context) async {

    final bool isStarterAquariumAdded =
        await AppNavigator.navigateToAddStarterAquariumPage(context, false,null);

        print(">>>>>> STARTER AQUARIUM ( ADDED ) <<<<<<<<< = " + isStarterAquariumAdded.toString());

    if (isStarterAquariumAdded != null) {
      if (isStarterAquariumAdded) {
         _starterAquariumListVM.loadData(true);
         setState(() {});
      }
    }
  }

  

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StarterAquariumListViewModel>(
      create: (context) => _starterAquariumListVM,
      child: Consumer<StarterAquariumListViewModel>(
        builder: (context, starterAquariumListVM, child) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: PrimaryColorBlue,//Colors.lightBlue,
          // leading: IconButton(
          //   icon: Icon(Icons.menu, size: 30), // change this size and style
          //   onPressed: () => _scaffoldKey.currentState.openDrawer(),
          // ),
          title: Text(
            "Starter Aquariums",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Icon(Icons.add),
                onTap: () {
                  _navigateToAddStarterAquariumPage(context);
                },
              ),
            )
          ],
        ),
        body: starterAquariumListVM.starterAquariums.length > 0
            ? StarterAquariumsList(true,starterAquariumListVM.starterAquariums, av)
            : EmptyOrNoItems(message: "No Starter Aquariums Available!")),
        )
        );
  }
}
