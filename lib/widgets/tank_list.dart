import 'package:flutter/material.dart';

class TankList extends StatelessWidget {

  // List<StarterAquariumViewModel> starterAquariums;

  // TankList(List<StarterAquariumViewModel> starterAquariums) {
  //   this.starterAquariums = starterAquariums;
  // }


  @override
  Widget build(BuildContext context) {

    return Container(
      width: 90,
      child: 
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Tank",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Stack(
            children: [
              Image.asset(
                "assets/images/fishpot.png",
                width: 70,
                height: 70,
              ),
              Container(
                alignment: Alignment.center,
                //color: Colors.red,
                width: 70,
                height: 70,
                child: Text(
                  "12",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),

         
           TankFish(),
           TankFish(),
          // TankFish(),
          // TankFish(),
          // TankFish(),
          // TankFish(),
        ],
      ),

      
    );
  

  }
}

class TankFish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (
      Stack(
      children: [
        Image.asset(
          "assets/images/saltclown.png",
          width: 70,
          height: 70,
        ),
        Container(
          alignment: Alignment.topRight,
          //color: Colors.red,
          width: 70,
          height: 70,
          child: Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            margin: EdgeInsets.all(0.0),
            decoration:
                BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            child: Text(
              "2",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    )
    );
  }
}
