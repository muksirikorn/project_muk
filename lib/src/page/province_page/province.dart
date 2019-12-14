import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../page/district_page/district.dart';
import '../../utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProvincePage extends StatefulWidget {
  @override
  _ProvincePageState createState() => _ProvincePageState();
}

class _ProvincePageState extends State<ProvincePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constant.WHITE_COLOR,
        appBar: AppBar(
          backgroundColor: Constant.GREEN_COLOR,
          centerTitle: true,
          title: Text(
            "เลือกจังหวัด",
            style: TextStyle(fontFamily: "Kanit_Regular"),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('provinces').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  'Loading...',
                  style: TextStyle(color: Colors.black),
                ));
              default:
                return ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return ListTile(
                      title: Text(
                        document['name'],
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DistrictPage(
                                  provinceName: document['name'],
                                  provinceId: document.documentID)),
                        );
                      },
                    );
                  }).toList(),
                );
            }
          },
        ));
  }
}
