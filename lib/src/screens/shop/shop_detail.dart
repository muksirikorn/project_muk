import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../services/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:transparent_image/transparent_image.dart';
import 'update_shop_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/user.dart';
import 'package:scoped_model/scoped_model.dart';

class ShopDetailPage extends StatefulWidget {
  ShopDetailPage(
      {Key key,
      this.docID,
      this.documentName,
      this.districtId,
      this.provinceId})
      : super(key: key);

  final String docID;
  final String documentName;
  final String provinceId;

  final String districtId;

  @override
  _ShopDetailPageState createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
  }

  normal(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _openGoogleExternalMap({String lat, String lng}) async {
    bool launchable =
        await canLaunch('https://maps.google.com/?z=12&q=$lat,$lng');
    if (launchable) {
      await launch('https://maps.google.com/?z=12&q=$lat,$lng');
    } else {
      return SnackBar(
        content: Text('Can not open urls'),
      );
    }
  }

  String lat;
  String lng;

  Widget checkAuth(String role) {
    if (role == 'ADMIN') {
      return IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UpdateShopPage(
                      docID: widget.docID,
                      provinceId: widget.provinceId,
                      districtId: widget.districtId,
                    )),
          );
        },
        icon: Icon(Icons.edit, color: Colors.white),
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(
          builder: (BuildContext context, Widget child, User model){
    return Scaffold(
      backgroundColor: Constant.GG_COLOR,
      appBar: AppBar(
        backgroundColor: Constant.GREEN_COLOR,
        centerTitle: true,
        title: Text(widget.documentName),
        actions: <Widget>[checkAuth(model.role)],
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('store')
              .document(widget.docID)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading");
            }
            var document = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      height: 300,
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: document['images'][0]['src'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "ชื่อร้าน",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.store),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(document['name'],
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Divider(
                                      height: 2,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  Text(
                                    "ที่อยู่",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _openGoogleExternalMap(
                                          lat: document['location']['lat']
                                              .toString(),
                                          lng: document['location']['lng']
                                              .toString());
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Icon(Icons.home),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            document['address']['detail'],
                                            style:
                                                TextStyle(color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Divider(
                                      height: 2,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  Text(
                                    "โทร",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.call),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            normal(document['contact']
                                                ['mobilePhone']);
                                          },
                                          child: Text(
                                              document['contact']
                                                  ['mobilePhone'],
                                              style: TextStyle(
                                                  color: Colors.black))),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Divider(
                                      height: 2,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  Text(
                                    "รายละเอียด",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.library_books),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                          child: Text(document['description'],
                                              style: TextStyle(
                                                  color: Colors.black))),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Divider(
                                      height: 2,
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  Text(
                                    "รายละเอียด",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.access_time),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(document['operation']['open'],
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.access_time),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(document['operation']['close'],
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 300,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(document['location']['lat'],
                                  document['location']['lng']),
                              zoom: 15,
                            ),
                            onMapCreated: _onMapCreated,
                            markers: {
                              Marker(
                                markerId: MarkerId("1"),
                                position: LatLng(document['location']['lat'],
                                    document['location']['lng']),
                              )
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );});
  }
}
