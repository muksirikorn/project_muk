import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_muk/src/page/name_shop_page/nameshop.dart';

import 'package:project_muk/src/utils/constant.dart';

class DistrictPage extends StatefulWidget {
  DistrictPage({Key key, this.provinceName, this.provinceId}) : super(key: key);

  final String provinceName;
  final String provinceId;

  @override
  _DistrictPageState createState() => _DistrictPageState();
}

class _DistrictPageState extends State<DistrictPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.provinceId);
    return Scaffold(
        backgroundColor: Constant.WHITE_COLOR,
        appBar: AppBar(
          backgroundColor: Constant.GREEN_COLOR,
          centerTitle: true,
          title: Text(widget.provinceName),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('districts')
              .where('province_id', isEqualTo: widget.provinceId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                    child: Text('Loading...',
                        style: TextStyle(color: Colors.black)));
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
                            builder: (context) => NameShopPage(
                                  provinceId: widget.provinceId,
                                  provinceName: widget.provinceName,
                                  districtName: document['name'],
                                  districtId: document.documentID,
                                ),
                          ),
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
