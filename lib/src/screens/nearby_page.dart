import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:project_muk/src/services/api_service.dart';
import 'package:project_muk/src/services/logging_service.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:project_muk/src/theme/app_themes.dart';

class Nearby extends StatefulWidget {
  @override
  State<Nearby> createState() => NearbyState();
}

class NearbyState extends State<Nearby> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController mapController;
  GeoHasher geoHasher = GeoHasher();

  LocationData startLocation;
  LocationData _currentLocation;

  StreamSubscription<LocationData> _locationSubscription;

  Location _locationService = Location();
  bool _permission = false;

  String error;

  bool ready = false;

  double lat, lng;

  @override
  void initState() {
    super.initState();
    _fetchMarkers();
  }

  Future _initPlatformState() async {
    await _locationService.changeSettings(
      accuracy: LocationAccuracy.HIGH,
      interval: 1000,
    );

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
              lat = _currentLocation.latitude;
              lng = _currentLocation.longitude;
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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _fetchMarkers() async {
    await _initPlatformState();

    setState(() {
      ready = true;
    });
    var retriveMarker;

    if (lat != null && lng != null) {
      retriveMarker = await ApiServices().fetchNearBy(
        1,
        lat,
        lng,
        300000,
      );
      final String markerIdVal = 'default_marker';
      final MarkerId markerId = MarkerId(markerIdVal);

      final Marker marker1 = Marker(
        markerId: markerId,
        position: LatLng(lat, lng),
      );

      setState(() {
        markers[markerId] = marker1;
      });

      for (var i = 0; i < retriveMarker.locations.length; i++) {
        final String markerIdVal = 'marker_id_$i';
        final MarkerId markerId = MarkerId(markerIdVal);

        var geolo =
            geoHasher.decode(retriveMarker.locations[i].geohash.toString());

        final Marker marker2 = Marker(
          markerId: markerId,
          position: LatLng(
            LatLng(lat, lng).latitude + sin(geolo[0] * pi / 10.0) / 20.0,
            LatLng(lat, lng).longitude + cos(geolo[1] * pi / 10.0) / 20.0,
          ),
        );

        setState(() {
          markers[markerId] = marker2;
        });
      }
    } else {
      retriveMarker = {"locations": []};
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ready
            ? Container(
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 15,
                  ),
                  onMapCreated: _onMapCreated,
                  markers: Set<Marker>.of(markers.values),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
        floatingActionButton: FloatingActionButton.extended(
          tooltip: 'ค้นหา',
          onPressed: () => _fetchMarkers(),
          icon: Icon(
            Icons.refresh,
            color: Colors.black,
          ),
          label: Text(
            "Refresh",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: AppTheme.GREEN_COLOR,
        ),
      ),
    );
  }
}
