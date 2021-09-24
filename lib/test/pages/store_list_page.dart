
import 'package:aquabuildr/test/pages/add_store_page.dart';
import 'package:aquabuildr/test/pages/store_item_list_page.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/test/view_models/add_store_view_model.dart';
import 'package:aquabuildr/test/view_models/store_list_view_model.dart';
import 'package:aquabuildr/test/view_models/store_view_model.dart';
import 'package:aquabuildr/widgets/empty_results_widget.dart';
import 'package:aquabuildr/test/widgets/item_count_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreListPage extends StatefulWidget {
  @override 
  _StoreListPage createState() => _StoreListPage(); 
}

class _StoreListPage extends State<StoreListPage> {

  bool _reloadData = false;
  StoreListViewModel _storeListVM = StoreListViewModel();

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: _storeListVM.storesAsStream,
      builder: (context, snapshot){
        if(snapshot.hasData && snapshot.data.docs.isNotEmpty){
          return _buildList(snapshot.data);
        }else{
          return EmptyResultsWidget(message: Constants.NO_STORES_FOUND);
        }
      },
      );
  }

  Widget _buildList(QuerySnapshot snapshot){
    final stores = snapshot.docs.map((doc) => StoreViewModel.fromSnapshot(doc)).toList();
    return ListView.builder(
      itemCount: stores.length,
      itemBuilder: (context, index){
        final store = stores[index];
        return _buildListItem(store, (store){
          //we got access to context
          _navigateToStoreItems(context, store);
        });
      }
    );
  }

  Widget _buildListItem(StoreViewModel store, void Function(StoreViewModel) onStoreSelected){
    return ListTile(
      title: Text(store.name,style:TextStyle(fontSize:18 ,fontWeight:FontWeight.w500)),
      subtitle: Text(store.address),
      /*trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            //Text(store.itemsCountAsync),//not possible sicne it's returning future
            Spacer(),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),*/
      trailing: FutureBuilder<int>(
        future: store.itemsCountAsync,
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return ItemCountWidget(count: snapshot.data);
          }else{
            return SizedBox.shrink();
          }
        },
      ),
      onTap: () => onStoreSelected(store), 
      // {
      //  // _navigateToStoreItems() // no context so pass call to owner
      // },
    );

  }

  void _navigateToStoreItems(BuildContext context, StoreViewModel store) async { 
    final bool refreshStores = await Navigator.push(context, MaterialPageRoute(builder: (context) => StoreItemListPage ( store: store)));

    if(refreshStores){
      setState(() {
        _reloadData = true;
      });
    }

  }
  
  void _navigateToAddStorePage(BuildContext context){
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider
      (
        create: (context) => AddStoreViewModel(),
        child: AddStorePage(),
      ),fullscreenDialog:true));

      //  Navigator.push(context, MaterialPageRoute(builder: (context) => AddStorePage(),
      // fullscreenDialog: true)); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Grocery App"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Icon(Icons.add),
                onTap: () {
                  _navigateToAddStorePage(context);
                },
              ),
            )
          ],
        ),
        body: _buildBody());
  }
}
