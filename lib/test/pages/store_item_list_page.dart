
import 'package:aquabuildr/test/models/store_item.dart';
import 'package:aquabuildr/test/view_models/store_item_list_view_model.dart';
import 'package:aquabuildr/test/view_models/store_item_view_model.dart';
import 'package:aquabuildr/test/view_models/store_view_model.dart';
import 'package:aquabuildr/test/widgets/store_items_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoreItemListPage extends StatelessWidget {

  final StoreViewModel store;

  final _nameController = TextEditingController(); 
  final _priceController = TextEditingController(); 
  final _quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  StoreItemListViewModel _storeItemListVM;

  StoreItemListPage({this.store}){
    _storeItemListVM = StoreItemListViewModel(store:store);
  }

  String _validate(String value) {
    if(value.isEmpty) {
      return "Field cannot be empty";
    }

    return null; 
  }

  void _saveStoreItem() {
    if(_formKey.currentState.validate()){
      //save the store item
      _storeItemListVM.name = _nameController.text;
      _storeItemListVM.price = double.parse(_priceController.text);
      _storeItemListVM.quantity = int.parse(_quantityController.text);

      _storeItemListVM.saveStoreItem();

      _clearTextBoxes();

    }
  }

  void _clearTextBoxes() {
    _nameController.clear(); 
    _priceController.clear(); 
    _quantityController.clear(); 
  }

  Widget _buildStoreItems() {
    //return Container();

    return StreamBuilder<QuerySnapshot>(
      stream: _storeItemListVM.storeItemsAsStream,
      builder: (context, snapshot){
        if(!snapshot.hasData) return Text("No items found!");
        final storeItems = snapshot.data.docs.map((item) => StoreItemViewModel.fromSnapshot(item)).toList();
        
        return StoreItemsWidget(storeItems: storeItems, onStoreItemDeleted: (storeItem) {
            _storeItemListVM.deleteStoreItem(storeItem);
        });
      },
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
          key: _formKey,
          child: Column(children: [
          TextFormField(
            controller: _nameController,
            validator: _validate,
            decoration: InputDecoration(
              hintText: "Enter store item"
            ),
          ),
          TextFormField(
            controller: _priceController,
            validator: _validate,
            decoration: InputDecoration(
              hintText: "Enter price"
            ),
          ),
           TextFormField(
            controller: _quantityController,
            validator: _validate,
            decoration: InputDecoration(
              hintText: "Enter quantity"
            ),
          ),
          RaisedButton(
            child: Text("Save", style: TextStyle(color: Colors.white)), 
            color: Colors.blue, 
            onPressed: () {
             _saveStoreItem();
            },
          ),
          Expanded(
            child: _buildStoreItems()
          )

        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(store.name), 
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pop(context, true); 
          },
        )
      ), 
      body: _buildBody()
    );
    
  }
}