import 'package:aquabuildr/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title, description, okButtonText, cancelButtonText;
  final Image image;
  final ABAlertType abAlertType;
  final Function(bool, BuildContext) onOkBtnPressed;

  CustomDialog(
      {this.title,
      this.description,
      this.okButtonText,
      this.cancelButtonText,
      this.image,
      this.abAlertType,
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

    Size size = MediaQuery.of(context).size;
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
              children: <Widget>[
                Row(
                  children: [
                    abAlertType == ABAlertType.COMPATIBILITYWARNING
                        ? Icon(
                            Icons.warning_amber_outlined,
                            color: Colors.red,
                          )
                        : Image.asset(
                            "assets/images/aq_logo.png",
                            width: 30,
                            height: 30,
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 180,
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize:
                              abAlertType == ABAlertType.COMPATIBILITYWARNING
                                  ? 17
                                  : 18.0,
                          fontWeight: FontWeight.w800,
                          color: abAlertType == ABAlertType.COMPATIBILITYWARNING
                              ? Colors.red.shade400
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
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
                      cancelButtonText != ""
                          ? GestureDetector(
                              onTap: () => {onOkBtnPressed(false, context)},
                              child: Container(
                                  alignment: Alignment.center,
                                  width: size.width/3 - 14,//136,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      // border: Border.all(
                                      //   color: Colors.red[500],
                                      // ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2))),
                                  child: Text(
                                    cancelButtonText,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  )),
                            )
                          : SizedBox(width: 0),
                      cancelButtonText != ""
                          ? SizedBox(width: 20)
                          : SizedBox(
                              width: 0,
                            ),
                      GestureDetector(
                        onTap: () => {onOkBtnPressed(true, context)},
                        child: Container(
                            alignment: Alignment.center,
                            width: size.width/3 - 14,//136,
                            height: 50,
                            decoration: BoxDecoration(
                                color: abAlertType ==
                                        ABAlertType.COMPATIBILITYWARNING
                                    ? Colors.red.shade400
                                    : Colors.blue,
                                // border: Border.all(
                                //   color: Colors.red[500],
                                // ),
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
