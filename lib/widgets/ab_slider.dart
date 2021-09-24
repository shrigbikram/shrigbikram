import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class ABSlider extends StatelessWidget {

  final List<String> _hatchLabelList;
  final double _sliderMin;
  final double _sliderMax;

  final _lowerSliderValueInitial;
  final _upperSliderValueInitial;

  final Function(double, double) onDropDownItemSelected;

  ABSlider(this._hatchLabelList, this._sliderMin,
      this._sliderMax, this._lowerSliderValueInitial, this._upperSliderValueInitial,this.onDropDownItemSelected);

  double _lowerSliderValue = 4;
  double _upperSliderValue = 6;
  @override
  Widget build(BuildContext context) {

     _lowerSliderValue = _lowerSliderValueInitial;
     _upperSliderValue = _upperSliderValueInitial;

    return (Column(children: [
      Container(
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
                  percent: 0, label: _buildHatchLabel(_hatchLabelList[0])),
              FlutterSliderHatchMarkLabel(
                  percent: 20, label: _buildHatchLabel(_hatchLabelList[1])),
              FlutterSliderHatchMarkLabel(
                  percent: 40, label: _buildHatchLabel(_hatchLabelList[2])),
              FlutterSliderHatchMarkLabel(
                  percent: 60, label: _buildHatchLabel(_hatchLabelList[3])),
              FlutterSliderHatchMarkLabel(
                  percent: 80, label: _buildHatchLabel(_hatchLabelList[4])),
              FlutterSliderHatchMarkLabel(
                  percent: 100, label: _buildHatchLabel(_hatchLabelList[5])),
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
          values: [_lowerSliderValue, _upperSliderValue],
          // visibleTouchArea: true,
          min: _sliderMin,
          max: _sliderMax,
          touchSize: 15,
          rangeSlider: true,
          step: FlutterSliderStep(step: 0.1),
          onDragging: (handlerIndex, lowerValue, upperValue) {
            print("lower value in X = " + lowerValue.toString());
            print("upper value in X = " + upperValue.toString());
            _lowerSliderValue = lowerValue;
            _upperSliderValue = upperValue;

            onDropDownItemSelected(_lowerSliderValue, _upperSliderValue);
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

  Widget _buildHatchLabel(String lbl) {
    return Text(
      lbl,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    );
  }


}
