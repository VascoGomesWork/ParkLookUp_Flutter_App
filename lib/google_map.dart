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
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Values Passed By Parameter from Google Maps
String parkingName = "Estacionamento Parque das Nações";
const List<int> parkNumbersList = [1, 5, 10];
int selectedItem = 1;
int parkingNumbersListSize = parkNumbersList.length;
bool paidPark = false;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class GoogleMapActivity extends StatefulWidget {
  const GoogleMapActivity({Key? key}) : super(key: key);

  @override
  State<GoogleMapActivity> createState() => GoogleMapState();
}

class GoogleMapState extends State<GoogleMapActivity> {
  
  final Completer<GoogleMapController> _controller = Completer();

  static const LatLng sourceLocation = LatLng(37.32291173371677, -122.01412296938393);
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

  Future<void> setCustomMarkerIcon() async {

    var markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/handicap_green.png'
    );

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

  void reserveParkingSpot(){

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
            
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack( 

                

              children:[

              TextField(
                decoration: InputDecoration(
                  hintText: "Origem",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  )
                ),
              ),  
                
              GoogleMap(
              initialCameraPosition: 
              const CameraPosition(
                target: sourceLocation,
                zoom: 14.5,
              ),

              polylines: {
                //https://youtu.be/B9hsWOCXb_o
                Polyline(
                  polylineId: const PolylineId("route"),
                  points: polylineCoordinates,
                  color: primaryColor,
                  width: 6
                )
              },

              markers: {
                //https://youtu.be/B9hsWOCXb_o
                Marker(
                  icon: currentLocationIcon,
                  markerId: const MarkerId("source"),
                  position: sourceLocation,
                  
                ),

                //Destination 1 - Park Normal
                Marker(
                  icon: destinationHandicapNormalIcon,
                  markerId: const MarkerId("destination1"),
                  position: destinationHandicapNormal,
                  onTap: () {
                    //https://www.youtube.com/watch?v=4pn-_md5Ol4
                    showDialog(
                      context: context,
                      builder: (context) => 
                      SizedBox(
                        width: 30.0,
                        height: 250.0,
                        child: AlertDialog(
                        title: Text(parkingName),
                        content: Column(
                          children: [
                            //One Row for each Item inside the Pop-Up
                            Row(
                              children: [
                                Text("Lugares de Necessidades Especiais: "),
                                Text('$parkingNumbersListSize'),
                              ],
                            ),

                            Row(
                              children: [
                                Text("Número do Lugar: "),
                                DropdownButton<int>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: selectedItem,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      // Update the selected item when the user makes a selection
                                      selectedItem = newValue;
                                    }
                                  },
                                  items: parkNumbersList.map((int item) {
                                    return DropdownMenuItem<int>(
                                      value: item,
                                      child: Text('$item'),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                Text("Pago: "),
                                Text(paidPark ? 'Sim' : 'Não'),
                              ],
                            )
                            
                          ]
                          ),
                        actions: [
                          TextButton(
                            child: Text("Reservar Lugar"), 
                            onPressed: reserveParkingSpot,
                          ),

                          TextButton(
                            child: Text("Cancelar"), 
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                          )
                        ],
                        )
                      )
                    );
                  },
                ),

                //Destination - Almost Full Handicap Parking
                /*Marker(
                  icon: destinationHandicapFullIcon,
                  markerId: const MarkerId("destination2"),
                  position: destinationHandicapFull,
                ),

                //Destination 3 - Free Handicap Parking
                Marker(
                  icon: destinationHandicapEmptyIcon,
                  markerId: const MarkerId("destination3"),
                  position: destinationEmpty,
                )*/
              },
            ),
            
            /*Positioned(
              top: 16.0,
              left: 16.0,
              right: 16.0,
              child: Row(children: [
                
              TextField(
                decoration: InputDecoration(
                  hintText: "Origem",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  )
                ),
              ),

              TextField(
                decoration: InputDecoration(
                  hintText: "Destino",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)
                  )
                ),
              ),
            ],))*/

            ],
            ),
            ));
  }
}