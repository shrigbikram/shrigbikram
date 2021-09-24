import 'package:aquabuildr/test/models/incident.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class IncidentListViewModel{

  Future<List<IncidentViewModel>> getAllIncidents() async {
      
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("incidents")
      .orderBy("incidentDate", descending: true)
      .get();

      final incidents = snapshot.docs.map((doc) => Incident.fromDocument(doc)).toList();
      //we got models and we iterate to get view models
      return incidents.map((incident) => IncidentViewModel(incident: incident)).toList();

  }
}

class IncidentViewModel{

  final Incident incident;

  IncidentViewModel({this.incident});

  //expose properties
  String get title{
    return incident.title;
  }

  String get description{
    return incident.description;
  }

  String get photoURL{
    return incident.photoURL;
  }

  String get incidentDate{
    return DateFormat("MM-dd-yyyy HH:mm:ss").format(incident.incidentDate);
  }

}