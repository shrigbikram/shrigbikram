import 'dart:io';
import 'package:aquabuildr/Add%20StarterAquarium/viewmodel/add_starteraquarium_view_model.dart';
import 'package:aquabuildr/Starter%20Aquariums/model/starter_aquarium_view_state.dart';
import 'package:aquabuildr/Starter%20Aquariums/viewmodel/starter_aquarium_list_view_model.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/widgets/ab_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

enum PhotoOptions { camera, library }

class AddStarterAquariumPage extends StatefulWidget {
  final bool isAquariumUpdate;
  final StarterAquariumViewModel starterAquarium;

  const AddStarterAquariumPage(
      {Key key, this.isAquariumUpdate, this.starterAquarium})
      : super(key: key);

  @override
  _AddStarterAquariumPage createState() => _AddStarterAquariumPage(
      isAquariumUpdate: this.isAquariumUpdate,
      starterAquarium: this.starterAquarium);
}

class _AddStarterAquariumPage extends State<AddStarterAquariumPage> {
  bool isAquariumUpdate;
  StarterAquariumViewModel starterAquarium;
  _AddStarterAquariumPage({this.isAquariumUpdate, this.starterAquarium});

  File _image;
  final _formKey = GlobalKey<FormState>();

  AddStarterAquariumViewModel _addStarterAquariumViewModel;

  final _aquariumNameController = TextEditingController();
  final _starterKitLabelController = TextEditingController();
  final _aquariumDescController = TextEditingController();
  final _aquariumSizeController = TextEditingController();

  double _lowerTemprValue = 18.0;
  double _upperTemprValue = 22.0;

  double _lowerpHValue = 6.0;
  double _upperpHValue = 8.0;

  bool isLoading = false;

  void _selectPhotoFromPhotoLibrary() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  void _selectPhotoFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  void _optionSelected(PhotoOptions option) {
    switch (option) {
      case PhotoOptions.camera:
        _selectPhotoFromCamera();
        break;
      case PhotoOptions.library:
        _selectPhotoFromPhotoLibrary();
        break;
    }
  }

