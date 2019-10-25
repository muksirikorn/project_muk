import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_muk/src/page/location_detali_page/location_detail.dart';
import 'package:project_muk/src/utils/constant.dart';

class NameShopPage extends StatefulWidget {
  NameShopPage({Key key, this.provinceName, this.provinceId}) : super(key: key);

  final String provinceName;
  final String provinceId;

  @override
  _State createState() => _State();
}

class _State extends State<NameShopPage> {
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
          title: Text(widget.provinceName),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('store')
              .where('address.districts_id', isEqualTo: widget.provinceId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                    child: Text('Loading...',
                        style: TextStyle(color: Colors.white)));
              default:
                return ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return ListTile(
                      leading: Icon(
                        Icons.store_mall_directory,
                        color: Colors.white,
                        size: 30,
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                      ),
                      title: Text(
                        document['name'],
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocationDetailPage(
                                    docID: document.documentID,
                                    documentName: document['name'],
                                  )),
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
