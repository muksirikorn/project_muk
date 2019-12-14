import 'package:flutter/material.dart';

class DeletePage extends StatefulWidget {
  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  @override
  Widget build(BuildContext context) {
    Container(
      height: 50,
      width: double.infinity,
      child: RaisedButton(
        color: Color(0xFFD56343),
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5),
        ),
        child: Text(
          "ลบข้อมูล",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: () {},
      ),
    );
  }
}
