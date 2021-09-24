import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/Starter%20Aquariums/viewmodel/starter_aquarium_list_view_model.dart';

class Global
{


  static List<AquabuildrFishViewModel> aquabuildrFishes = [];
  static List<StarterAquariumViewModel> starterAquariums = [];

  static StarterAquariumViewModel userAquarium;
  static String userAquariumType;

  static String selectedAquariumType;
  static bool isStarterAq;

  static bool isAdmin;

  static bool isFishAddingInProgress;

  static double userAquariumLowerpHvalue;
  static double userAquariumUpperpHvalue;

  static double userAquariumLowerTemprValue;
  static double userAquariumUpperTemprValue;

  static int userAquariumSize;
  static int spaceUsedByCurrentFishesInTank;

  static String userAquariumId;

  static String aquabuildrUserId;


  static String fullname;
  static String email;

  static int currentTankFishCount;

  static int minTankSizeForFishInTank = 0;


  static int totalFishInCurrentTank = 0;

}