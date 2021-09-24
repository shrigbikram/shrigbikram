import 'package:aquabuildr/utils/constants.dart';
import 'package:flutter/material.dart';

class SliderTiles extends StatelessWidget {
  String imageAssetPath, title, description;
  SliderTiles({this.imageAssetPath, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Image.asset(imageAssetPath),
          //SizedBox(height: 20,),
          Container(
            alignment: Alignment.center,
              decoration: BoxDecoration(
                color: PrimaryColorBlue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              height: 60,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: Colors.white),
              )),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            color: Colors.grey.shade200,
              height: 180,
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400, 
                  fontSize: 18,),
              )),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
