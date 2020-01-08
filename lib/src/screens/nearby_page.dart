import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_muk/src/services/api_service.dart';
import 'package:project_muk/src/services/logging_service.dart';
import 'package:dart_geohash/dart_geohash.dart';

class Nearby extends StatefulWidget {
  @override
  State<Nearby> createState() => NearbyState();
}

class NearbyState extends State<Nearby> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  GoogleMapController mapController;
  GeoHasher geoHasher = GeoHasher();

  @override
  void initState() {
    super.initState();
    _fetchMarkers();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _fetchMarkers() async {
    var retriveMarker =
        await ApiServices().fetchNearBy(1, 13.736717, 100.523186, 100000);
    for (var i = 0; i < retriveMarker.locations.length; i++) {
      // logger.d(retriveMarker.locations[i].info);

      final String markerIdVal = 'marker_id_$i';
      final MarkerId markerId = MarkerId(markerIdVal);

      var geolo =
          geoHasher.decode(retriveMarker.locations[i].geohash.toString());

      // logger.d(geolo);

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          LatLng(13.736717, 100.523186).latitude +
              sin(geolo[0] * pi / 10.0) / 20.0,
          LatLng(13.736717, 100.523186).longitude +
              cos(geolo[1] * pi / 10.0) / 20.0,
        ),
      );

      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(13.736717, 100.523186),
          zoom: 15,
        ),
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(markers.values),
      ),
    );
  }
}
