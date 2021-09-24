import 'package:aquabuildr/test/pages/my_incidents_page.dart';
import 'package:aquabuildr/utils/app_navigator.dart';
import 'package:aquabuildr/test/view_models/incident_list_view_model.dart';
import 'package:aquabuildr/widgets/empty_or_no_items.dart';
import 'package:aquabuildr/test/widgets/incident_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IncidentListPage extends StatefulWidget {
  @override
  _IncidentListPage createState() => _IncidentListPage();
}

class _IncidentListPage extends State<IncidentListPage> {
  IncidentListViewModel _incidentListVM = IncidentListViewModel();
  List<IncidentViewModel> _incidents = []; // List<IncidentViewModel>();

  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _subscribeToFirebaseAuthChanges();
    _populateAllIncidents();
  }

  void _subscribeToFirebaseAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        setState(() {
          _isSignedIn = false;
        });
      } else {
        setState(() {
          _isSignedIn = true;
        });
      }
    });
  }

  void _populateAllIncidents() async {
    final incidents = await _incidentListVM.getAllIncidents();

    setState(() {
      _incidents = incidents;
    });
  }

  void _navigateToRegisterPage(BuildContext context) async {
    final bool isRegistered =
        await AppNavigator.navigateToRegisterPage(context);
    if (isRegistered) {
      AppNavigator.navigateToLoginPage(context);
    }
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context) =>

    //   ChangeNotifierProvider(
    //     create: (context) => RegisterViewModel(),
    //     child: RegisterPage()
    //   )

    //   , fullscreenDialog: true
    // ));
  }

  void _navigateToLoginPage(BuildContext context) async {
    final bool isLoggedIn = await AppNavigator.navigateToLoginPage(context);
    if (isLoggedIn) {
      //go to my incidents page
      AppNavigator.navigateToMyIncidentsPage(context);
    }

    //  Navigator.push(context, MaterialPageRoute(
    //   builder: (context) =>

    //   ChangeNotifierProvider(
    //     create: (context) => LoginViewModel(),
    //     child: LoginPage()
    //   )

    //   , fullscreenDialog: true
    // ));
  }

  // void _navigateToLoginPage(BuildContext context) async {
  //    Navigator.push(context, MaterialPageRoute(
  //     builder: (context) => LoginPage(), fullscreenDialog: true
  //   ));
  // }

  void _navigateToMyIncidentsPage(BuildContext context) {
    AppNavigator.navigateToMyIncidentsPage(context);
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => MyIncidentsPage()));
  }

  void _navigateToAddIncidentsPage(BuildContext context) async {
    //   Navigator.push(context, MaterialPageRoute(
    //   builder: (context) => AddIncidentsPage()
    // ));

    final bool isIncidentAdded =
        await AppNavigator.navigateToAddIncidentsPage(context);
        
        if (isIncidentAdded != null) {
          if (isIncidentAdded) {
            _populateAllIncidents();
          }
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Latest Incidents")),
        drawer: Drawer(
            child: ListView(
          children: [
            DrawerHeader(child: Text("Menu")),
            ListTile(title: Text("Home")),
            _isSignedIn
                ? ListTile(
                    title: Text("My Incidents"),
                    onTap: () async {
                      _navigateToMyIncidentsPage(context);
                    })
                : SizedBox.shrink(),
            ListTile(
              title: Text("Add Incident"),
              onTap: () {
                _navigateToAddIncidentsPage(context);
              },
            ),
            !_isSignedIn
                ? ListTile(
                    title: Text("Login"),
                    onTap: () {
                      _navigateToLoginPage(context);
                    })
                : SizedBox.shrink(),
            !_isSignedIn
                ? ListTile(
                    title: Text("Register"),
                    onTap: () {
                      _navigateToRegisterPage(context);
                    })
                : SizedBox.shrink(),
            _isSignedIn
                ? ListTile(
                    title: Text("Logout"),
                    onTap: () async {
                      //logout the user
                      await FirebaseAuth.instance.signOut();
                    })
                : SizedBox.shrink()
          ],
        )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _incidents.length > 0
              ? IncidentList(_incidents)
              : EmptyOrNoItems(message: "No incidents foiund !"),
        ));
  }
}
