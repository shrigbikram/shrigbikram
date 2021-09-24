import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/widgets/custom_overlay_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class AqFeedback extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();

  Widget buildTextInputFields(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              
              Text(
                "Thanks for choosing Aquabuildr!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 16,
              ),

              Text(
                "The app made for aquarists…by aquarists. We’re constantly updating our platform, and would love your feedback on how to improve!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 300,
                child: TextFormField(
                  maxLines: 12,
                  onTap: () {
                    print("Feedback");
                    //provider.updateIsKeyboardShown(true);
                  },
                  onFieldSubmitted: (val) {
                    print("final val of feedback = " + val);
                    //Global.fullname = val;
                    //provider.updateIsKeyboardShown(false);
                  },
                  controller: _feedbackController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Write some feedback!";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Your feedback here ...",
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              buildSubmitButton(context),
              SizedBox(
                height: 20,
              )
            ]),
          ),
        ),
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    final isKeyb = MediaQuery.of(context).viewInsets.bottom != 0;

    void _submitButtonPressed() async {
      
      print("Submit button pressed !");

      if (_formKey.currentState.validate()) {
        print("validation success !");

        print("Feedback = " + _feedbackController.text);


        //final bool canSend = await canSendMail();

        // if (!canSend && Platform.isIOS) {
        //   final url = 'mailto:$recipient?body=$body&subject=$subject';
        //   if (await canLaunch(url)) {
        //     await launch(url);
        //   } else {
        //     throw 'Could not launch $url';
        //   }
        // }
        String feedback = _feedbackController.text;

        String msgbody = "<br>Hello Aquabuildr, I had some recommendations I wanted to share with you:<br><br>$feedback" +
            "<br><br>Best Regards";

        print("formated msgbody = ");
        print(msgbody);

        final MailOptions mailOptions = MailOptions(
          body: msgbody,
          subject: 'Feedback from well wisher',
          recipients: ["aquabuildr2021@gmail.com"],
          isHTML: true,
          //bccRecipients: ['aquabuildr2021@gmail.com'],
          //ccRecipients: [_emailAddrsController.text],
          // attachments: [
          //   'path/to/image.png',
          // ],
        );

        //print("boughtfisheslist = " + boughtfisheslist);

        MailerResponse response;
        try {
          response = await FlutterMailer.send(mailOptions);
        } catch (error) {
          showDialog(
              useRootNavigator: true,
              context: context,
              builder: (context) => CustomOverlayView(
                    title: "Error Sending Mail!",
                    description:
                        "Check if you got apple default mail app. If you got default mail app, please try later.",
                    okButtonText: "OK",
                    onOkBtnPressed: (isok, cxt) {
                      print("OK pressed");
                      Navigator.pop(cxt);
                    },
                  ));

          print("ERROR SENDING EMAIL = " + error.toString());
          return;
        }

        String platformResponse;
        // print("response while sending mail = " + response.toString());

        switch (response) {
          case MailerResponse.saved:

            /// ios only
            platformResponse = 'mail was saved to draft';
            print("mail was saved to draft");
            break;
          case MailerResponse.sent:

            /// ios only
            platformResponse = 'mail was sent';
            print("platformresponse = " + platformResponse);

            showDialog(
                useRootNavigator: true,
                context: context,
                builder: (context) => CustomOverlayView(
                      title: "Feedback Sent!",
                      description:
                          "Your feedback has been submitted successfully.\n\nThanks for using Aquabuildr.",
                      okButtonText: "OK",
                      onOkBtnPressed: (isok, cxt) {
                        print("OK pressed");
                        Navigator.pop(cxt);
                      },
                    ));
            break;
          case MailerResponse.cancelled:

            /// ios only
            platformResponse = 'mail was cancelled';
            print("mail was cancelled");
            break;
          case MailerResponse.android:
            platformResponse = 'intent was successful';

            break;
          default:
            platformResponse = 'unknown';
            print("error unknown");
            break;
        }
      } else {
        print("Error enter name /address");
        showDialog(
            useRootNavigator: true,
            context: context,
            builder: (context) => CustomOverlayView(
                  title: "Mail Failed!",
                  description: "Verify your email address or Try Again.",
                  okButtonText: "OK",
                  onOkBtnPressed: (isok, cxt) {
                    print("OK pressed");
                    Navigator.pop(cxt);
                  },
                ));
      }

      // final MailOptions mailOptions = MailOptions(
      //   body: 'a long body for the email <br> with a subset of HTML',
      //   subject: 'the Email Subject',
      //   recipients: ['example@example.com'],
      //   isHTML: true,
      //   bccRecipients: ['other@example.com'],
      //   ccRecipients: ['third@example.com'],
      //   // attachments: [
      //   //   'path/to/image.png',
      //   // ],
      // );
    }

    // if (provider.isKeyboard) {
    //   print("iskeyboard");
    //   return Container();
    // } else {
    //   print("no keyboard");
    // }

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width - 36,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: PrimaryColorGreen,
            onPrimary: Colors.white,
            shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(1))),
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _submitButtonPressed();
          },
          child: Text(
            "SUBMIT",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: PrimaryColorBlue,
          title: Text("Feedback"),),
        body: buildTextInputFields(context),

        /*
        Stack(
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
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "If you’re looking for a more advanced and elite tank, contact Aquabuildr directly and we’ll connect you with one of our certified, professional partners we would recommend to our moms.",
                          style: TextStyle(
                              color: Colors.grey.shade800, fontSize: 16),
                        ),

                        SizedBox(height: 20),

                        Text(
                          "Enter the following details:",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),

                        SizedBox(height: 20),

                        TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Full Name'),
                        ),

                        SizedBox(height: 20),

                        TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Phone Number'),
                        ),

                        SizedBox(height: 20),

                        TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Email Address'),
                        ),

                        SizedBox(height: 20),

                        TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Tank Dimension'),
                        ),

                        //Min Tank Size
                        SizedBox(height: 20),

                        DropDownList(TankType, "Tank Type : ", _tankType,
                            (itemSelected) {
                          _tankType = itemSelected;
                          setState(() {});
                        }),

                        SizedBox(height: 20),

                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width - 2 * Constants.kPadding,
                          child: 
                        ),

                        //          FlatButton(
                        //   height: 56,
                        //   minWidth: MediaQuery.of(context).size.width,
                        //   child:
                        //   onPressed: () {

                        //    // setState((){isLoading = true;});

                        //     FocusScope.of(context).requestFocus(FocusNode());
                        //     //_saveAquabuildrFish(context);
                        //   },
                        //   color: Colors.green,
                        //   textColor: Colors.white,
                        // ),

                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
*/
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          TextSpan(
              text: description,
              style: TextStyle(fontSize: 15, color: Colors.black54))
        ])),
        SizedBox(height: 5),
      ],
    );
  }
}