  void _saveStarterAquarium(BuildContext context) async {
    // validate the form
    if (_formKey.currentState.validate()) {
      String filePath;
      if (_image != null) {
        //upload photo
        //upload the photo to firebase storage
        filePath = await _addStarterAquariumViewModel.uploadFile(_image);
        print(filePath);
      } else {
        filePath = starterAquarium.photoURL;
      }

      if (filePath.isNotEmpty) {
        final aquariumName = _aquariumNameController.text;
        final starterKiklbl = _starterKitLabelController.text;
        final aquariumDesc = _aquariumDescController.text;
        final aquariumSize = int.parse(_aquariumSizeController.text);

        String celsiusTemp =
            _lowerTemprValue.toString() + "-" + _upperTemprValue.toString();

        double lower_fahrenheit = ((_lowerTemprValue * 9) / 5) + 32;
        double upper_fahrenheit = ((_upperTemprValue * 9) / 5) + 32;

        String farenheitTemp =
            lower_fahrenheit.toString() + "-" + upper_fahrenheit.toString();

        final prefTempr = farenheitTemp;

        String phval =
            _lowerpHValue.toString() + "-" + _upperpHValue.toString();
        print("pHvalue = " + phval);

        //save the aquabuildr to firestore database
        final _starterAquariumVS = StarterAquariumViewState(
            aquariumName: aquariumName,
            starterKitLabel: starterKiklbl,
            aquariumDesciption: aquariumDesc,
            aquariumSize: aquariumSize,
            aquariumType: "Freshwater",
            photoURL: filePath,
            temperature: celsiusTemp + "/" + farenheitTemp,
            phValue: phval,
            reference: isAquariumUpdate ? starterAquarium.aquariumDocRefId: null);

        if (isAquariumUpdate) {
          final isUpdated = await _addStarterAquariumViewModel
              .updateStarterAquarium(_starterAquariumVS);

          if (isUpdated) {
            Navigator.pop(context, true);
          }
        } else {
          final isSaved = await _addStarterAquariumViewModel
              .saveStarterAquarium(_starterAquariumVS);

          if (isSaved) {
            Navigator.pop(context, true);
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();

    print("isAquariumUpdate = " + isAquariumUpdate.toString());

    if (starterAquarium != null) {

      //Textfields
      _aquariumNameController.text = starterAquarium.aquariumName;
      _starterKitLabelController.text = starterAquarium.starterKitLabel;
      _aquariumDescController.text = starterAquarium.aquariumDesciption;
      _aquariumSizeController.text = starterAquarium.aquariumSize.toString();
      
      //sliders
      List<String> phvalues = starterAquarium.phValue.split('-');
      _lowerpHValue = double.parse(phvalues[0]);
      _upperpHValue = double.parse(phvalues[1]);

      print("Lower Ph = " + _lowerpHValue.toString());
      print("Upper Ph = " + _upperpHValue.toString());


      List<String> temprvalues = starterAquarium.temperature.split('/');
      String celsiusTempr = temprvalues[0];

      List<String> celsiusTemprs = celsiusTempr.split('-');
      _lowerTemprValue = double.parse(celsiusTemprs[0]);
      _upperTemprValue = double.parse(celsiusTemprs[1]);

      print("Lower tempr = " + _lowerTemprValue.toString());
      print("Upper tempr = " + _upperTemprValue.toString());


    } else {

      _lowerTemprValue = 16.0;
      _upperTemprValue = 22.0;

      _lowerpHValue = 6.0;
      _upperpHValue = 8.0;
      // _aquariumType = "Freshwater";
      // _prefNoPerTank = "1";
      // _activityLevel = "Moderate";
      // _temperament = "Semi-aggressive";
      // _cycleSpecies = "Yes";
    }
  }

  Widget _buildLoadingWidget() {
    return Text(
      "Loading...",
      style: TextStyle(fontSize: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    _addStarterAquariumViewModel =
        Provider.of<AddStarterAquariumViewModel>(context);

    return Scaffold(
        appBar: AppBar(
                    backgroundColor: PrimaryColorBlue,

          title: isAquariumUpdate
              ? Text("Update Fish")
              : Text("Add Aquabuildr Fish"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: [
                SizedBox(
                  child: !isAquariumUpdate
                      ? SizedBox(
                          child: _image == null
                              ? Image.asset("assets/images/freshgoldaq.jpg")
                              : Image.asset(_image.path),
                          height: 250)
                      : SizedBox(
                          child: _image == null
                              ? CachedNetworkImage(
                                  imageUrl: starterAquarium.photoURL,
                                  fit: BoxFit.scaleDown)
                              : Image.asset(_image.path),
                          height: 300),

                  // _image == null
                  //     ? Image.asset(
                  //         "assets/images/freshgoldaq.jpg",
                  //         //width: MediaQuery. of(context). size. width,
                  //         // height: 200,
                  //         //fit: BoxFit.fill
                  //       )
                  //     : Image.asset(_image.path),
                  // //width: MediaQuery. of(context). size. width,
                  // height: 300,
                ),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: FlatButton(
                    height: 48,
                    minWidth: MediaQuery.of(context).size.width - 140,
                    color: Colors.blue,
                    onPressed: () {},
                    textColor: Colors.white,
                    child: PopupMenuButton<PhotoOptions>(
                      child: Text(
                        isAquariumUpdate
                            ? "Update Aquarium Image"
                            : "Add New Aquarium Image",
                        style: TextStyle(fontSize: 18),
                      ),
                      onSelected: _optionSelected,
                      itemBuilder: (context) => [
                        // PopupMenuItem(
                        //   child: Text("Take a picture"),
                        //   value: PhotoOptions.camera,
                        // ),
                        PopupMenuItem(
                            child: Text("Select from photo library"),
                            value: PhotoOptions.library)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 60),

                // TextFormField(
                //   controller: _aquariumNameController,
                //   validator: (value) {
                //     if (value.isEmpty) {
                //       return "Aquarium type is required!";
                //     }
                //     return null;
                //   },
                //   decoration: InputDecoration(hintText: "Enter aquarium type"),
                // ),

                TextFormField(
                  controller: _aquariumNameController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Aquarium name is required!";
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: "Aquarium Name",
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      hintText: "Enter Aquarium Name"),
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: _starterKitLabelController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Starter kit label is required!";
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: "Starter Kit Label",
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      hintText: "Enter Starter Kit Label"),
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: _aquariumSizeController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Aquarium Size is required!";
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: "Aquarium Size(gallons)",
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      hintText: "Enter Aquarium Size"),
                ),

                SizedBox(height: 20),

                TextFormField(
                  controller: _aquariumDescController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Description is required!";
                    }
                    return null;
                  },
                  maxLines: null,
                  minLines: 5,
                  decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      hintText: "Enter description!"),
                ),

                Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Preferred Temperature (Celsius)",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black54),
                    )),

                //_buildTemperatureSlider(context),
                ABSlider(temprHatchLabelList, temprMin, temprMax, _lowerTemprValue, _upperTemprValue,
                    (sliderLowerVal, sliderUpperVal) {
                  // print("Temp -> sliderUpperVal = " + sliderUpperVal.toString());
                  // print("Temp -> sliderLowerVal = " + sliderLowerVal.toString());
                  _lowerTemprValue = sliderLowerVal;
                  _upperTemprValue = sliderUpperVal;
                }),

                SizedBox(height: 32),

                Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "pH Value",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black54),
                    )),

                ABSlider(phHatchLabelList, phMin, phMax, _lowerpHValue, _upperpHValue,
                    (sliderLowerVal, sliderUpperVal) {
                  // print("pH -> sliderUpperVal = " + sliderUpperVal.toString());
                  // print("pH -> sliderLowerVal = " + sliderLowerVal.toString());
                  _lowerpHValue = sliderLowerVal;
                  _upperpHValue = sliderUpperVal;
                }),
                SizedBox(height: 32),

                !isLoading 
                ?
                FlatButton(
                  height: 46,
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    isAquariumUpdate ? "UPDATE" : "SUBMIT",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {

                    setState((){isLoading = true;});

                    FocusScope.of(context).requestFocus(FocusNode());
                    _saveStarterAquarium(context);
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                )
                :
                Center(
                      child: CircularProgressIndicator(),
                    ),

                SizedBox(height: 32),
              ]),
            ),
          ),
        ));
  }
}
