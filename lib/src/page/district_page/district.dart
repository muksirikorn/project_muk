import 'package:flutter/material.dart';
import 'package:project_muk/src/mode_view/province_model_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_muk/src/page/name_shop_page/nameshop.dart';

import 'package:project_muk/src/utils/constant.dart';

class DistrictPage extends StatefulWidget {

  DistrictPage({Key key,
  this.provinceName,
  this.provinceId
  }) :super(key: key);

  final String provinceName;
  final String provinceId;

  @override
  _DistrictPageState createState() => _DistrictPageState();
}

class _DistrictPageState extends State<DistrictPage> {
  ProvinceViewModel menuItem;
  @override
  void initState() {
    // TODO: implement initSt
    menuItem = ProvinceViewModel();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.BK_COLOR,
      appBar: AppBar(
        backgroundColor: Constant.ORANGE_COLOR,
        centerTitle: true,
        title: Text(widget.provinceName),

      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('districts').where('province_id' , isEqualTo: widget.provinceId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return Center(child: new Text('Loading...',style: TextStyle(color: Colors.white)));
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['name'],style: TextStyle(color: Colors.white),),
                  trailing: Icon(Icons.keyboard_arrow_right,color: Colors.white,),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NameShopPage(
                              provinceName: document['name'],
                              provinceId: document.documentID)),
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
