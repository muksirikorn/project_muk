import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_muk/src/services/api_service.dart';
import 'package:project_muk/src/services/logging_service.dart';
import 'package:dart_geohash/dart_geohash.dart';

import '../theme/app_themes.dart';
import '../services/auth_service.dart';
import '../services/logging_service.dart';

import '../scoped_models/user.dart';
import 'province_serach.dart';
import 'nearby_page.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {Key key, this.auth, this.userId, this.logoutCallback, this.userEmail})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String userEmail;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController mapController;
  GeoHasher geoHasher = GeoHasher();
  @override
  void initState() {
    super.initState();
    // _fetchMarkers();
  }

  void signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      logger.e(e);
    }
  }

  // void _onMapCreated(GoogleMapController controller) {
  //   mapController = controller;
  // }

  // void _fetchMarkers() async {
  //   var retriveMarker =
  //       await ApiServices().fetchNearBy(1, 13.736717, 100.523186, 100000);
  //   for (var i = 0; i < retriveMarker.locations.length; i++) {
  //     final String markerIdVal = 'marker_id_$i';
  //     final MarkerId markerId = MarkerId(markerIdVal);

  //     var geolo =
  //         geoHasher.decode(retriveMarker.locations[i].geohash.toString());

  //     final Marker marker = Marker(
  //       markerId: markerId,
  //       position: LatLng(
  //         LatLng(13.736717, 100.523186).latitude +
  //             sin(geolo[0] * pi / 6.0) / 20.0,
  //         LatLng(13.736717, 100.523186).longitude +
  //             cos(geolo[1] * pi / 6.0) / 20.0,
  //       ),
  //     );

  //     setState(() {
  //       markers[markerId] = marker;
  //     });
  //   }
  // }

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
                  Tab(icon: Icon(Icons.directions_car, color: Colors.black)),
                  Tab(icon: Icon(Icons.directions_bike, color: Colors.black)),
                  // Tab(icon: Icon(Icons.near_me, color: Colors.black)),
                ],
              ),
              automaticallyImplyLeading: false,
              backgroundColor: AppTheme.GREEN_COLOR,
              title: Text('ร้านซ่อมรถ'),
              actions: <Widget>[
                FlatButton(
                    child: Icon(Icons.near_me, color: Colors.white),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Nearby()));
                    }),
                FlatButton(
                    child: Icon(Icons.exit_to_app, color: Colors.white),
                    onPressed: signOut)
              ],
            ),
            body: TabBarView(
              children: [
                homeCar(),
                homeBike(),
                // nearby(),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              tooltip: 'ค้นหา',
              onPressed: () async {
                model.updateUserRole(widget.userEmail);
                showSearch(context: context, delegate: DataSearch());
              },
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              label: Text("ค้นหา", style: TextStyle(color: Colors.black)),
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
          .collection('image')
          .where("type", isEqualTo: type)
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
              return Container(
                child: GridView.builder(
                  itemCount: snapshot.data.documents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
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
    return dataView('motorbike');
  }

  // Widget nearby() {
  //   return Container(
  //     padding: EdgeInsets.all(10),
  //     child: GoogleMap(
  //       mapType: MapType.normal,
  //       initialCameraPosition: CameraPosition(
  //         target: LatLng(13.736717, 100.523186),
  //         zoom: 10,
  //       ),
  //       onMapCreated: _onMapCreated,
  //       markers: Set<Marker>.of(markers.values),
  //     ),
  //   );
  // }
}
