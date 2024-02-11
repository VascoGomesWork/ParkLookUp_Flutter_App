import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MaterialApp(home: GoogleMapActivity()));
}

//https://youtu.be/B9hsWOCXb_o

const String google_api_key = "AIzaSyCsgQMdy2MoeXZYKAm7VOr_ZKPlvZ2jXxA";
const Color primaryColor = Color(0xFF7B61FF);
const double defaultPadding = 16.0;

class GoogleMapActivity extends StatefulWidget {
  const GoogleMapActivity({Key? key}) : super(key: key);

  @override
  State<GoogleMapActivity> createState() => GoogleMapState();
}

class GoogleMapState extends State<GoogleMapActivity> {
  
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, 
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude), 
      PointLatLng(destination.latitude, destination.longitude),
      );

      if(result.points.isNotEmpty){
        result.points.forEach((PointLatLng point) { 
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
        setState(() {
          
        });
      }

  }

  @override
  void initState(){

    getPolyPoints();
    super.initState();

  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            
            body: GoogleMap(
              initialCameraPosition: 
              const CameraPosition(
                target: sourceLocation,
                zoom: 14.5,
              ),

              polylines: {
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCoordinates,
                )
              },

              markers: {
                const Marker(
                  markerId: MarkerId("source"),
                  position: sourceLocation,
                ),

                const Marker(
                  markerId: MarkerId("destination"),
                  position: destination,
                )
              },
            ),
            );
  }
}