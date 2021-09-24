import 'package:aquabuildr/utils/Global.dart';
import 'package:flutter/material.dart';

class Utils {

  static bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
  }

  static List<Widget> modelBuilder<M>(
          List<M> models, Widget Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
  
  static int tankSizeInGallons() {
    int _tankSizeInGallons = 30;

    if (Global.userAquariumSize == 0) {
      _tankSizeInGallons = 10;
    } else if (Global.userAquariumSize == 1) {
      _tankSizeInGallons = 20;
    } else if (Global.userAquariumSize == 2) {
      _tankSizeInGallons = 30;
    } else if (Global.userAquariumSize == 3) {
      _tankSizeInGallons = 50;
    } else if (Global.userAquariumSize == 4) {
      _tankSizeInGallons = 80;
    } else if (Global.userAquariumSize == 5) {
      _tankSizeInGallons = 120;
    } else if (Global.userAquariumSize == 6) {
      _tankSizeInGallons = 180;
    } else {
      _tankSizeInGallons = 30;
    }
    return _tankSizeInGallons;
  }

  static int getNextTankSizeInGallons() {

    int currentaqsize = Global.userAquariumSize;
    int nextaqsize = currentaqsize + 1;

    int _tankSizeInGallons = 20;

    if (nextaqsize == 1) {
      _tankSizeInGallons = 20;
    } else if (nextaqsize == 2) {
      _tankSizeInGallons = 30;
    } else if (nextaqsize == 3) {
      _tankSizeInGallons = 50;
    } else if (nextaqsize == 4) {
      _tankSizeInGallons = 80;
    } else if (nextaqsize == 5) {
      _tankSizeInGallons = 120;
    } else if (nextaqsize == 6) {
      _tankSizeInGallons = 180;
    } else {
      _tankSizeInGallons = 200;
    }
    return _tankSizeInGallons;
  }


  //#maxfishintank
  static int getMaxFishInTank() {
    int maxNoOfFish = 0;

    if (Global.userAquariumSize == 0) {//10 gallon
      maxNoOfFish = 2;
    } else if (Global.userAquariumSize == 1) {//20 gallons
      maxNoOfFish = 6;
    } else if (Global.userAquariumSize == 2) {//30 gallons
      maxNoOfFish = 12;
    } else if (Global.userAquariumSize == 3) {//50 gallons
      maxNoOfFish = 20;
    } else if (Global.userAquariumSize == 4) {//80 gallons
      maxNoOfFish = 30;
    } else if (Global.userAquariumSize == 5) {//120 gallons
      maxNoOfFish = 40;
    } else if (Global.userAquariumSize == 6) {//180 gallons
      maxNoOfFish = 60;
    } 
    
    else {
      maxNoOfFish = 12;
    }
    return maxNoOfFish;
  }

  static int getMaxGoldFishInTank() {
    int maxNoOfGoldFish = 0;
   // print("Globa.userAquarijSize = " + Global.userAquariumSize.toString());

    if (Global.userAquariumSize == 0) {//10 gallon
      maxNoOfGoldFish = 0;
    } else if (Global.userAquariumSize == 1) {//20 gallons
      maxNoOfGoldFish = 1;
    } else if (Global.userAquariumSize == 2) {//30 gallons
      maxNoOfGoldFish = 1;
    } else if (Global.userAquariumSize == 3) {//50 gallons
      maxNoOfGoldFish = 2;
    } else if (Global.userAquariumSize == 4) {//80 gallons
      maxNoOfGoldFish = 4;
    } else if (Global.userAquariumSize == 5) {//120 gallons
      maxNoOfGoldFish = 6;
    } else if (Global.userAquariumSize == 6) {//180 gallons
      maxNoOfGoldFish = 9;
    } 
    
    else {
      maxNoOfGoldFish = 9;
    }
    return maxNoOfGoldFish;
  }

  static int getMaxBettaFishInTank() {
    int maxNoOfBettaFish = 0;
    //print("Globa.userAquarijSize = " + Global.userAquariumSize.toString());

    if (Global.userAquariumSize == 0) {//10 gallon
      maxNoOfBettaFish = 2;
    } else if (Global.userAquariumSize == 1) {//20 gallons
      maxNoOfBettaFish = 4;
    } else if (Global.userAquariumSize == 2) {//30 gallons
      maxNoOfBettaFish = 6;
    } else if (Global.userAquariumSize == 3) {//50 gallons
      maxNoOfBettaFish = 10;
    } else if (Global.userAquariumSize == 4) {//80 gallons
      maxNoOfBettaFish = 16;
    } else if (Global.userAquariumSize == 5) {//120 gallons
      maxNoOfBettaFish = 24;
    } else if (Global.userAquariumSize == 6) {//180 gallons
      maxNoOfBettaFish = 36;
    } 
    
    else {
      maxNoOfBettaFish = 36;
    }
    return maxNoOfBettaFish;
  }


  static int getuserAquariumSizeForFishMinTankSize(int fishMinimumTankSize) {
    int _userAquariumSize = 1;

    if (fishMinimumTankSize < 11) {
      _userAquariumSize = 0;
    } else if (fishMinimumTankSize > 10 && fishMinimumTankSize < 21) {
      _userAquariumSize = 1;
    } else if (fishMinimumTankSize > 20 && fishMinimumTankSize < 31) {
      _userAquariumSize = 2;
    } else if (fishMinimumTankSize > 30 && fishMinimumTankSize < 51) {
      _userAquariumSize = 3;
    } else if (fishMinimumTankSize > 50 && fishMinimumTankSize < 81) {
      _userAquariumSize = 4;
    } else if (fishMinimumTankSize > 80 && fishMinimumTankSize < 121) {
      _userAquariumSize = 5;
    } else if (fishMinimumTankSize > 120 && fishMinimumTankSize < 181) {
      _userAquariumSize = 6;
    } else {
      _userAquariumSize = 5;
    }

    return _userAquariumSize;
  }

  static int getTankSizeinGalllonsForFishMinTankSize(int fishMinimumTankSize) {
    int _tankSizeInGallons = 30;

    if (fishMinimumTankSize < 11) {
      _tankSizeInGallons = 10;
    } else if (fishMinimumTankSize > 10 && fishMinimumTankSize < 31) {
      _tankSizeInGallons = 30;
    } else if (fishMinimumTankSize > 30 && fishMinimumTankSize < 51) {
      _tankSizeInGallons = 50;
    } else if (fishMinimumTankSize > 50 && fishMinimumTankSize < 81) {
      _tankSizeInGallons = 80;
    } else if (fishMinimumTankSize > 80 && fishMinimumTankSize < 121) {
      _tankSizeInGallons = 120;
    } else if (fishMinimumTankSize > 120 && fishMinimumTankSize < 181) {
      _tankSizeInGallons = 180;
    } else {
      _tankSizeInGallons = 180;
    }

    return _tankSizeInGallons;
  }
}
