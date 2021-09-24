import 'dart:io';
import 'package:aquabuildr/Add%20Fish/model/aquabuildr_fish.dart';
import 'package:aquabuildr/Add%20Fish/model/aquabuildr_fish_view_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddAquabuildrFishViewModel extends ChangeNotifier {
  
  String message = "";

  Future<bool> saveAquabuildrFish(AquabuildrFishViewState aquabuildrFishVS) async{

    bool isSaved = false;
    final aquabuildrfish = AquabuildrFish.fromAquabuildrFishViewState(aquabuildrFishVS);

    try{
      FirebaseFirestore.instance.collection("aquabuildrfishes")
      .add(aquabuildrfish.toMap());
      isSaved = true;
    }catch(e){
      message = "Unable to save aquabuildrfish.";
    }
    notifyListeners();
    return true;
  }


  Future<bool> updateAquabuildrFish(AquabuildrFishViewState aquabuildrFishVS) async{

    print("updating fish data...");
    print("fish id = " + aquabuildrFishVS.reference.id);
    bool isUpdated = false;
    final aquabuildrfish = AquabuildrFish.fromAquabuildrFishViewState(aquabuildrFishVS);

    try{
      FirebaseFirestore.instance.collection("aquabuildrfishes")
      .doc(aquabuildrFishVS.reference.id).update(aquabuildrfish.toMap());
      //.add(aquabuildrfish.toMap());
      isUpdated = true;
    }catch(e){
      message = "Unable to update aquabuildrfish.";
    }
    print("fish updated !!");
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

    return downloadURL;
  }
  
}
