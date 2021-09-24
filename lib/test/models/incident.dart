//model class
//this model class can contain some other logic like business rules
//but we don't have any
//we can't treat this model as DTO data transfer object

import 'package:aquabuildr/test/view_models/incident_view_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Incident {
  final String userId;
  final String title;
  final String description;
  final String photoURL;
  final DateTime incidentDate;

  Incident(
      {this.userId,
      this.title,
      this.description,
      this.photoURL,
      this.incidentDate});

  //to update to firebase we need to suppy dictionary
  //converting object to map/dictionary
  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "title": title,
      "description": description,
      "photoURL": photoURL,
      "incidentDate": incidentDate
    };
  }

  //convert dictionary to object
  factory Incident.fromDocument(QueryDocumentSnapshot doc) {
    return Incident(
      title: doc["title"],
      description: doc["description"],
      photoURL: doc["photoURL"],
      userId: doc["userId"],
      incidentDate: doc["incidentDate"].toDate()
    );
  }

  factory Incident.fromIncidentViewState(IncidentViewState vs){
    return Incident(
      title : vs.title,
      description:vs.description,
      photoURL: vs.photoURL,
      userId: vs.userId,
      incidentDate: vs.incidentDate
    );
  }

}
