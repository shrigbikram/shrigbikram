import 'dart:io';
import 'package:aquabuildr/Add%20StarterAquarium/model/starter_aquarium.dart';
import 'package:aquabuildr/Starter%20Aquariums/model/starter_aquarium_view_state.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddStarterAquariumViewModel extends ChangeNotifier {
  
  String message = "";

  Future<bool> saveStarterAquarium(StarterAquariumViewState starterAquariumVS) async{

    bool isSaved = false;
    final starterAquarium = StarterAquarium.fromStarterAquariumViewState(starterAquariumVS);

    try{
      FirebaseFirestore.instance.collection(Constants.STARTERAQUARIUMSLIST_COLLECTION)
      .add(starterAquarium.toMap());
      isSaved = true;
    }catch(e){
      message = "Unable to save starter aquarium.";
    }
    notifyListeners();
    return true;
  }

  Future<bool> updateStarterAquarium(StarterAquariumViewState starterAquariumVS) async{
    print("update starter called ");


    print("starter aquarium id ( updating ) ... = " + starterAquariumVS.reference.id);


    bool isUpdated = false;
    final starterAquarium = StarterAquarium.fromStarterAquariumViewState(starterAquariumVS);

    try{
      FirebaseFirestore.instance.collection(Constants.STARTERAQUARIUMSLIST_COLLECTION)
      .doc(starterAquariumVS.reference.id)
      .update(starterAquarium.toMap());
      isUpdated = true;
    }catch(e){
      message = "Unable to save starter aquarium.";
    }
    notifyListeners();
    return true;
  }




  Future<bool> saveUserAquarium(StarterAquariumViewState starterAquariumVS,String deviceid) async{

    bool isSaved = false;
    final starterAquarium = StarterAquarium.fromStarterAquariumViewState(starterAquariumVS);

    try{
      FirebaseFirestore.instance.collection(Constants.USER_COLLECTION)
      .doc(deviceid)
      .collection(Constants.USER_AQUARIUM)
      .add(starterAquarium.toMap());
      isSaved = true;
    }catch(e){
      message = "Unable to save starter aquarium.";
    }
    notifyListeners();
    return true;
  }

  Future<String> uploadFile(File file) async {
    
    String downloadURL;
    
    final uuid = Uuid();
    final filePath = "/images/${uuid.v4()}.jpg";
    final storage = FirebaseStorage.instance.ref(filePath);
    final uploadTask = await storage.putFile(file);

    if(uploadTask.state == TaskState.success){
      downloadURL = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    }
    print("donwload url for stateraquar = " + downloadURL);
    return downloadURL;
  }
  
}
