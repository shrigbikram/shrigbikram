import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/Starter%20Aquariums/viewmodel/starter_aquarium_list_view_model.dart';
import 'package:aquabuildr/utils/Global.dart';
import 'package:aquabuildr/utils/app_navigator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StarterAquariumsList extends StatelessWidget {
  bool isUpdateAquarium;
  List<StarterAquariumViewModel> starterAquariums;

  AvailableAquabuildrFishListViewModel _availableAquabuildrFishListVM;

  StarterAquariumsList(
      bool isUpdateAquarium,
      List<StarterAquariumViewModel> starterAquariums,
      AvailableAquabuildrFishListViewModel availableAquabuildrFishListVM) {
    this.starterAquariums = starterAquariums;
    this.isUpdateAquarium = isUpdateAquarium;
    this._availableAquabuildrFishListVM = availableAquabuildrFishListVM;
  }

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  ScrollController _scrollController;
  double _scrollPosition;

  _scrollListener() {
    //setState(() {
    _scrollPosition = _scrollController.position.pixels;
    //});
  }

  @override
  Widget build(BuildContext context) {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    return Container(
      // color: Colors.red,
      margin: EdgeInsets.only(top: 20),
      child: NotificationListener(
        onNotification: (t) {
          //print(t);

          if (_availableAquabuildrFishListVM != null) {
            if (t is ScrollStartNotification) {
              //hide the upper section
              print("Hide upper section");
              _availableAquabuildrFishListVM.updateShowUpperSection(false);
            }

           
            // if (t is ScrollEndNotification) {
            //   if (_scrollController.position.pixels == 0) {
            //     print("Show upper section");
            //     _availableAquabuildrFishListVM.updateShowUpperSection(true);
            //   }
            // }
          }

          return true;
        },
        child: ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: starterAquariums.length,
            itemBuilder: (context, index) {
              final starterAquarium = starterAquariums[index];

              return GestureDetector(
                onTap: () {
                  print("index tapped = " + index.toString());

                  //FishTypeInTank fishtypeintank = FishTypeInTank.Freshwater;
                  // String fishtypeintank = "Freshwater";
                  // if(starterAquarium.aquariumType == "Freshwater"){
                  //   fishtypeintank = "Freshwater";
                  // }
                  // else if(starterAquarium.aquariumType == "Saltwater"){
                  //   fishtypeintank = "Saltwater";
                  // }
                  // else if(starterAquarium.aquariumType == "Betta"){
                  //   fishtypeintank = FishTypeInTank.Betta;
                  // }

                  if (isUpdateAquarium) {
                    AppNavigator.navigateToAddStarterAquariumPage(
                        context, true, starterAquarium);
                  } else {
                    Global.isStarterAq = true;
                    AppNavigator.navigateToStarterAquariumDetailPage(
                        context,
                        starterAquarium,
                        null,
                        true,
                        starterAquarium.aquariumName);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 150,
                  margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                            imageUrl: starterAquarium.photoURL,
                            height: 150,
                            width: MediaQuery.of(context).size.width - 32,
                            fit: BoxFit.fitWidth),
                      ),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 30),
                          Text(
                            starterAquarium.aquariumName,
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                            child: Text(
                              starterAquarium.aquariumDesciption,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
