import 'package:aquabuildr/test/models/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreViewModel{

  final Store store;
  StoreViewModel({this.store});

  //What properties we want to expose to view
  String get storeId{
    return store.storeId;
  }

  String get name{
    return store.name;
  }

  String get address{
    return store.address;
  }

  Future<int> get itemsCountAsync async{
    final data = await store.reference.collection("items").get();
    return data.docs.length;
  }

  factory StoreViewModel.fromSnapshot(QueryDocumentSnapshot doc){
    final store = Store.fromSnapshot(doc);
    return StoreViewModel(store: store);
  }


}