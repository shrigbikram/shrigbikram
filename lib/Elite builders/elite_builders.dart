import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/utils/utils.dart';
import 'package:aquabuildr/widgets/custom_overlay_view.dart';
import 'package:aquabuildr/widgets/dropdownlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class EliteBuilders extends StatefulWidget {
  @override
  _EliteBuilders createState() => _EliteBuilders();
}

class _EliteBuilders extends State<EliteBuilders> {
  List<String> TankType = [
    "Freshwater",
    "Saltwater",
  ];

  String _tankType = "Freshwater";

  static final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailAddrsController = TextEditingController();
  final _dimensionOfTankController = TextEditingController();
  final _zipcodeController = TextEditingController();

  Widget buildTextInputFields(BuildContext context) {
    bool valuefirst = false;

    //_fullNameController.text = Global.fullname;
    //_emailAddrsController.text = Global.email;

    return Container(
      //height: 220,
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "If you’re looking for a more advanced and elite tank, contact Aquabuildr directly and we’ll connect you with one of our certified, professional partners we would recommend to our moms.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 50,
                child: TextFormField(
                  onTap: () {
                    print("Name clicked");
                    //provider.updateIsKeyboardShown(true);
                  },
                  onFieldSubmitted: (val) {
                    print("final val of name = " + val);
                    //Global.fullname = val;
                    //provider.updateIsKeyboardShown(false);
                  },
                  controller: _fullNameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Full name is required!";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Name",
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
                height: 10,
              ),
              Container(
                height: 50,
                child: TextFormField(
                  onTap: () {
                    print("Ph No clicked");
                    //provider.updateIsKeyboardShown(true);
                  },
                  onFieldSubmitted: (val) {
                    print("Ph no = " + val);
                    //Global.fullname = val;
                    //provider.updateIsKeyboardShown(false);
                  },
                  controller: _phoneNumberController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Phone Number is required!";
                    }

                    if (!Utils.isNumeric(value)) {
                      return "Please enter correct phone number";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Phone Number",
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
                height: 10,
              ),
              Container(
                height: 50,
                child: TextFormField(
                  controller: _emailAddrsController,
                  onTap: () {
                    print("Email clicked");
                    //provider.updateIsKeyboardShown(true);
                  },
                  onFieldSubmitted: (val) {
                    print("final val of email = " + val);
                    //Global.email = val;
                    //provider.updateIsKeyboardShown(false);
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Email address is required!";
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return 'Please a valid Email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Email Address",
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
                height: 10,
              ),
              Container(
                height: 50,
                child: TextFormField(
                  onTap: () {
                    print("Dimensions clicked");
                    //provider.updateIsKeyboardShown(true);
                  },
                  onFieldSubmitted: (val) {
                    print("tank dimensions = " + val);
                    //Global.fullname = val;
                    //provider.updateIsKeyboardShown(false);
                  },
                  controller: _dimensionOfTankController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Tank Dimensions is required!";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Dimension of Tank",
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
                height: 10,
              ),
              Container(
                height: 50,
                child: TextFormField(
                  onTap: () {
                    print("Zipcode clicked");
                    //provider.updateIsKeyboardShown(true);
                  },
                  onFieldSubmitted: (val) {
                    print("Zipcode = " + val);
                    //Global.fullname = val;
                    //provider.updateIsKeyboardShown(false);
                  },
                  controller: _zipcodeController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Zipcode is required!";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Zipcode",
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
                height: 10,
              ),
              DropDownList(TankType, "   Tank Type : ", _tankType,
                  (itemSelected) {
                _tankType = itemSelected;
                setState(() {});
              }),
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
      print("submit button pressed");

      if (_formKey.currentState.validate()) {
        print("validation success !");

        print("Name = " + _fullNameController.text);
        print("Ph No. = " + _phoneNumberController.text);
        print("Email = " + _emailAddrsController.text);
        print("Tank Dimension = " + _dimensionOfTankController.text);

        //final bool canSend = await canSendMail();

        // if (!canSend && Platform.isIOS) {
        //   final url = 'mailto:$recipient?body=$body&subject=$subject';
        //   if (await canLaunch(url)) {
        //     await launch(url);
        //   } else {
        //     throw 'Could not launch $url';
        //   }
        // }
        String name = _fullNameController.text;
        String phno = _phoneNumberController.text;
        String email = _emailAddrsController.text;
        String tankdimen = _dimensionOfTankController.text;
        String zipcode = _zipcodeController.text;
        String tanktyp = _tankType;

        // final boughtfisheslist =
        //     await _starterAquariumItemListVM.loadTankItems(isStarterAquarium);

        // print(boughtfisheslist);

        String msgbody = "Hello Aquabuildr,<br>" +
            "Please find my details below:<br>" +
            "<br>Name: $name" +
            "<br>Phone No.: $phno" +
            "<br>Email: $email" +
            "<br>Tank Dimension: $tankdimen" +
            "<br>Zipcode: $zipcode" +
            "<br>Tank Type: $tanktyp" +
            "<br><br>I want to set up my own custom elite aquarium." +
            "<br><br>Regards," +
            "<br>$name";

        print("formated msgbody = ");
        print(msgbody);

        final MailOptions mailOptions = MailOptions(
          body: msgbody,
          subject: 'Request for Elite Aquarium',
          recipients: ["aquabuildr2021@gmail.com"],
          isHTML: true,
          //bccRecipients: ['aquabuildr2021@gmail.com'],
          ccRecipients: [_emailAddrsController.text],
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
                      title: "Elite Request Placed!",
                      description:
                          "Your request to make your own elite advanced aquarium has been submitted successfully.\n\nThanks for using Aquabuildr.",
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
            primary: PrimaryColorGreen, //Colors.green.shade400,
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
            backgroundColor: PrimaryColorBlue, title: Text("Elite Builders")),
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
