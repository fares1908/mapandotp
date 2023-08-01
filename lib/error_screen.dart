import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:untitled4/static.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyD9zDScaOiF2cffA8g9cxpG7zJsbE9dKqg";

  Position? c1;
  StreamSubscription? ps;
  var lat;
  var long;
  CameraPosition? _kGooglePlex;
  Future getper() async {
    bool service;
    LocationPermission per;
    service = await Geolocator.isLocationServiceEnabled();
    if (service == false) {
      return const Center(
        child: Text('Service is not enabled'),
      );
    }
    per = await Geolocator.checkPermission();
    if (per == LocationPermission.denied) {
      per = await Geolocator.requestPermission();
    }
    if (per == LocationPermission.deniedForever) {
      return Future.error('Location Not Available');
    }
    print(per);
    return per;
  }

  Future<void> getLatAndLong() async {
    c1 = await Geolocator.getCurrentPosition().then((value) => value);
    lat = c1!.latitude;
    long = c1!.longitude;
    _kGooglePlex = CameraPosition(target: LatLng(lat, long), zoom: 14);
    myMarker.add(Marker(markerId: MarkerId('1'), position: LatLng(lat, long)));
    setState(() {});
  }

  @override
  void initState() {
    ps = Geolocator.getPositionStream().listen((Position? position) {
      changemarker(position!.latitude, position.longitude);
    });
    getper();
    getPolyline();
    getLatAndLong();
    super.initState();
  }

  GoogleMapController? gmc;
  Set<Marker> myMarker = {};
  changemarker(newlat, newlong) {
    myMarker.clear();
    myMarker.add(Marker(
        markerId: const MarkerId('1'), position: LatLng(newlat, newlong)));
    gmc!.animateCamera(CameraUpdate.newLatLng(LatLng(newlat, newlong)));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Map'),
        ),
        body: Center(
          child: Column(
            children: [
              _kGooglePlex == null
                  ? const CircularProgressIndicator()
                  : Container(
                      child: GoogleMap(
                        myLocationEnabled: true,
                        tiltGesturesEnabled: true,
                        compassEnabled: true,
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        polylines: Set<Polyline>.of(polylines.values),
                        markers: myMarker,
                        mapType: MapType.normal,
                        initialCameraPosition: _kGooglePlex!,
                        onMapCreated: (GoogleMapController controller) {
                          gmc = controller;
                        },
                        onTap: (latLng) {

                          changemarker(latLng.latitude, latLng.longitude);
                        },
                      ),
                      width: 400,
                      height: 500,
                    ),
              TextButton(
                onPressed: () {
                  gmc!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      const CameraPosition(
                        target: LatLng(33.647779, 36.295052),
                        zoom: 14,
                      ),
                    ),
                  );
                },
                child: Text('go To Maka'),
              ),
            ],
          ),
        ));
  }
 addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId:  id, color: Colors.red, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
      PointLatLng(33.647779, 36.295052),
        PointLatLng(33.00322, 36.314278),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")]);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude,point.latitude),);

      });
    }addPolyLine();

  }
}
