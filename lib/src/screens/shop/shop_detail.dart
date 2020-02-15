import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../theme/app_themes.dart';
import '../../scoped_models/user.dart';
import 'update_shop_page.dart';

class ShopDetailPage extends StatefulWidget {
  ShopDetailPage({
    Key key,
    this.docID,
    this.documentName,
    this.districtId,
    this.provinceId,
  }) : super(key: key);

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
              ),
            ),
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
      builder: (BuildContext context, Widget child, User model) {
        return Scaffold(
          backgroundColor: AppTheme.GG_COLOR,
          appBar: AppBar(
            backgroundColor: AppTheme.GREEN_COLOR,
            centerTitle: true,
            title: Text(widget.documentName),
            actions: <Widget>[
              checkAuth(model.userRole),
            ],
          ),
          body: StreamBuilder(
            stream: Firestore.instance
                .collection('store')
                .document(widget.docID)
                .snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                  break;
                default:
                  if (snapshot.hasData) {
                    GeoPoint point = snapshot.data['location']['geopoint'];
                    return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Container(
                              height: 300,
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: snapshot.data['images'][0]['src'],
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const Text(
                                            "ชื่อร้าน",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppTheme.BLACK_COLOR,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.store),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                snapshot.data['name'],
                                                style: TextStyle(
                                                  color: AppTheme.BLACK_COLOR,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                            ),
                                            child: Divider(
                                              height: 2,
                                              color: AppTheme.GREY_COLOR_300,
                                            ),
                                          ),
                                          const Text(
                                            "ที่อยู่",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppTheme.BLACK_COLOR,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _openGoogleExternalMap(
                                                lat: point.latitude.toString(),
                                                lng: point.longitude.toString(),
                                              );
                                            },
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.home),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    snapshot.data['address']
                                                        ['detail'],
                                                    style: TextStyle(
                                                      color:
                                                          AppTheme.BLACK_COLOR,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                              color: AppTheme.GREY_COLOR_300,
                                            ),
                                          ),
                                          const Text(
                                            "โทร",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppTheme.BLACK_COLOR,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.call),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              GestureDetector(
                                                onTap: () => normal(
                                                  snapshot.data['contact']
                                                      ['mobilePhone'],
                                                ),
                                                child: Text(
                                                  snapshot.data['contact']
                                                      ['mobilePhone'],
                                                  style: TextStyle(
                                                    color: AppTheme.BLACK_COLOR,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                            ),
                                            child: Divider(
                                              height: 2,
                                              color: AppTheme.GREY_COLOR_300,
                                            ),
                                          ),
                                          const Text(
                                            "รายละเอียด",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppTheme.BLACK_COLOR,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.library_books),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  snapshot.data['description'],
                                                  style: TextStyle(
                                                    color: AppTheme.BLACK_COLOR,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                            ),
                                            child: Divider(
                                              height: 2,
                                              color: AppTheme.GREY_COLOR_300,
                                            ),
                                          ),
                                          const Text(
                                            "รายละเอียด",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: AppTheme.BLACK_COLOR,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.access_time),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                snapshot.data['operation']
                                                    ['open'],
                                                style: TextStyle(
                                                  color: AppTheme.BLACK_COLOR,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(Icons.access_time),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                snapshot.data['operation']
                                                    ['close'],
                                                style: TextStyle(
                                                  color: AppTheme.BLACK_COLOR,
                                                ),
                                              ),
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
                                      target: LatLng(
                                        point.latitude,
                                        point.longitude,
                                      ),
                                      zoom: 15,
                                    ),
                                    onMapCreated: _onMapCreated,
                                    markers: {
                                      Marker(
                                        markerId: MarkerId("1"),
                                        position: LatLng(
                                          point.latitude,
                                          point.longitude,
                                        ),
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
                  } else if (snapshot.hasError) {
                    return Container();
                  }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        );
      },
    );
  }
}
