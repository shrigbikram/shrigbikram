
import 'package:aquabuildr/test/view_models/store_item_view_model.dart';
import 'package:flutter/material.dart';

class StoreItemsWidget extends StatelessWidget {

  final List<StoreItemViewModel> storeItems;
  final Function(StoreItemViewModel) onStoreItemDeleted;

  StoreItemsWidget({this.storeItems, this.onStoreItemDeleted});

  Widget _buildItems(BuildContext context, int index) {

    final storeItem = storeItems[index];
    return Dismissible(
      key: Key(storeItem.storeItemId),
      onDismissed: (_){
        onStoreItemDeleted(storeItem);
      },
      background: Container(color: Colors.red),
      child: ListTile(
        title:Text(storeItem.name)
      )
    );

    // return ListTile(
    //   title: Text(storeItem.name)
    // );
    // return Text("StoreItemsWidget");
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: storeItems.length,
      itemBuilder: _buildItems,
    );
    
  }
}