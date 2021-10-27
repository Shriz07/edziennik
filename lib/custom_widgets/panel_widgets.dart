import 'package:edziennik/style/MyColors.dart';
import 'package:flutter/material.dart';

Widget panelTitle(title) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Container(
      width: double.infinity,
      height: 60,
      child: Center(
          child: Text(
        title,
        style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold, color: Colors.black),
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

Widget panelOption(text, action) {
  return Padding(
    padding: const EdgeInsets.only(left: 70.0, right: 70.0, top: 30.0),
    child: InkWell(
      child: Container(
        width: double.infinity,
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
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
