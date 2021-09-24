import 'package:aquabuildr/utils/app_navigator.dart';
import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AquabuildrAvailableFishList extends StatelessWidget {
  final List<AquabuildrFishViewModel> availablefishes;
  final bool isFromUpdateFish;

  final Function(int) onAddToTankPressed;

  AquabuildrAvailableFishList(
      {this.availablefishes, this.isFromUpdateFish, this.onAddToTankPressed});

  // AquabuildrAvailableFishList(
  //     availablefishes, ) {
  //   // this.availablefishes = availablefishes;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      margin: EdgeInsets.only(left: Constants.kPadding.toDouble()),
      width: MediaQuery.of(context).size.width -
                                    2 * Constants.kPadding,
      height: 300,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: availablefishes.length,
          itemBuilder: (context, index) {
            final availableFish = availablefishes[index];

            return GestureDetector(
              onTap: () {
                print("index tapped = " + index.toString());

                if (isFromUpdateFish) {
                  onAddToTankPressed(index);
                } else {
                  AppNavigator.navigateToAquabuildrFishDetailPage(
                      context, availableFish, availablefishes, false);
                }
              },
              child: Container(
                width: 150,
                //color: Colors.red,
                //height: 50,
                margin: EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CachedNetworkImage(
                        
                          imageUrl: availableFish.photoURL,
                          height: 200,
                          width: 150,
                          fit: BoxFit.scaleDown),
                    ),
                    Text(
                      availableFish.aquariumType,
                      style: TextStyle(
                          color: PrimaryColorBlue,//Colors.lightBlue,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 8),
                    Text(
                      availableFish.species,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
