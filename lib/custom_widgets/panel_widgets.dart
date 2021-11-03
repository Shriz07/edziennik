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
