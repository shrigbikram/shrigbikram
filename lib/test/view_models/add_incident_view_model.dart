import 'dart:io';

//import 'package:aquabuildr/models/incident.dart';
import 'package:aquabuildr/test/models/incident.dart';
import 'package:aquabuildr/test/view_models/incident_view_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddIncidentViewModel extends ChangeNotifier {
  
  String message = "";

  //Not recommended since view will call this function 
  //and it should not know about model
  //so no in MVVM
  //can't use string name, string desp -> ideal function is function with 0 parameter
  //so we need view model which can capture values from view -> IncidentViewState
  
  /*
  Future<bool> saveIncident(Incident incident) async{
    return true;
  }
  */

  //Not using Incident model since it can have business logic and we don't want to expose
  Future<bool> saveIncident(IncidentViewState incidentVS) async{

    bool isSaved = false;
    final incident = Incident.fromIncidentViewState(incidentVS);

    try{
      FirebaseFirestore.instance.collection("incidents")
      .add(incident.toMap());
      isSaved = true;
    }catch(e){
      message = "Unable to save incident.";
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

    return downloadURL;
  }
  
}
