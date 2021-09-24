import 'dart:io';
import 'dart:typed_data';
import 'package:aquabuildr/Add%20Fish/viewmodel/add_aquabuildr_fish_view_model.dart';
import 'package:aquabuildr/Add%20Fish/model/aquabuildr_fish_view_state.dart';
import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:aquabuildr/utils/constants.dart';
import 'package:aquabuildr/utils/navigation_provider.dart';
import 'package:aquabuildr/utils/utils.dart';
import 'package:aquabuildr/widgets/ab_slider.dart';
import 'package:aquabuildr/widgets/dropdownlist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as skia;

enum PhotoOptions { camera, library }

class AddAquabuildrFishPage extends StatefulWidget {
  final bool isFishUpdate;
  final AquabuildrFishViewModel aquabuildrFish;
  final Function onFishChanged;

  const AddAquabuildrFishPage({Key key, this.isFishUpdate, this.aquabuildrFish, this.onFishChanged})
      : super(key: key);

  @override
  _AddAquabuildrFishPage createState() => _AddAquabuildrFishPage(
      isFishUpdate: this.isFishUpdate, aquabuildrFish: this.aquabuildrFish);
}

class _AddAquabuildrFishPage extends State<AddAquabuildrFishPage> {
  bool isFishUpdate;
  AquabuildrFishViewModel aquabuildrFish;
  _AddAquabuildrFishPage({this.isFishUpdate, this.aquabuildrFish});

  File _image;
  final _formKey = GlobalKey<FormState>();

  AddAquabuildrFishViewModel _addAquabuildrFishVM;

  final _speciesController = TextEditingController();
  final _minimumTankSizeController = TextEditingController();
  final _adultSizeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _feedController = TextEditingController();

