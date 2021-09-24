import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/widgets/aquabuildr_available_fish_list.dart';
import 'package:aquabuildr/widgets/empty_or_no_items.dart';
import 'package:flutter/material.dart';

class TankBuilderPage extends StatefulWidget {
  final AquabuildrFishViewModel aquabuilderfish;
  final List<AquabuildrFishViewModel> aquabuildrFishes;

  const TankBuilderPage({Key key, this.aquabuilderfish, this.aquabuildrFishes})
      : super(key: key);

  _TankBuilderPageState createState() => _TankBuilderPageState(
      aquabuilderfish: this.aquabuilderfish,
      aquabuildrFishes: this.aquabuildrFishes);
}

class _TankBuilderPageState extends State<TankBuilderPage> {
  AquabuildrFishViewModel aquabuilderfish;
  List<AquabuildrFishViewModel> aquabuildrFishes;

  _TankBuilderPageState({this.aquabuilderfish, this.aquabuildrFishes});

  List<AquabuildrFishViewModel> freshwaterFishes = [];
  List<AquabuildrFishViewModel> saltwaterFishes = [];
  List<AquabuildrFishViewModel> bettaFishes = [];

  List<AquabuildrFishViewModel> compatibleFishes = [];

  //TankBuilderPage({this.aquabuilderfish, this.aquabuildrFishes});

  @override
  void initState() {
    // aquabuilderfish = this.aquabuilderfish;
    // aquabuildrFishes = this.aquabuildrFishes;
    setState(() {
      freshwaterFishes = this
          .aquabuildrFishes
          .where(
              (aquabuildrfish) => aquabuildrfish.aquariumType == "FRESHWATER")
          .toList();
      saltwaterFishes = this
          .aquabuildrFishes
          .where((aquabuildrfish) => aquabuildrfish.aquariumType == "SALTWATER")
          .toList();
      compatibleFishes = this
          .aquabuildrFishes
          .where((aquabuildrfish) =>
              aquabuildrfish.aquariumType == this.aquabuilderfish.aquariumType)
          .toList();
      bettaFishes = this
          .aquabuildrFishes
          .where((aquabuildrfish) =>
              aquabuildrfish.aquariumType == "BETTA")
          .toList();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        appBar: AppBar(
            backgroundColor: PrimaryColorBlue,//Colors.lightBlue,
            title: Text(
              "Tank Builder",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            color: Colors.red,
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(left: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(
                      color: Colors.black26,
                      height: 4,
                      thickness: 2,
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Compatible Fishes ",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 2),
                            Text(
                               "(" +compatibleFishes.length.toString() + ")",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black26,
                      height: 16,
                      thickness: 2,
                    ),
                    compatibleFishes.length > 0
                        ? AquabuildrAvailableFishList(availablefishes: compatibleFishes, onAddToTankPressed: null,)
                        : EmptyOrNoItems(message: "No fishes found!"),
                    Divider(
                      color: Colors.black26,
                      height: 4,
                      thickness: 2,
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Freshwater ",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "(" + freshwaterFishes.length.toString()+ ")",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black26,
                      height: 16,
                      thickness: 2,
                    ),
                    // freshwaterFishes.length > 0
                    //     ? AquabuildrAvailableFishList( freshwaterFishes)
                    //     : EmptyOrNoItems(message: "No fishes found!"),
                    Divider(
                      color: Colors.black26,
                      height: 4,
                      thickness: 2,
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Saltwater ",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 2),
                            Text(
                               "(" +saltwaterFishes.length.toString() + ")",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black26,
                      height: 16,
                      thickness: 2,
                    ),
                    // saltwaterFishes.length > 0
                    //     ? AquabuildrAvailableFishList(saltwaterFishes)
                    //     : EmptyOrNoItems(message: "No fishes found!"),
                    Divider(
                      color: Colors.black26,
                      height: 4,
                      thickness: 2,
                    ),
                    Expanded(
                      flex: 0,
                      child: Container(
                        padding: EdgeInsets.only(left: 20, top: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BETTA ",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: 2),
                            Text(
                               "(" +bettaFishes.length.toString() + ")",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black26,
                      height: 16,
                      thickness: 2,
                    ),
                    // bettaFishes.length > 0
                    //     ? AquabuildrAvailableFishList(bettaFishes)
                    //     : EmptyOrNoItems(message: "No fishes found!"),
                  ],
                )),
          ),
        )));
  }
}
