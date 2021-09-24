import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/Starter%20Aquariums/viewmodel/starter_aquarium_list_view_model.dart';
import 'package:aquabuildr/Starter%20Aquarium%20Detail/viewmodel/starter_aquarium_item_list_view_model.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/utils/navigation_provider.dart';
import 'package:aquabuildr/widgets/tank_expandable_view.dart';
import 'package:aquabuildr/utils/Global.dart';
import 'package:aquabuildr/widgets/aquabuildr_addtotank_fish_list.dart';
import 'package:aquabuildr/widgets/empty_or_no_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class StarterAquariumDetailPage extends StatefulWidget {
  final StarterAquariumViewModel starterAquarium;
  final AquabuildrFishViewModel aquabuilderFish;
  final bool isStarterAquarium;
  final String fishTypeInTank;

  const StarterAquariumDetailPage(
      {Key key,
      this.starterAquarium,
      this.aquabuilderFish,
      this.isStarterAquarium,
      this.fishTypeInTank})
      : super(key: key);

  _StarterAquariumDetailPageState createState() =>
      _StarterAquariumDetailPageState(
          starterAquarium: this.starterAquarium,
          aquabuilderFish: aquabuilderFish,
          isStarterAquarium: isStarterAquarium,
          fishTypeInTank: fishTypeInTank);
}

class _StarterAquariumDetailPageState extends State<StarterAquariumDetailPage> {
  final StarterAquariumViewModel starterAquarium;
  final AquabuildrFishViewModel aquabuilderFish;
  final bool isStarterAquarium;
  final String fishTypeInTank;

  StarterAquariumItemListViewModel _starterAquariumItemListVM;

  _StarterAquariumDetailPageState(
      {this.starterAquarium,
      this.aquabuilderFish,
      this.isStarterAquarium,
      this.fishTypeInTank}) {
    _starterAquariumItemListVM =
        StarterAquariumItemListViewModel(aquarium: starterAquarium);
  }

  int tankItemCount = 0;

  void updateTankItemsCount(int count) {
    //print("callback to update set state clalled");
    setState(() {
      tankItemCount += count;
    });
  }

  void getAquariumItemsCount() async {
    if (isStarterAquarium) {
      tankItemCount =
          await _starterAquariumItemListVM.getStarterAquariumItemsCount();
    } else {
      tankItemCount =
          await _starterAquariumItemListVM.getUserAquariumItemsCount();
    }

    final provider = Provider.of<NavigationProvider>(context, listen: false);
    provider.updateTankItemsCountN(tankItemCount);

    setState(() {
      tankItemCount = tankItemCount;
    });


    //called to update Global.fishcountintank in provicer
    //print("Calling get locigacl user aquarium items count");
    int totalfishesintank = await _starterAquariumItemListVM.getLogicalUserAquariumItemsCount();
    //print("totoal fishes in tank " + totalfishesintank.toString());
  }

  @override
  void initState() {
     if (isStarterAquarium) {
      //final provider = Provider.of<NavigationProvider>(context, listen: false);
     // NavigationProvider().toggleIsCollapsed();
      //provider.toggleIsCollapsed();
      //todo
    }
    super.initState();
    //print("STARTER AQUARIUM  >>>> " +
     //   this.isStarterAquarium.toString()); // toString());
    getAquariumItemsCount();
  }

    void getAquariumItems() async {
      String items;
    if (isStarterAquarium) {
      items =
          await _starterAquariumItemListVM.getStarterAquariumItems();
    } else {
      items =
          await _starterAquariumItemListVM.getUserAquariumItems();
    }



    final provider = Provider.of<NavigationProvider>(context, listen: false);
    provider.updateTankItemsCountN(tankItemCount);

    setState(() {
      tankItemCount = tankItemCount;
    });
  }

    

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => NavigationProvider(),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: PrimaryColorBlue,
            title: Text(
              !isStarterAquarium
                  ? "Tank Buildr"
                  : starterAquarium.aquariumName,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CachedNetworkImage(
                    //   imageUrl: starterAquarium.photoURL,
                    //   height: 250,
                    //   width: MediaQuery.of(context).size.width,
                    //   fit: BoxFit.fitWidth,
                    // ),
                    //SizedBox(height: 18),
                    Row(
                      children: [
                        Container(width: 90),
                        Container(
                          //color: Colors.red,
                          width: MediaQuery.of(context).size.width - 110 + 18,
                          height: MediaQuery.of(context).size.height - kToolbarHeight - 20,

                          child: Column(
                            children: [
                              Global.aquabuildrFishes.length > 0
                                  ? AquabuildrAddToTankFishList(
                                      availablefishes: Global.aquabuildrFishes,
                                      starterAquarium: this.starterAquarium,
                                      aquabuilderFish: this.aquabuilderFish,
                                      isStarterAquarium: this.isStarterAquarium,
                                      updateTankItem: this.updateTankItemsCount,
                                      fishTypeInTank: this.fishTypeInTank,
                                    )
                                  : EmptyOrNoItems(message: "No fishes found!"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              TankExpandableViewWidget(
                  this._starterAquariumItemListVM, starterAquarium, isStarterAquarium, () {
                print("tank item is deleted");

                // final provider =
                //       Provider.of<NavigationProvider>(context, listen: false);
                //   provider.updateCounters(0);
                //   print("calling from delete");
                //   provider.setcompatibleFishes(false);
              })
              //, this.updateTankItemsCount),
            ],
          ),
        ));
  }
}
