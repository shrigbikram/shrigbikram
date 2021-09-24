import 'package:flutter/material.dart';

class DropDownList extends StatelessWidget {

  final List<String> _dropDownItemList;
  final String _dropDownTitle;   
  final String _dropDownDefaultItem;

  final Function(String) onDropDownItemSelected;

  DropDownList(this._dropDownItemList, this._dropDownTitle, this._dropDownDefaultItem, this.onDropDownItemSelected);
  String _dropDownitemSelected;


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Text(
              _dropDownTitle,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
                color: Colors.grey.shade200,
                width: 180,
                height: 44,
                child: Container(
                  alignment: Alignment.center,
                  child: DropdownButton(
                    hint: Text(
                      _dropDownDefaultItem,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    value: _dropDownitemSelected,
                    onChanged: (newValue) {
                        //print("_dropDownitemSelected = " + newValue);
                        onDropDownItemSelected(newValue);
                    },
                    items: _dropDownItemList.map((item) {
                      //print(item);
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
