import 'package:flutter/material.dart';

SizedBox buildSizedBox() {
  return SizedBox(
    height: 13,
  );
}

void showProcessingDialog(BuildContext context) async {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        content: Container(
          width: 250.0,
          height: 100.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircularProgressIndicator(),
              const Text(
                "Saving...",
                style: TextStyle(
                  fontFamily: "OpenSans",
                  color: Color(0xFF5B6978),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
