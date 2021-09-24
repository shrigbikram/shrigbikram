import 'package:aquabuildr/utils/constants.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
                    backgroundColor: PrimaryColorBlue,

          title: Text("About Us")),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height: 20,),

                        Container(
                          margin: EdgeInsets.only(left: 64),
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width - 132,
                          height: 200,
                          child: Material(
                            color: Colors.white,
                                  //borderRadius: BorderRadius.all(
                                  //  Radius.circular(50.0)),
                                  //elevation: 2,
                                  child: Padding(
                                padding: EdgeInsets.all(0.0),
                                child: Image.asset(
                                  "assets/images/app_bar_logo.png",
                                  //width: 140,
                                  //height: 100,
                                ),
                              )),
                        ),
                        SizedBox(height: 20,),

                        showDetailTile(
                          "Who we are ?",
                          "\n\nHello thanks for joining Aquabuildr! We are your home aquatic specialists that help hobbyists set up their first aquarium. So many fish enthusiasts would love to have a home aquarium, but there are so many things that can go wrong! We can help with that!",
                        ),
                        SizedBox(height: 20,),

                        showDetailTile(
                          "What we do?",
                          "\n\nTemperature, pH levels, incompatible fish, too many fish, too small of a tank… These are all reasons why home aquariums tend not to last! And as an owner, that can get very frustrating! At Aquabuildr, we have taken much of the headache out of the process for you. Our algorithms have been designed so your hardest decision is which fish you want to start with, and we’ll help you in every step of the way!",
                        ), 
                        SizedBox(height: 20,),

                        showDetailTile(
                          "Our Vision",
                          "\n\nFor all fish in the home aquatic industry to live long, healthy and happy lives.",
                        ), 
                        SizedBox(height: 20,),

                        showDetailTile(
                          "Our Mission",
                          "\n\nTo educate and support anyone on how to become a successful aquarist, no matter how old.",
                        ), 
                        SizedBox(height: 20,),

                        showDetailTile(
                          "Our Goals",
                          "\n\nTo provide a seamless aquarium building/maintenance process for the aspiring, beginner and intermediate aquarists. Our goal is for aquariums all over the world to be happy and healthy for many generations to come.",
                        ), 
                                                SizedBox(height: 60,),

                      
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showDetailTile(String title, String description) {
    return Column(
      children: [
        SizedBox(height: 5),
        Text.rich(TextSpan(children: [
          TextSpan(
              text: title,
              style: TextStyle(fontSize: 20,color: PrimaryColorBlue, fontWeight: FontWeight.bold)),
          TextSpan(
              text: description,
              style: TextStyle(fontSize: 18, color: Colors.black87))
        ])),
        SizedBox(height: 5),
      ],
    );
  }
}
