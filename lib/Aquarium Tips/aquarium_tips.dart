import 'dart:io';
import 'package:aquabuildr/Aquarium%20Tips/slidertiles.dart';
import 'package:aquabuildr/Aquarium%20Tips/tipsdata.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:flutter/material.dart';

class AquariumTips extends StatefulWidget {
   _AquariumTipsState createState() => _AquariumTipsState();
}

class _AquariumTipsState extends State<AquariumTips> {

  List<TipsDataModel> slides = [];
  int currentIndex = 0;
  PageController pageController = new PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    slides = getslidesdata();
  }

  Widget pageIndexIndicator(bool isCurrentPage){
     return Container(
       margin: EdgeInsets.symmetric(horizontal: 2.0),
       height: isCurrentPage ? 9.0 : 5.0,
       width: isCurrentPage ? 9.0 : 5.0,
       decoration: BoxDecoration(
         color: isCurrentPage ? Colors.grey.shade600 : Colors.grey.shade400,
         borderRadius: BorderRadius.circular(12),
         ),
         
     );
  }

   @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PrimaryColorBlue,
          title: Text("Popular Aquarium Tips")),
        body: PageView.builder(
          controller: pageController,
          itemCount: slides.length,
          onPageChanged: (val) {
            setState(() {
              currentIndex = val;
            });
          },
          itemBuilder: (context, index){
            return SliderTiles(
              imageAssetPath: slides[index].getImageAssetPath(),
              title: slides[index].getTitle(),
              description: slides[index].getDescription(),
            );
          },),
          bottomSheet: currentIndex != slides.length //- 1 
          ? Container(
            color: Colors.grey.shade100,
            height: Platform.isIOS ? 90 : 70,
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    //pageController.animateToPage(slides.length - 1, duration: Duration(milliseconds: 400), curve: Curves.linear);
                    pageController.animateToPage(currentIndex - 1, duration: Duration(milliseconds: 400), curve: Curves.linear);

                  } ,
                  child: currentIndex == 0 ? Container(width: 70,child: Text("    ")) : Container(width: 70,child: Text("PREV", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: PrimaryColorGreen),)),
                ),
                Row(children: [
                  for(int i = 0; i < slides.length; i++) currentIndex == i ? pageIndexIndicator(true) : pageIndexIndicator(false)

                ],),
                InkWell(
                  onTap: () {
                    pageController.animateToPage(currentIndex + 1, duration: Duration(milliseconds: 400), curve: Curves.linear);
                  } ,
                  child: currentIndex == slides.length - 1 ? Container( width: 70, child: Text("     ")) : Container(width: 70,child: Text("NEXT", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: PrimaryColorGreen))),
                ),
              ],),
          ) 
          : Container(
            width: MediaQuery.of(context).size.width,
            height: Platform.isIOS ? 70 : 60,
            color: PrimaryColorGreen,
            alignment: Alignment.center,
            child: Text("GET STARTED NOW", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),) ,

      ),

    );
  }

  @override
  Widget build2(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
                    backgroundColor: PrimaryColorBlue,

          title: Text("Popular Aquarium Tips")),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        

                        SizedBox(height: 40,),
                        
                        showDetailTile(
                          "Tip #1 ",
                          "\n\nA freshwater tank is recommended to start out with. This will teach you how to care for and maintain your tank before you take it up a notch and start a saltwater tank! ",
                          // 'The Ocellaris Clownfish may be one of the aquarium industrys most popular marine fish.Its beautirufl orange body dressed with Can be kept with a variety of other captive-bred clownfish in black instatnsly distinguiesh the occelearis clownfish.',
                        ),

                        SizedBox(height: 40,),


                        showDetailTile(
                          "Tip #2 ",
                          "\n\nFeed your fish daily, but make sure you don’t feed them too much!",
                        ),

                        SizedBox(height: 40,),

                        showDetailTile(
                          "Tip #3 ",
                          "\n\nClean your tank regularly, we recommend a 25% water change weekly, 50% every 2 weeks or a 90% change once a month.",
                        ),
                  
                        SizedBox(height: 40,),


                        showDetailTile(
                          "Tip #4 ",
                          "\n\nBe sure you have some room around all sides of your tank. There will be drips to clean up, and you have to account for the other equipment that will be placed on your tank."
                        ),

                        SizedBox(height: 40,),

                        showDetailTile(
                          "Tip #5 ",
                          "\n\nMake sure your tank is near a power outlet.",
                        ),
                        
                        SizedBox(height: 40,),

                        showDetailTile(
                          "Tip #6 ",
                          "\n\nHave a stand that can withhold the weight of your tank. Rule of thumb= Multiply the amount gallons x 10 for a rough weight.",
                        ),

                        SizedBox(height: 40,),

                        showDetailTile(
                          "Tip #7 ",
                          "\n\nTest your water at least once a week.",
                        ),

                        SizedBox(height: 40,),

                        showDetailTile(
                          "Tip #8 ",
                          "\n\nPay attention to your fish at least twice a day. They notice!",
                        ),

                        SizedBox(height: 40,),

                        showDetailTile(
                          "Tip #9 ",
                          "\n\nRemove algae weekly.",
                        ),

                        SizedBox(height: 40,),

                        showDetailTile(
                          "Tip #10 ",
                          "\n\nChange the decorations at least twice a year. We don’t want your fish bored!",
                        ),

                        SizedBox(height: 100,),

                      
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: PrimaryColorBlue)),
          TextSpan(
              text: description,
              style: TextStyle(fontSize: 18, color: Colors.black87))
        ])),
        SizedBox(height: 5),
      ],
    );
  }

  Widget showDetailTile2(BuildContext cxt, String title, String description) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
          Container(
            alignment: Alignment.topCenter,
            child: Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),)),
          Container(
            width: MediaQuery. of(cxt). size. width - 66,
            child: Text(
              description,maxLines: 5, 
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              textAlign: TextAlign.left,)),

        ]),
        SizedBox(height: 20,)
      ],
    );
    // return Column(
    //   children: [
    //     SizedBox(height: 5),
    //     Text.rich(TextSpan(children: [
    //       TextSpan(
    //           text: title,
    //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    //       TextSpan(
    //           text: description,
    //           style: TextStyle(fontSize: 14, color: Colors.black87))
    //     ])),
    //     SizedBox(height: 5),
    //   ],
    // );
  }
}
