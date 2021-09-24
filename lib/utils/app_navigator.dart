import 'package:aquabuildr/About%20Us/about_us.dart';
import 'package:aquabuildr/Add%20Fish/view/add_aquabuildr_fish_page.dart';
import 'package:aquabuildr/Add%20StarterAquarium/view/add_starteraquarium_page.dart';
import 'package:aquabuildr/Add%20StarterAquarium/viewmodel/add_starteraquarium_view_model.dart';
import 'package:aquabuildr/Aquabuildr%20Fishes/view/aquabuildr_fishes_list_page.dart';
import 'package:aquabuildr/Aquarium%20Tips/aquarium_tips.dart';
import 'package:aquabuildr/Elite%20builders/elite_builders.dart';
import 'package:aquabuildr/Feedback/feedback.dart';
import 'package:aquabuildr/Fish%20Home/aquabuildr_fish_home_page.dart';
import 'package:aquabuildr/Starter%20Aquariums/viewmodel/starter_aquarium_list_view_model.dart';
import 'package:aquabuildr/Starter%20Aquarium%20Detail/view/starter_aquarium_detail_page.dart';
import 'package:aquabuildr/Starter%20Aquariums/view/starter_aquariums_list_page.dart';
import 'package:aquabuildr/Starter%20Aquarium%20Detail/viewmodel/starter_aquarium_item_list_view_model.dart';
import 'package:aquabuildr/test/pages/add_incidents_page.dart';
import 'package:aquabuildr/Fish%20Detail/view/aquabuildr_fish_details_page.dart';
import 'package:aquabuildr/test/pages/login_page.dart';
import 'package:aquabuildr/test/pages/my_incidents_page.dart';
import 'package:aquabuildr/test/pages/register_page.dart';
import 'package:aquabuildr/Tank%20Builder/tank_builder_page.dart';
import 'package:aquabuildr/Add%20Fish/viewmodel/add_aquabuildr_fish_view_model.dart';
import 'package:aquabuildr/test/view_models/add_incident_view_model.dart';
import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/test/view_models/login_view_model.dart';
import 'package:aquabuildr/test/view_models/register_view_model.dart';
import 'package:aquabuildr/utils/Global.dart';
import 'package:aquabuildr/utils/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppNavigator {
  static Future<bool> navigateToAddAquabuildrFishPage(
      BuildContext context, bool isFishUpdate, AquabuildrFishViewModel aquabuildrFish) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => AddAquabuildrFishViewModel(),
                  child: AddAquabuildrFishPage(isFishUpdate: isFishUpdate, aquabuildrFish: aquabuildrFish,),
                ),
            fullscreenDialog: true));
  }

  static Future<bool> navigateToAddStarterAquariumPage(
      BuildContext context, bool isAquariumUpdate, StarterAquariumViewModel starterAquarium) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => AddStarterAquariumViewModel(),
                  child: AddStarterAquariumPage(isAquariumUpdate: isAquariumUpdate, starterAquarium: starterAquarium,),
                ),
            fullscreenDialog: true));
  }

  static void navigateToStarterAquariumsPage(
      BuildContext context, List<AquabuildrFishViewModel> aquabuildrFishes) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                StarterAquariumsListPage(aquabuildrFishes: aquabuildrFishes)));
  }


  static void navigateToAquabuildrFishesPage(
      BuildContext context, List<AquabuildrFishViewModel> aquabuildrFishes) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AquabuildrFishesListPage(aquabuildrFishes: aquabuildrFishes)));
  }



  static void navigateToAquabuildrFishDetailPage(
    BuildContext context,
    AquabuildrFishViewModel aquabuildrFish,
    List<AquabuildrFishViewModel> aquabuildrFishes,
    bool isDetailOnly
  ) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AquabuildrFishDetailsPage(
                  aquabuilderfish: aquabuildrFish,
                  aquabuilderFishes: aquabuildrFishes,
                  isDetailOnly: isDetailOnly,
                )));
  }

  static void navigateToStarterAquariumDetailPage(
    BuildContext context,
    StarterAquariumViewModel starterAquarium,
    AquabuildrFishViewModel aquabuildrFish,
    bool isStarterAquarium,
    String fishTypeInTank,
  ) {
    // print("App Navigator = " + aquabuildrFish.aquariumType);// toString());
    //print("App Navigator isStarterAquarium = " + isStarterAquarium.toString());

    if (!isStarterAquarium) {
      Global.isStarterAq = false;
      //if myaquarium is clicked
      //print("App Navigator aquabuildrFish.aquariumType = " + aquabuildrFish.aquariumType);
    } else {
      Global.isStarterAq = true;
      // print("App Navigator starterAquarium.aquariumType = " +
      //     starterAquarium.aquariumName);
    }
    //print("App Navigator fishTypeInTank= " + fishTypeInTank.toString());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<NavigationProvider>(
              create: (_) => NavigationProvider(),
            ),
            ChangeNotifierProvider<StarterAquariumItemListViewModel>(
              create: (_) => StarterAquariumItemListViewModel(),
            ),
          ],
          child: StarterAquariumDetailPage(
            starterAquarium: starterAquarium,
            aquabuilderFish: aquabuildrFish,
            isStarterAquarium: isStarterAquarium,
            fishTypeInTank: fishTypeInTank,
          ),
        ),
      ),
    );
  }

  static void navigateToEliteBuildersPage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EliteBuilders()));
  }

  static void navigateToFeedbackPage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AqFeedback()));
  }

  static void navigateToAquariumTipsPage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AquariumTips()));
  }

  static void navigateToAboutUsPage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AboutUs()));
  }

  static void navigateToBuildATankPage(
      BuildContext context,
      AquabuildrFishViewModel aquabuildrFish,
      List<AquabuildrFishViewModel> aquabuildrFishes) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TankBuilderPage(
                aquabuilderfish: aquabuildrFish,
                aquabuildrFishes: aquabuildrFishes)));
  }

  static void navigateToHomePage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AquabuildrFishHomePage()));
  }

  static void navigateToMyIncidentsPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyIncidentsPage()));
  }

  static Future<bool> navigateToAddIncidentsPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => AddIncidentViewModel(),
                  child: AddIncidentsPage(),
                ),
            fullscreenDialog: true));
  }

  static Future<bool> navigateToLoginPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => LoginViewModel(),
                  child: LoginPage(),
                ),
            fullscreenDialog: true));
  }

  static Future<bool> navigateToRegisterPage(BuildContext context) async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => RegisterViewModel(),
                  child: RegisterPage(),
                ),
            fullscreenDialog: true));
  }
}
