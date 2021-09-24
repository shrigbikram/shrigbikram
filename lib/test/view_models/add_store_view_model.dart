import 'package:aquabuildr/test/models/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddStoreViewModel extends ChangeNotifier {
  String storeName = "";
  String storeAddress = "";
  String message = "";

  Future<bool> saveStore() async {
    bool isSaved = false;
    final store = Store(storeName, storeAddress);

    // FirebaseFirestore.instance.collection("stores")
    // .add({
    //   "name":store.name,
    //   "address": store.address
    // });

    try {
      await FirebaseFirestore.instance.collection("stores").add(store.toMap());
      isSaved = true;
      message = "Store has been saved";
    } on Exception catch (_) {
      message = "Unable to save the store";
    } catch (error) {
      message = "Error occured!";
    }
    
    notifyListeners();
    
    return isSaved;
  }
}
