

import 'package:aquabuildr/utils/constants.dart';
import 'package:flutter/material.dart';

class EmptyOrNoItems extends StatelessWidget {

  final String message; 

  EmptyOrNoItems({this.message = ""});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20, bottom: 40),
      child: Text(
        message, 
        style: TextStyle(fontSize: 18, color: PrimaryColorGreen, fontWeight: FontWeight.w500)),
    );
  }
} 