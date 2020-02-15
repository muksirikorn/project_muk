import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_themes.dart';
import './shop/shops_page.dart';

class DistrictPage extends StatefulWidget {
  DistrictPage({
    Key key,
    this.provinceName,
    this.provinceId,
  }) : super(key: key);

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
    return Scaffold(
      backgroundColor: AppTheme.WHITE_COLOR,
      appBar: AppBar(
        backgroundColor: AppTheme.GREEN_COLOR,
        centerTitle: true,
        title: Text(widget.provinceName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('districts')
            .where('province_id', isEqualTo: widget.provinceId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            default:
              if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data.documents.map(
                    (DocumentSnapshot document) {
                      return ListTile(
                        title: Text(
                          document['name'],
                          style: TextStyle(color: AppTheme.BLACK_COLOR),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: AppTheme.BLACK_COLOR,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShopsPage(
                                provinceId: widget.provinceId,
                                provinceName: widget.provinceName,
                                districtName: document['name'],
                                districtId: document.documentID,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ).toList(),
                );
              } else if (snapshot.hasError) {
                return Container();
              }
              break;
          }
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        },
      ),
    );
  }
}
