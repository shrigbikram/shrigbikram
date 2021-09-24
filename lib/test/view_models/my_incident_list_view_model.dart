import 'package:aquabuildr/test/models/incident.dart';
import 'package:aquabuildr/test/view_models/incident_list_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyIncidentListViewModel {

  Future<List<IncidentViewModel>> getMyIncidents() async {

    final userId = FirebaseAuth.instance.currentUser.uid;
    print("fetched myincidents from firebase");

    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("incidents")
      .where ('userId',isEqualTo: userId)
      .orderBy('incidentDate',descending:true)
      .get();

    print("fetched myincidents");

    final incidents = snapshot.docs.map((doc) => Incident.fromDocument(doc)).toList();
    return incidents.map((incident) => IncidentViewModel(incident: incident)).toList();
    

  }
}