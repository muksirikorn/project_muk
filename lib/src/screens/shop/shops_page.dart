import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_muk/src/scoped_models/user.dart';
import 'package:project_muk/src/screens/shop/new_shop_page.dart';
import 'package:project_muk/src/screens/shop/shop_detail.dart';
import 'package:project_muk/src/services/logging_service.dart';
import 'package:project_muk/src/theme/app_themes.dart';
import 'package:scoped_model/scoped_model.dart';

class ShopsPage extends StatefulWidget {
  final String provinceId;

  final String provinceName;
  final String districtName;

  final String districtId;
  ShopsPage({
    Key key,
    this.provinceId,
    this.provinceName,
    this.districtName,
    this.districtId,
  }) : super(key: key);

  @override
  _ShopsPageState createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  final databaseReference = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(
      builder: (BuildContext context, Widget child, User model) {
        return Scaffold(
          backgroundColor: AppTheme.GG_COLOR,
          appBar: AppBar(
            backgroundColor: AppTheme.GREEN_COLOR,
            centerTitle: true,
            title: Text(widget.provinceName),
            actions: <Widget>[checkRole(model.role)],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('store')
                .where('address.districts_id', isEqualTo: widget.districtId)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                  break;
                default:
                  if (snapshot.hasData) {
                    return ListView(
                      children: snapshot.data.documents.map(
                        (DocumentSnapshot document) {
                          return Card(
                            elevation: 8.0,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration:
                                  BoxDecoration(color: AppTheme.WHITE_30_COLOR),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                leading: Container(
                                  padding: EdgeInsets.only(right: 12.0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        width: 1.0,
                                        color: AppTheme.WHITE_24_COLOR,
                                      ),
                                    ),
                                  ),
                                  child: Image.network(
                                    document['images'][0]['src'],
                                  ),
                                ),
                                title: Text(
                                  document['name'],
                                  style: TextStyle(
                                    color: AppTheme.BLACK_COLOR,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Row(
                                  children: <Widget>[
                                    Flexible(
                                      child: Text(
                                        document['description'],
                                        style: TextStyle(
                                          color: AppTheme.BLACK_COLOR,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                trailing: Icon(Icons.keyboard_arrow_right,
                                    color: AppTheme.BLACK_COLOR, size: 30.0),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShopDetailPage(
                                      docID: document.documentID,
                                      documentName: document['name'],
                                      provinceId: widget.provinceId,
                                      districtId: widget.districtId,
                                    ),
                                  ),
                                ),
                                onLongPress: () {
                                  if (model.role == 'ADMIN') {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            'ต้องการลบข้อมูลร้าน?',
                                          ),
                                          content: const Text('ยืนยิน'),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('ยกเลิก'),
                                            ),
                                            FlatButton(
                                              onPressed: () async {
                                                bool done = await _deleteRecord(
                                                  document.documentID,
                                                );
                                                done
                                                    ? Navigator.pop(context)
                                                    : logger
                                                        .e('Fail to delete');
                                              },
                                              child: const Text('ยืนยัน'),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    );
                  } else if (snapshot.hasError) {
                    return Container();
                  }
                  break;
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        );
      },
    );
  }

  Widget checkRole(String role) {
    if (role == 'ADMIN') {
      return IconButton(
        icon: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NewShopPage(
                provinceId: widget.provinceId,
                districtId: widget.districtId,
              );
            },
          ),
        ),
      );
    }
    return Container();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _deleteRecord(String documentId) async {
    bool complete = false;
    try {
      databaseReference.collection('store').document(documentId).delete();
      complete = true;
    } catch (e) {
      logger.e(e.toString());
    }
    return complete;
  }
}
