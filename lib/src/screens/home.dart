import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_muk/src/services/api_service.dart';
import 'package:project_muk/src/services/logging_service.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:location/location.dart';

import '../theme/app_themes.dart';
import '../services/auth_service.dart';
import '../services/logging_service.dart';

import '../scoped_models/user.dart';
import 'province_serach.dart';
import 'nearby_page.dart';

class HomePage extends StatefulWidget {
  // HomePage(
  //     {Key key, this.auth, this.userId, this.logoutCallback, this.userEmail,})
  //     : super(key: key);

  HomePage({Key key}) : super(key: key);

  // final BaseAuth auth;
  // final VoidCallback logoutCallback;
  // final String userId;
  // final String userEmail;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController mapController;
  GeoHasher geoHasher = GeoHasher();
  LocationData startLocation;
  LocationData _currentLocation;

  StreamSubscription<LocationData> _locationSubscription;

  Location _locationService = Location();
  bool _permission = false;
  String error;
  @override
  void initState() {
    super.initState();
    // _fetchMarkers();
    _initPlatformState();
  }

  // void signOut() async {
  //   try {
  //     await widget.auth.signOut();
  //     widget.logoutCallback();
  //   } catch (e) {
  //     logger.e(e);
  //   }
  // }

  _initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            setState(() {
              _currentLocation = result;
            });
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        if (serviceStatusResult) {
          _initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      startLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<User>(
      builder: (BuildContext context, Widget child, User model) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppTheme.GG_COLOR,
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.directions_car,
                      color: Colors.black,
                    ),
                  ),
                  Tab(
                    icon: Icon(
                      Icons.directions_bike,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              automaticallyImplyLeading: false,
              backgroundColor: AppTheme.GREEN_COLOR,
              title: Text('ร้านซ่อมรถ'),
              actions: <Widget>[
                FlatButton(
                  child: Icon(
                    Icons.near_me,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Nearby(
                          _currentLocation.latitude,
                          _currentLocation.longitude,
                        ),
                      ),
                    );
                  },
                ),
                // FlatButton(
                //     child: Icon(Icons.exit_to_app, color: Colors.white),
                //     onPressed: signOut,)
              ],
            ),
            body: TabBarView(
              children: [
                homeCar(),
                homeBike(),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              tooltip: 'ค้นหา',
              onPressed: () async {
                // model.updateUserRole(widget.userEmail);
                showSearch(
                  context: context,
                  delegate: DataSearch(),
                );
              },
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              label: Text(
                "ค้นหา",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              backgroundColor: AppTheme.GREEN_COLOR,
            ),
          ),
        );
      },
    );
  }

  Widget dataView(String type) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('store')
          .where("type", isEqualTo: type)
          // add where lat lng query here
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          default:
            if (snapshot.hasData) {
              // list []
              // if data in 30 km?
              // yes add to list
              // build gridview
              return Container(
                child: GridView.builder(
                  itemCount: snapshot.data.documents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Card(
                        elevation: 5.0,
                        child: Container(
                          alignment: Alignment.center,
                          child: Image.network(
                            snapshot.data.documents[index]['images'][0]['src'],
                            width: 300,
                            height: 300,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Container();
            }
            break;
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget homeCar() {
    return dataView('car');
  }

  Widget homeBike() {
    return dataView('bike');
  }
}
