import 'package:flutter/material.dart';

class CustomSimpleDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPress;

  const CustomSimpleDialog({
    @required this.title,
    @required this.content,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        FlatButton(
          child: Text("ok"),
          onPressed: onPress,
        )
      ],
    );
  }
}
