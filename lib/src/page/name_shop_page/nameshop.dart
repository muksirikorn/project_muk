import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_muk/src/page/location_detali_page/location_detail.dart';
import 'package:project_muk/src/utils/constant.dart';
import '../regiter_page/register.dart';

class NameShopPage extends StatefulWidget {
  NameShopPage(
      {Key key,
      this.provinceId,
      this.provinceName,
      this.districtName,
      this.districtId})
      : super(key: key);

  final String provinceId;
  final String provinceName;

  final String districtName;
  final String districtId;

  @override
  _State createState() => _State();
}

class _State extends State<NameShopPage> {
  @override
  void initState() {
    super.initState();
  }

  _dismissDialog() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.provinceId);
    return Scaffold(
        backgroundColor: Constant.BK_COLOR,
        appBar: AppBar(
          backgroundColor: Constant.ORANGE_COLOR,
          centerTitle: true,
          title: Text(widget.provinceName),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RegisterPage(
                    provinceId: widget.provinceId,
                    districtId: widget.districtId,
                  );
                }));
              },
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('store')
              .where('address.districts_id', isEqualTo: widget.districtId)
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
                    return Card(
                      elevation: 8.0,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(64, 75, 96, .9)),
                        child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        right: BorderSide(
                                            width: 1.0,
                                            color: Colors.white24))),
                                child: Image.network(
                                    document['images'][0]['src'])),
                            title: Text(
                              document['name'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                            subtitle: Row(
                              children: <Widget>[
                                Text(document['description'],
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: Colors.white, size: 30.0),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LocationDetailPage(
                                          docID: document.documentID,
                                          documentName: document['name'],
                                          provinceId: widget.provinceId,
                                          districtId: widget.districtId,
                                        )),
                              );
                            },
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Material Dialog'),
                                      content: Text(
                                          'This is the content of the material dialog'),
                                      actions: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              _dismissDialog();
                                            },
                                            child: Text('Close')),
                                        FlatButton(
                                          onPressed: () {
                                            Firestore.instance
                                                .collection('store')
                                                .document(document.documentID)
                                                .delete();
                                            _dismissDialog();
                                          },
                                          child: Text('confirm'),
                                        )
                                      ],
                                    );
                                  });
                            }),
                      ),
                    );
                  }).toList(),
                );
            }
          },
        ));
  }
}
