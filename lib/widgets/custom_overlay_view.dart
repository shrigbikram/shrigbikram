import 'package:flutter/material.dart';

class CustomOverlayView extends StatelessWidget {
  final String title, description, okButtonText;
  final Function(bool, BuildContext) onOkBtnPressed;

  CustomOverlayView(
      {this.title,
      this.description,
      this.okButtonText,
      this.onOkBtnPressed});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: [
        Container(
            padding: EdgeInsets.only(top: 60, bottom: 36, left: 26, right: 26),
            //margin: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  )
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text(
                  title, 
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87),),
                SizedBox(height: 20),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 34.0),
                Container(
                  //color: Colors.red,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => {onOkBtnPressed(true, context)},
                        child: Container(
                            alignment: Alignment.center,
                            width: 136,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                            child: Text(
                              okButtonText,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            )),


      ],
    );
  }
}
