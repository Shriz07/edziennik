import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

Widget panelTitle(title, context) {
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  return Padding(
    padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 15.0, bottom: 15.0),
    child: Container(
      width: double.infinity,
      height: 4 * MediaQuery.of(context).size.height * 1 / 40,
      child: Center(
          child: Text(
        title,
        style: TextStyle(fontSize: 3.0 * unitHeightValue, fontWeight: FontWeight.bold, color: Colors.black),
      )),
      decoration: BoxDecoration(
        color: MyColors.greenAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
    ),
  );
}

Widget panelOption(text, action, context) {
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  return Padding(
    padding: const EdgeInsets.only(left: 70.0, right: 70.0, top: 30.0),
    child: InkWell(
      child: Container(
        width: double.infinity,
        height: 4 * MediaQuery.of(context).size.height * 1 / 40,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 3.0 * unitHeightValue, color: Colors.white),
          ),
        )),
        decoration: BoxDecoration(
          color: MyColors.dodgerBlue,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
      ),
      onTap: action,
    ),
  );
}

Widget teacherOption(text, action, context) {
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  return Padding(
    padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 15.0),
    child: InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width * 3 / 4,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 3 * unitHeightValue, color: Colors.white),
          ),
        )),
        decoration: BoxDecoration(
          color: MyColors.dodgerBlue,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
      ),
      onTap: action,
    ),
  );
}

Widget formFieldTitle(title, context) {
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  return Text(
    title,
    textAlign: TextAlign.left,
    style: TextStyle(fontSize: 2.5 * unitHeightValue, fontWeight: FontWeight.bold),
  );
}

Widget singleTableCell(info, bottomBorder, context) {
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  return Expanded(
    child: Container(
      child: Center(
        child: Text(
          info,
          style: TextStyle(fontSize: 2.5 * unitHeightValue, fontWeight: FontWeight.bold),
        ),
      ),
      decoration: bottomBorder == true
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            )
          : null,
    ),
  );
}

Widget customFormField(controller, hintText, fnode, context) {
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: TextFormField(
      controller: controller,
      focusNode: fnode,
      style: TextStyle(fontSize: 2.5 * unitHeightValue),
      decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: Colors.black, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(color: MyColors.carrotOrange, width: 2.0),
          ),
          hintStyle: TextStyle(fontSize: 2.5 * unitHeightValue)),
    ),
  );
}

Widget bottomOptionsMenu(context, listOfIconsWithActions) {
  double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Container(
      height: MediaQuery.of(context).size.height * 1 / 15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 2.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: listOfIconsWithActions,
      ),
    ),
  );
}
