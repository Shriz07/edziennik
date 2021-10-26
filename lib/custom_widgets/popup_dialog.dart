import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  PopupDialog({required this.title, required this.message, required this.close});

  final String title;
  final String message;
  final String close;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message,
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text(
            close,
            style: TextStyle(fontSize: 17),
          ),
        ),
      ],
    );
  }
}
