import 'package:flutter/material.dart';

 //const PrimaryColorBlue =  Color.fromARGB(255, 31, 191, 220);
 const PrimaryColorBlue =  Color.fromARGB(255, 28, 188, 220);

 //const PrimaryColorGreen =  Color.fromARGB(255, 37, 233, 178);
  const PrimaryColorGreen =  Color.fromARGB(255, 35, 219, 180);

 const PrimaryDarkColor =  Color(0xFF808080);
 const ErroColor =  Color(0xFF808080);


class Constants {
  static String AQUABUILDRFISHES = "aquabuildrfishes";
  static String STARTERAQUARIUMSLIST_COLLECTION = "starteraquariums";
  static String USER_COLLECTION = "users";
  static String USER_AQUARIUM = "useraquarium";

  static String NO_STORES_FOUND = "No stores found!";

  static String REGISTER_PAGE_HERO_IMAGE = "assets/images/city_care.jpg";
  static String LOGIN_PAGE_HERO_IMAGE =
      "assets/images/login_page_hero_image.jpg";

  static String WEAK_PASSWORD = "Password is weak";
  static String EMAIL_ALREADY_IN_USE = "Email is already in use";


  static String SUGGESTION_TIP_TITLE = "Aquabuildr Suggestion Tip";
  

  static int kPadding = 16;
}

enum FishGenderAdded { NOT_ADDED, MALE_ADDED, FEMALE_ADDED, BOTH_ADDED }

enum FishTypeInTank {
  Freshwater,
  Saltwater,
  Betta,
  Goldfish,
  All,
  CompatibleFish,
}


enum ABAlertType { PAIRFISH, COMPATIBILITYWARNING, FISHADVISORY, DISMISSALERT }

enum DropDownType {
  AQUARIUM_TYPE,
  PREF_NO_IN_TANK,
  ACTIVITY_LEVEL,
  PREF_SWIM_DEPTH,
  TEMPERAMENT,
  CYCLER_SPECIES,
}

List<String> aquariumTypeList = [
  "Freshwater",
  "Saltwater",
  "Betta",
  "Goldfish"
];

List<String> activityLevelList = ["High", "Moderate", "Low", "Diurnal", "NA"];

List<String> prefSwimDepthList = [
  "Top",
  "Top-Mid",
  "Mid",
  "Mid-Bottom",
  "Bottom",
  "All",
  "NA"
];

List<String> temperamentList = ["Aggressive", "Semi-Aggressive", "Not Aggressive", "Peaceful", "NA"];

List<String> cyclerList = ["Yes", "No", "NA"];

List<String> prefNoInTankList = [
  "1",//0
  "1+",//1
  "2+",//2

  "2+ (1M, 1F)",//3
  "3+ (1M)",//4
  "1-4 (1M)",//5

  "1 or mated pair",//6
  "6+",//7
  "1M,1-6F",//8

  "8+",//9
  "10+",//10
  "1-2 Pairs(M/F)",//11

  "1-2+ Pairs(M/F)",//12
  "6+(1M-2F)",//13
  "1-2", //14

];

List<String> temprHatchLabelList = ['10', '16', '22', '28', '34', '40'];

double temprMin = 10;
double temprMax = 40;

List<String> phHatchLabelList = ['4', '6', '8', '10', '12', '14'];

double phMin = 4;
double phMax = 14;
