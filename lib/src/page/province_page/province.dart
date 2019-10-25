import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:project_muk/src/mode_view/province_model_view.dart';
// import 'package:project_muk/src/model/district.dart';
// import 'package:project_muk/src/model/province.dart';
import 'package:project_muk/src/page/district_page/district.dart';

//import 'package:project_muk/src/page/province_page/customCard.dart';
import 'package:project_muk/src/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProvincePage extends StatefulWidget {
  @override
  _ProvincePageState createState() => _ProvincePageState();
}

class _ProvincePageState extends State<ProvincePage> {
//  final databaseReference = Firestore.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Constant.BK_COLOR,
        appBar: AppBar(
          backgroundColor: Constant.ORANGE_COLOR,
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
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: new Text('Loading...',style: TextStyle(color: Colors.white),));
              default:
                return new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return new ListTile(
                      title: new Text(document['name'],style: TextStyle(color: Colors.white),),
                      trailing: Icon(Icons.keyboard_arrow_right,color: Colors.white,),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DistrictPage(
                                  provinceName: document['name'],
                                  provinceId: document.documentID
                              )),
                        );
                      },
                    );

                  }).toList(),
                );
            }
          },
        )
    );
  }
}