  String _aquariumType = "Freshwater";
  String _prefNoPerTank = "1";
  String _activityLevel = "Moderate";
  String _prefSwimDepth = "Mid";
  String _temperament = "Semi-aggressive";
  String _cycleSpecies = "Yes";

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (aquabuildrFish != null) {
      //Textfields
      _speciesController.text = aquabuildrFish.species;
      _minimumTankSizeController.text =
          aquabuildrFish.minimumTankSize.toString();
      _adultSizeController.text = aquabuildrFish.adultSize.toString();
      _descriptionController.text = aquabuildrFish.description;
      _feedController.text = aquabuildrFish.feed;

      //Dropdowns
      _aquariumType = aquabuildrFish.aquariumType;

      _prefNoPerTank = aquabuildrFish.preferredNoPerTankPred;

      print("_prefNoPerTank = " + _prefNoPerTank);

        if (_prefNoPerTank == "1#######") {
          print("it's 1");
          _prefNoPerTank = prefNoInTankList[0];
        } else if (_prefNoPerTank == "1###+####") {
          _prefNoPerTank = prefNoInTankList[1];
        } else if (_prefNoPerTank == "2###+####") {
          _prefNoPerTank = prefNoInTankList[2];
        }
        
         else if (_prefNoPerTank == "2###+#pairs##especial#1:1") {
          _prefNoPerTank = prefNoInTankList[3];
        } else if (_prefNoPerTank == "3###+#pairs#1#especial#1:0") {
          _prefNoPerTank = prefNoInTankList[4];          
        } else if (_prefNoPerTank == "1#-#4##pairs#1#especial#1:0") {
          _prefNoPerTank = prefNoInTankList[5];
        }
        
         else if (_prefNoPerTank == "1#######") {
          _prefNoPerTank = prefNoInTankList[6];
          //prefNoPerTankString = "1 or mated pair";
        } else if (_prefNoPerTank == "6###+####") {
          _prefNoPerTank = prefNoInTankList[7];
          //prefNoPerTankString = "6+";
        } else if (_prefNoPerTank == "6###+#pairs#1#especial#1:0") {
          _prefNoPerTank = prefNoInTankList[8];//"";
          
          //prefNoPerTankString = "1 male and up to 6 females";
        } 
        
        
        else if (_prefNoPerTank == "8###+####") {
          _prefNoPerTank = prefNoInTankList[9];
          //prefNoPerTankString = "8+";
        } else if (_prefNoPerTank == "10###+####") {
          _prefNoPerTank = prefNoInTankList[10];
          //prefNoPerTankString = "10+";
        } else if (_prefNoPerTank == "1#-#2##pairs###1:1") {
          _prefNoPerTank = prefNoInTankList[11];
          //prefNoPerTankString = "1-2 Pairs (M/F)";
        } 
        
        else if (_prefNoPerTank == "1#-#2#+#pairs##especial#1:1") {
          _prefNoPerTank = prefNoInTankList[12];
          //prefNoPerTankString = "1-2+ pairs (M/F)";
        } else if (_prefNoPerTank == "6###+#pairs##especial#1:2") {
          _prefNoPerTank = prefNoInTankList[13];
          //prefNoPerTankString = "6+ (1M-2F)";
        } else if (_prefNoPerTank == "1#-#2#####") {
          _prefNoPerTank = prefNoInTankList[14];
          //prefNoPerTankString = "1-2";
        } 
        
        
        else {
          _prefNoPerTank = prefNoInTankList[0];
          //prefNoPerTankString = "NA";
        }

      //_prefNoPerTank = aquabuildrFish.preferredNoPerTankString;
      
      
      
      _activityLevel = aquabuildrFish.activityLevel;
      _prefSwimDepth = aquabuildrFish.preferredSwimDepth;
      _temperament = aquabuildrFish.temperament;

      //print("_CycleSpecies = " + _cycleSpecies);
      _cycleSpecies = aquabuildrFish.cyclerSpecies;
      //print("_CycleSpecies = " + _cycleSpecies);

      //sliders
      List<String> phvalues = aquabuildrFish.pHValue.split('-');
      _lowerpHValue = double.parse(phvalues[0]);
      _upperpHValue = double.parse(phvalues[1]);
      // print("phvalue L = " + _lowerpHValue.toString());
      // print("phvalue U = " + _upperpHValue.toString());

      List<String> celsiusTemprs = aquabuildrFish.celsiusTemperature.split('-');
      _lowerTemprValue = double.parse(celsiusTemprs[0]);
      _upperTemprValue = double.parse(celsiusTemprs[1]);

      //  print("tempr L = " + _lowerTemprValue.toString());
      // print("tempr U = " + _upperTemprValue.toString());

    } else {
      _aquariumType = "Freshwater";
      _prefNoPerTank = "1";
      _activityLevel = "Moderate";
      _temperament = "Semi-aggressive";
      _cycleSpecies = "Yes";

      _lowerpHValue = 6.0;
      _upperpHValue = 7.0;

      _lowerTemprValue = 16.0;
      _upperTemprValue = 22.0;
    }
  }

  void _selectPhotoFromPhotoLibrary() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(
        source: ImageSource.gallery, maxHeight: 300, maxWidth: 400);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  void _selectPhotoFromCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(
        source: ImageSource.camera, maxHeight: 600, maxWidth: 900);

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

  Future<skia.Image> resizeImage(String path, {int width, int height}) async {
    Uint8List data = await File(path).readAsBytes();

    final codec = await skia.instantiateImageCodec(data,
        targetWidth: width, targetHeight: height);
    final frame = await codec.getNextFrame();
    return frame.image;
  }

  void _saveAquabuildrFish(BuildContext context) async {
    //final userId = FirebaseAuth.instance.currentUser.uid;

    // validate the form
    if (_formKey.currentState.validate()) {
      //upload the photo to firebase storage

      String filePath_Full;
      if (_image != null) {
        filePath_Full = await _addAquabuildrFishVM.uploadFile(_image);
        print(filePath_Full);
      } else {
        filePath_Full = aquabuildrFish.photoURL;
      }

      //File _image_thumbnail = await resizeImage(_image);
      String prefNoPerTankString = "NA";
      if (filePath_Full.isNotEmpty) {
        String celsiusTemp =
            _lowerTemprValue.toString() + "-" + _upperTemprValue.toString();

        final aquariumType = _aquariumType; //_aquariumTypeController.text;
        final species = _speciesController.text;



        String gender;

        print("pref no in tank = " + _prefNoPerTank);
        //ToDo calculate
        if (_prefNoPerTank == prefNoInTankList[0]) {
          _prefNoPerTank = "1#######";
          prefNoPerTankString = "1";
          gender = "";
        } else if (_prefNoPerTank == prefNoInTankList[1]) {
          _prefNoPerTank = "1###+####";
          prefNoPerTankString = "1+";
          gender = "";
        } else if (_prefNoPerTank == prefNoInTankList[2]) {
          _prefNoPerTank = "2###+####";
          prefNoPerTankString = "2+";
          gender = "";
        }
        
         else if (_prefNoPerTank == prefNoInTankList[3]) {
          _prefNoPerTank = "2###+#pairs##especial#1:1";
          prefNoPerTankString = "2+(1 male, 1 female)";
          gender = "male";
        } else if (_prefNoPerTank == prefNoInTankList[4]) {
          _prefNoPerTank = "3###+#pairs#1#especial#1:0";
          prefNoPerTankString = "3+(only 1 male)";
          gender = "male";
        } else if (_prefNoPerTank == prefNoInTankList[5]) {
          _prefNoPerTank = "1#-#4##pairs#1#especial#1:0";
          prefNoPerTankString = "1-4 (1 male)";
          gender = "male";
        }
        
         else if (_prefNoPerTank == prefNoInTankList[6]) {
          _prefNoPerTank = "1#######";
          prefNoPerTankString = "1 or mated pair";
          gender = "";
        } else if (_prefNoPerTank == prefNoInTankList[7]) {
          _prefNoPerTank = "6###+####";
          prefNoPerTankString = "6+";
          gender = "";
        } else if (_prefNoPerTank == prefNoInTankList[8]) {
          _prefNoPerTank = "6###+#pairs#1#especial#1:0";
          prefNoPerTankString = "1 male and up to 6 females";
          gender = "male";
        } 
        
        
        else if (_prefNoPerTank == prefNoInTankList[9]) {
          _prefNoPerTank = "8###+####";
          prefNoPerTankString = "8+";
          gender = "";
        } else if (_prefNoPerTank == prefNoInTankList[10]) {
          _prefNoPerTank = "10###+####";
          prefNoPerTankString = "10+";
          gender = "";
        } else if (_prefNoPerTank == prefNoInTankList[11]) {
          _prefNoPerTank = "1#-#2##pairs###1:1";
          prefNoPerTankString = "1-2 Pairs (M/F)";
          gender = "male";
        } 
        
        else if (_prefNoPerTank == prefNoInTankList[12]) {
          _prefNoPerTank = "1#-#2#+#pairs##especial#1:1";
          prefNoPerTankString = "1-2+ pairs (M/F)";
          gender = "male";
        } else if (_prefNoPerTank == prefNoInTankList[13]) {
          _prefNoPerTank = "6###+#pairs##especial#1:2";
          prefNoPerTankString = "6+ (1M-2F)";
          gender = "male";
        } else if (_prefNoPerTank == prefNoInTankList[14]) {
          _prefNoPerTank = "1#-#2#####";
          prefNoPerTankString = "1-2";
          gender = "";
        } 
        
        
        else {
          _prefNoPerTank = "1#######";
          prefNoPerTankString = "NA";
          gender = "";
        }

        print("pref no in tank (logic) = " + _prefNoPerTank);

        final prefNoPerTank = _prefNoPerTank; //_prefNoPerTankController.text;

        final minimumTankSize = int.parse(_minimumTankSizeController.text);

        final activityLevel = _activityLevel; //_activityLevelController.text;
        final prefSwimDepth = _prefSwimDepth; //_prefSwimDepthController.text;
        final adultSize = int.parse(_adultSizeController.text);
        final temperament = _temperament; //_temperamentController.text;
        final description = _descriptionController.text;
        final feed = _feedController.text;
        final cycleSpecies = _cycleSpecies; //_cycleSpeciesController.text;

        print("TESTING.... added values to db");
        print("Celsius temp = " + celsiusTemp);

        double lower_fahrenheit = ((_lowerTemprValue * 9) / 5) + 32;
        double upper_fahrenheit = ((_upperTemprValue * 9) / 5) + 32;

        String farenheitTemp =
            lower_fahrenheit.toString() + "-" + upper_fahrenheit.toString();
        print("Farenheit temp = " + farenheitTemp);
        final prefTempr = farenheitTemp;

        String phval =
            _lowerpHValue.toString() + "-" + _upperpHValue.toString();
        print("pHvalue = " + phval);

        final prefPh = phval;

        print("temperament = " + temperament);
        print("prefNoPerTank = " + prefNoPerTank);
        print("aquariumType = " + aquariumType);
        print("Activity level = " + activityLevel);
        print("Pref swim depth = " + prefSwimDepth);

        //save the aquabuildr to firestore database
        final _aquabuildrFishVS = AquabuildrFishViewState(
          description: description,
          aquariumType: aquariumType,
          species: species,
          gender: gender,//todo
          price: 12.5,
          experienceLevel: "beginner",
          quantity: 20,
          discount: 0,
          celsiusTemperature: celsiusTemp,
          celsiusTempL: _lowerTemprValue,
          celsiusTempU: _upperTemprValue,
          farenheitTemperature: farenheitTemp,
          pHValue: prefPh,
          pHValueL: _lowerpHValue,
          pHValueU: _upperpHValue,
          temperament: temperament,
          minimumTankSize: minimumTankSize,
          adultSize: adultSize,
          activityLevel: activityLevel,
          preferredPlants: "Plant",
          preferredTankFloor: "Sea",
          preferredSwimDepth: prefSwimDepth,
          preferredNoPerTankPred: prefNoPerTank,
          preferredNoPerTankString: prefNoPerTankString,
          preferredTypes: "Aqua",
          cyclerSpecies: cycleSpecies,
          photoURL: filePath_Full,
          feed: feed,
          reference: isFishUpdate ? aquabuildrFish.reference : null,
        );

        if (isFishUpdate) {
          final isUpdate = await _addAquabuildrFishVM
              .updateAquabuildrFish(_aquabuildrFishVS);

          if (isUpdate) {
            Navigator.pop(context, true);
          }
        } else {
          final isSaved =
              await _addAquabuildrFishVM.saveAquabuildrFish(_aquabuildrFishVS);

          if (isSaved) {
            Navigator.pop(context, true);
          }
        }
      }
    }
  }

  Widget _buildLoadingWidget() {
    return Text("Loading...");
  }

  // double _lowValue = 10.0;
  // double _highValue = 50.0;

  RangeValues _currentRangeValues = const RangeValues(40, 80);

  double _lowerTemprValue = 18.0;
  double _upperTemprValue = 22.0;

  double _lowerpHValue = 6.0;
  double _upperpHValue = 8.0;

  customHandler(IconData icon) {
    return FlutterSliderHandler(
      decoration: BoxDecoration(),
      child: Container(
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.3), shape: BoxShape.circle),
          child: Icon(
            icon,
            color: Colors.white,
            size: 23,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                spreadRadius: 0.05,
                blurRadius: 5,
                offset: Offset(0, 1))
          ],
        ),
      ),
    );
  }

  Widget _buildHatchLabel(String lbl) {
    return Text(
      lbl,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildRangeSlider() {
    return RangeSlider(
      values: _currentRangeValues,
      min: 0,
      max: 100,
      divisions: 100,
      labels: RangeLabels(
        _currentRangeValues.start.round().toString(),
        _currentRangeValues.end.round().toString(),
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _currentRangeValues = values;
        });
      },
    );
  }

  Widget buildSlider(BuildContext context) => SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.blue[100],
        inactiveTrackColor: Colors.blue[100],
        trackShape: RoundedRectSliderTrackShape(),
        trackHeight: 4.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 24.0),
        thumbColor: Colors.lightBlue,
        overlayColor: Colors.blue.withAlpha(32),
        // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
        tickMarkShape: RoundSliderTickMarkShape(tickMarkRadius: 6),
        activeTickMarkColor: Colors.blue[100],
        inactiveTickMarkColor: Colors.blue[100],
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: Colors.redAccent,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [buildSliderTopLabel(context)],
      ));

  Widget buildSliderTopLabel(BuildContext context) {
    final labels = ['10', '30', '50', '80', '120', '180'];
    //final labels = ['30', '50', '80', '120', '180'];

    final double min = 0;
    final double max = labels.length - 1.0;
    final divisions = labels.length - 1;

    final provider = Provider.of<NavigationProvider>(context, listen: true);

    return Column(children: [
      Container(
        //color: Colors.green.shade300,
        // margin: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: Utils.modelBuilder(labels, (index, label) {
              final selectedColor = Colors.black;
              final unselectedColor = Colors.black.withOpacity(0.3);
              final isSelected = index <= provider.indexTop;
              final color =
                  selectedColor; //isSelected ? selectedColor : unselectedColor;

              return buildLabel(label: label, color: color, width: 46); //54
            }) //[],
            ),
      ),
      Slider(
          //value: Global.userAquariumSize.toDouble(),//provider.indexTop.toDouble(),
          value: provider.indexTop.toDouble(),
          min: min,
          max: max,
          divisions: divisions,
          onChanged: (val) {
            //Global.userAquariumSize = val.toInt();
            //_starterAquariumItemListVM.updateUserAquariumSize(val.toInt());
            //provider.updateIndexTop(val.toInt());
          })
    ]);
  }

  Widget buildLabel({
    @required String label,
    @required double width,
    @required Color color,
  }) =>
      Container(
        width: width,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ).copyWith(color: color),
        ),
      );

  @override
  Widget build(BuildContext context) {
    _addAquabuildrFishVM = Provider.of<AddAquabuildrFishViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
                    backgroundColor: PrimaryColorBlue,

          title:
              isFishUpdate ? Text("Update Fish") : Text("Add Aquabuildr Fish"),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: [
                //Fish Image
                !isFishUpdate
                    ? SizedBox(
                        child: _image == null
                            ? Image.asset("assets/images/fishbg.png")
                            : Image.asset(_image.path),
                        height: 250)
                    : SizedBox(
                        child: _image == null
                            ? CachedNetworkImage(
                                imageUrl: aquabuildrFish.photoURL,
                                fit: BoxFit.scaleDown)
                            : Image.asset(_image.path),
                        height: 250),

                //Image Select Button
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: FlatButton(
                    color: Colors.blue,
                    height: 48,
                    minWidth: MediaQuery.of(context).size.width - 140,
                    onPressed: () {},
                    textColor: Colors.white,
                    child: PopupMenuButton<PhotoOptions>(
                      child: Text(
                          isFishUpdate
                              ? "Choose New Fish Image"
                              : "Add New Fish Image",
                          style: TextStyle(fontSize: 18)),
                      onSelected: _optionSelected,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text("Take a picture"),
                          value: PhotoOptions.camera,
                        ),
                        PopupMenuItem(
                            child: Text("Select from photo library"),
                            value: PhotoOptions.library)
                      ],
                    ),
                  ),
                ),

                //Aquarium Type
                SizedBox(height: 40),
                // _buildDropDownList(context, "Aquarium Type : ", _aquariumType,
                //     DropDownType.AQUARIUM_TYPE, aquariumTypeList),

                DropDownList(
                    aquariumTypeList, "Aquarium Type : ", _aquariumType,
                    (itemSelected) {
                  _aquariumType = itemSelected;
                  print("Add page - selected item = " + _aquariumType);
                  setState(() {});
                }),

                //Species
                SizedBox(height: 20),
                
                TextFormField(
                  controller: _speciesController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Fish name is required!";
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: "Fish Name",
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      hintText: "Enter fish name"),
                ),

                //Description
                SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
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

                //Preferred No.
                SizedBox(height: 20),
                DropDownList(
                    prefNoInTankList, "Preferred No. : ", _prefNoPerTank,
                    (itemSelected) {
                  _prefNoPerTank = itemSelected;
                  print("Add page - selected item prefno = " + _prefNoPerTank);
                  setState(() {});
                }),

                // _buildDropDownList(context, "Preferred No. : ", _prefNoPerTank,
                //     DropDownType.PREF_NO_IN_TANK, prefNoInTankList),

                //Min Tank Size
                SizedBox(height: 20),
                TextFormField(
                  controller: _minimumTankSizeController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Min tank size is required!";
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: "Minimum Tank Size",
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      hintText: "Enter minimum tank size in gallons!"),
                ),

                SizedBox(height: 20),
                // _buildDropDownList(context, "Activity Level : ", _activityLevel,
                //     DropDownType.ACTIVITY_LEVEL, activityLevelList),

                DropDownList(
                    activityLevelList, "Activity Level : ", _activityLevel,
                    (itemSelected) {
                  _activityLevel = itemSelected;
                  print("Add page - selected item prefno = " + _activityLevel);
                  setState(() {});
                }),

                SizedBox(height: 20),
                // _buildDropDownList(
                //     context,
                //     "Pref. Swim Depth : ",
                //     _prefSwimDepth,
                //     DropDownType.PREF_SWIM_DEPTH,
                //     prefSwimDepthList),

                DropDownList(
                    prefSwimDepthList, "Pref. Swim Depth : ", _prefSwimDepth,
                    (itemSelected) {
                  _prefSwimDepth = itemSelected;
                  print("Add page - selected item prefno = " + _prefSwimDepth);
                  setState(() {});
                }),

                //Adult Size
                SizedBox(height: 20),
                TextFormField(
                  controller: _adultSizeController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Adult size is required!";
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: "Adult Size",
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      hintText: "Enter adult size!"),
                ),

                //preferred pH
                SizedBox(height: 20),
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

                //_buildpHSlider(context),
                ABSlider(phHatchLabelList, phMin, phMax, _lowerpHValue, _upperpHValue,
                    (sliderLowerVal, sliderUpperVal) {
                  // print("pH -> sliderUpperVal = " + sliderUpperVal.toString());
                  // print("pH -> sliderLowerVal = " + sliderLowerVal.toString());
                  _lowerpHValue = sliderLowerVal;
                  _upperpHValue = sliderUpperVal;

                }),

                //pref Temperature
                SizedBox(height: 20),
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

                //Temperament
                SizedBox(height: 20),
                // _buildDropDownList(context, "Temperament : ", _temperament,
                //     DropDownType.TEMPERAMENT, temperamentList),

                DropDownList(temperamentList, "Temperament : ", _temperament,
                    (itemSelected) {
                  _temperament = itemSelected;
                  print("Add page - selected item prefno = " + _temperament);
                  setState(() {});
                }),

                //Feed
                SizedBox(height: 20),
                TextFormField(
                  controller: _feedController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Feed is required!";
                    }
                    return null;
                  },
                  maxLines: null,
                  decoration: InputDecoration(
                      labelText: "Feed",
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      hintText: "Enter feed!"),
                ),

                //Cycler species
                SizedBox(height: 20),
                // _buildDropDownList(context, "Cycler Species : ", _cycleSpecies,
                //     DropDownType.TEMPERAMENT, cyclerList),

                DropDownList(cyclerList, "Cycler Species : ", _cycleSpecies,
                    (itemSelected) {
                  _cycleSpecies = itemSelected;
                  print("Add page - selected item prefno = " + _cycleSpecies);
                  setState(() {});
                }),

                //SUBMIT BUTTON
                SizedBox(height: 40),
                // isLoading ? new PrimaryButton(
                //       key: new Key('login'),
                //       text: 'Login',
                //       height: 44.0,
                //       onPressed: setState((){isLoading = true;}))
                //   : Center(
                //       child: CircularProgressIndicator(),
                //     ),

                !isLoading 
                ?
                FlatButton(
                  height: 46,
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    isFishUpdate ? "UPDATE" : "SUBMIT",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {

                    setState((){isLoading = true;});

                    FocusScope.of(context).requestFocus(FocusNode());
                    _saveAquabuildrFish(context);
                  },
                  color: Colors.blue,
                  textColor: Colors.white,
                )
                :
                Center(
                      child: CircularProgressIndicator(),
                    ),

                SizedBox(height: 40),
              ]),
            ),
          ),
        ));
  }

  Widget _buildTemperatureSlider(BuildContext cxt) {
    return (Column(children: [
      Container(
        // color: Colors.yellow.shade200,
        alignment: Alignment.center,
        height: 100,
        width: Size.infinite.width,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: FlutterSlider(
          tooltip: FlutterSliderTooltip(
              alwaysShowTooltip: true,
              boxStyle: FlutterSliderTooltipBox(
                  decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(20),
              )),
              textStyle: TextStyle(color: Colors.white)),
          handlerWidth: 15,
          axis: Axis.horizontal,
          hatchMark: FlutterSliderHatchMark(
            labelsDistanceFromTrackBar: 80,
            displayLines: true,
            density: 0.1,
            linesDistanceFromTrackBar: 10,
            labels: [
              FlutterSliderHatchMarkLabel(
                  percent: 0, label: _buildHatchLabel('10')),
              FlutterSliderHatchMarkLabel(
                  percent: 20, label: _buildHatchLabel('16')),
              FlutterSliderHatchMarkLabel(
                  percent: 40, label: _buildHatchLabel('22')),
              FlutterSliderHatchMarkLabel(
                  percent: 60, label: _buildHatchLabel('28')),
              FlutterSliderHatchMarkLabel(
                  percent: 80, label: _buildHatchLabel('34')),
              FlutterSliderHatchMarkLabel(
                  percent: 100, label: _buildHatchLabel('40')),
            ],
          ),
          jump: true,
          trackBar: FlutterSliderTrackBar(),
          handler: FlutterSliderHandler(
            decoration: BoxDecoration(),
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          rightHandler: FlutterSliderHandler(
            decoration: BoxDecoration(),
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          values: [_lowerTemprValue, _upperTemprValue],
          // visibleTouchArea: true,
          min: 10,
          max: 80,
          touchSize: 15,
          rangeSlider: true,
          step: FlutterSliderStep(step: 1),
          onDragging: (handlerIndex, lowerValue, upperValue) {
            print("lower value = " + lowerValue.toString());
            print("upper value = " + upperValue.toString());
            _lowerTemprValue = lowerValue;
            _upperTemprValue = upperValue;
          },
        ),
      ),
      // SizedBox(
      //   height: 50,
      // ),
      // Text('Lower Temp: ' + _lowerValue.toString()),
      // SizedBox(height: 25),
      // Text('Upper Temp: ' + _upperValue.toString()),
    ]));
  }

  Widget _buildpHSlider(BuildContext cxt) {
    return (Column(children: [
      Container(
        //color: Colors.yellow.shade200,
        alignment: Alignment.center,
        height: 100,
        width: Size.infinite.width,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: FlutterSlider(
          tooltip: FlutterSliderTooltip(
              alwaysShowTooltip: true,
              boxStyle: FlutterSliderTooltipBox(
                  decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(20),
              )),
              textStyle: TextStyle(color: Colors.white)),
          handlerWidth: 15,
          axis: Axis.horizontal,
          hatchMark: FlutterSliderHatchMark(
            labelsDistanceFromTrackBar: 80,
            displayLines: true,
            density: 0.1,
            linesDistanceFromTrackBar: 10,
            labels: [
              FlutterSliderHatchMarkLabel(
                  percent: 0, label: _buildHatchLabel('4')),
              FlutterSliderHatchMarkLabel(
                  percent: 20, label: _buildHatchLabel('6')),
              FlutterSliderHatchMarkLabel(
                  percent: 40, label: _buildHatchLabel('8')),
              FlutterSliderHatchMarkLabel(
                  percent: 60, label: _buildHatchLabel('10')),
              FlutterSliderHatchMarkLabel(
                  percent: 80, label: _buildHatchLabel('12')),
              FlutterSliderHatchMarkLabel(
                  percent: 100, label: _buildHatchLabel('14')),
            ],
          ),
          jump: true,
          trackBar: FlutterSliderTrackBar(),
          handler: FlutterSliderHandler(
            decoration: BoxDecoration(),
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          rightHandler: FlutterSliderHandler(
            decoration: BoxDecoration(),
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
          ),
          values: [_lowerpHValue, _upperpHValue],
          // visibleTouchArea: true,
          min: 0,
          max: 14,
          touchSize: 15,
          rangeSlider: true,
          step: FlutterSliderStep(step: 0.1),
          onDragging: (handlerIndex, lowerValue, upperValue) {
            print("pH lower value = " + lowerValue.toString());
            print("pH upper value = " + upperValue.toString());

            _lowerpHValue = lowerValue;
            _upperpHValue = upperValue;
          },
        ),
      ),
      // SizedBox(
      //   height: 50,
      // ),
      // Text('Lower pH: ' + _lowerValue.toString()),
      // SizedBox(height: 25),
      // Text('Upper pH: ' + _upperValue.toString()),
    ]));
  }

  // Widget showSpeciesName(BuildContext cxt) {
  //   return Container(
  //     width: 200,
  //     height: 100,
  //     color: Colors.red,
  //     child: Row(
  //       children: [
  //         TextFormField(
  //           controller: _aquariumTypeController,
  //           validator: (value) {
  //             if (value.isEmpty) {
  //               return "Title is required!";
  //             }
  //             return null;
  //           },
  //           decoration: InputDecoration(hintText: "Enter aquarium type"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  List<String> _dropDownItemList;
  String _dropDownitemSelected;

  Widget _buildDropDownList(
      BuildContext cxt,
      String dropDownTitle,
      String dropDownDefaultItem,
      DropDownType dropDownType,
      List<String> listitems) {
    _dropDownItemList = listitems;

    return Row(
      children: [
        Row(
          children: [
            Text(
              dropDownTitle,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
                //alignment: Alignment.centerRight,
                color: Colors.grey.shade200,
                width: 130,
                height: 44,
                child: Container(
                  alignment: Alignment.center,
                  child: DropdownButton(
                    hint: Text(
                      dropDownDefaultItem,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    value: _dropDownitemSelected,
                    onChanged: (newValue) {
                      setState(() {
                        print("_dropDownitemSelected = " + newValue);

                        _dropDownitemSelected = newValue;
                        if (dropDownType == DropDownType.AQUARIUM_TYPE) {
                          //_aquariumTypeController.text = newValue;
                          _aquariumType = newValue;
                        } else if (dropDownType ==
                            DropDownType.PREF_NO_IN_TANK) {
                          //_prefNoPerTankController.text = newValue;
                          _prefNoPerTank = newValue;
                        } else if (dropDownType ==
                            DropDownType.ACTIVITY_LEVEL) {
                          //_activityLevelController.text = newValue;
                          _activityLevel = newValue;
                          // }
                          // else if (dropDownType == DropDownType.PREF_PH) {
                          //   _prefPhController.text = newValue;
                          // } else if (dropDownType == DropDownType.PREF_TEMPR) {
                          //   _prefTempController.text = newValue;

                        } else if (dropDownType ==
                            DropDownType.PREF_SWIM_DEPTH) {
                          //_prefSwimDepthController.text = newValue;
                          _prefSwimDepth = newValue;
                        } else if (dropDownType ==
                            DropDownType.CYCLER_SPECIES) {
                          //_cycleSpeciesController.text = newValue;
                          _cycleSpecies = newValue;
                        } else {
                          print("NA");
                        }
                      });
                    },
                    items: _dropDownItemList.map((item) {
                      print(item);
                      return DropdownMenuItem(
                        child: new Text(
                          item,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        value: item,
                      );
                    }).toList(),
                  ),
                )),
          ],
        ),
      ],
    );
  }
}
