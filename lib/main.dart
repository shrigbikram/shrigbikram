import 'package:aquabuildr/Fish%20Home/aquabuildr_fish_home_page.dart';
// import 'package:aquabuildr/test/pages/store_list_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AquabuildrFishHomePage(), 
      title: "Aquabuildr"
    );
  }
}


/*
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IncidentListPage(), 
      title: "City Incidents"
    );
  }
}
*/

/*
class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Grocery App",
      home: StoreListPage(),
      theme: ThemeData(primaryColor: Colors.green),
    );
  }
}
*/

/*
class App extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoListPage(),
      title: "Todo List"
    );
  }
}
*/