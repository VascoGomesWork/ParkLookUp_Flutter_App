import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
  static const LatLng destinationHandicapNormal = LatLng(37.33429383, -122.06600055);
  static const LatLng destinationHandicapFull = LatLng(37.33429384, -122.06600055);
  static const LatLng destinationEmpty = LatLng(37.33429383, -122.06600056);

  List<LatLng> polylineCoordinates = [];
  
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationHandicapNormalIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationHandicapFullIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationHandicapEmptyIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation(){

    Location location = Location();

    /*location.getLocation().then((location) => {
      currentLocation = location
    });*/

  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, 
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude), 
      PointLatLng(destinationHandicapNormal.latitude, destinationHandicapNormal.longitude),
      
      );

      if(result.points.isNotEmpty){
        result.points.forEach((PointLatLng point) { 
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
        setState(() {
          
        });
      }

  }

  void setCustomMarkerIcon(){

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/handicap.png")
    .then((icon) => {
        sourceIcon = icon
      },
    );

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/handicap.png")
    .then((icon) => {
        destinationHandicapNormalIcon = icon
      },
    );

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/handicap_red.png")
    .then((icon) => {
        destinationHandicapFullIcon = icon
      },
    );

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/handicap_green.png")
    .then((icon) => {
        destinationHandicapEmptyIcon = icon
      },
    );

  }

  @override
  void initState(){

    getCurrentLocation();
    getPolyPoints();
    //setCustomMarkerIcon();
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
                  color: primaryColor,
                  width: 6
                )
              },

              markers: {
                Marker(
                  icon: currentLocationIcon,
                  markerId: const MarkerId("source"),
                  position: sourceLocation,
                  onTap: () {
                    const Text("Ganda Tap");
                  },
                ),

                //Destination 1 - Park Normal
                Marker(
                  icon: destinationHandicapNormalIcon,
                  markerId: const MarkerId("destination1"),
                  position: destinationHandicapNormal,
                ),

                //Destination - Almost Full Handicap Parking
                Marker(
                  icon: destinationHandicapFullIcon,
                  markerId: const MarkerId("destination2"),
                  position: destinationHandicapFull,
                ),

                //Destination 3 - Free Handicap Parking
                Marker(
                  icon: destinationHandicapEmptyIcon,
                  markerId: const MarkerId("destination3"),
                  position: destinationEmpty,
                )
              },
            ),
            );
  }
}