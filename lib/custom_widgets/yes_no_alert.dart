import 'package:flutter/material.dart';

class YesNoAlert extends StatelessWidget {
  YesNoAlert({required this.message, required this.yesAction, required this.noAction});

  final String message;
  final VoidCallback yesAction;
  final VoidCallback noAction;

  @override
  Widget build(BuildContext context) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text('Uwaga', style: TextStyle(fontSize: 3 * unitHeightValue)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message, style: TextStyle(fontSize: 2.5 * unitHeightValue)),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            noAction();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text(
            'Nie',
            style: TextStyle(fontSize: 2.5 * unitHeightValue),
          ),
        ),
        MaterialButton(
          onPressed: () {
            yesAction();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text(
            'Tak',
            style: TextStyle(fontSize: 2.5 * unitHeightValue),
          ),
        ),
      ],
    );
  }
}
