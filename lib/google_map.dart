import 'dart:async';
import 'dart:developer';
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
///////////////////////////////////////////////////////GOOGLE MAPS STUFF/////////////////////////////////////////////////////////////////////////////////////
//Values Passed By Parameter from Google Maps
String parkingName = "Estacionamento Parque das Nações";
const List<int> parkNumbersList = [1, 5, 10];
int selectedItem = 1;
int parkingNumbersListSize = parkNumbersList.length;
bool paidPark = false;

/////////////////////////////////////////////////////////////DROPDOWN STUFF/////////////////////////////////////////////////////////////////
//ORIGIN
const List<String> originList = ["Origin 1", "Origin 2", "Origin 3"];
String originSelectedItem = "Origin 1";
//DESTINATION
const List<String> destinationList = ["Destination 1", "Destination 2", "Destination 3"];
String destinationSelectedItem = "Destination 1";
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class GoogleMapActivity extends StatefulWidget {
  const GoogleMapActivity({Key? key}) : super(key: key);

  @override
  State<GoogleMapActivity> createState() => GoogleMapState();
}

class GoogleMapState extends State<GoogleMapActivity> {
  
  final Completer<GoogleMapController> _controller = Completer();

  static LatLng sourceLocation = LatLng(38.76652577305104, -9.205742309064581);
  static LatLng destinationHandicapNormal = LatLng(38.80202179114487, -9.17810434050634);
  static const LatLng destinationHandicapFull = LatLng(38.77579639495337, -9.215869841502556);
  static const LatLng destinationEmpty = LatLng(38.76027069793011, -9.16162484916254);

  List<LatLng> polylineCoordinates = [];
  
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationHandicapNormalIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationHandicapFullIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationHandicapEmptyIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  GlobalKey<GoogleMapState> googleMapKey = GlobalKey<GoogleMapState>();

  void getPolyPoints(LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, 
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude), 
      PointLatLng(destination.latitude, destination.longitude),
      
      );

      //Removes Previous Coordinates
      if(polylineCoordinates.isNotEmpty){
        polylineCoordinates.removeAt(0);
        print(polylineCoordinates);
      }

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

    /*BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/car.png")
    .then((icon) => {
        currentLocationIcon = icon
      },
    );*/

  }

  void searchPlace(){
    print("Origin = ");
    print(originSelectedItem);

    //TODO - PUT MARKER IN POSITION

    //Origin Stuff
    if(originSelectedItem == "Origin 1"){
      //Sets the coordinates to Origin 1
      sourceLocation = LatLng(37.32291173371677, -122.01412296938393);
    } else if(originSelectedItem == "Origin 2"){
      //Sets the coordinates to Origin 2
      sourceLocation = LatLng(37.32291173371678, -122.01412296938393);
    } else if(originSelectedItem == "Origin 3"){
      //Sets the coordinates to Origin 3
      sourceLocation = LatLng(38.76790794827859, -9.207101960072684);
    }
    
    
  }

  void reserveParkingSpot(LatLng destination){
    getPolyPoints(destination);
  }

  @override
  void initState(){

    getPolyPoints(const LatLng(38.767900126389385, -9.207630095461537));
    
    super.initState();
    setCustomMarkerIcon();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This is executed whenever the dependencies of the widget change.
    googleMapKey.currentState?.reassemble();
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

              
                
              GoogleMap(
              key: googleMapKey,
              initialCameraPosition: 
              CameraPosition(
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
                            onPressed: () => {
                              reserveParkingSpot(destinationHandicapNormal),
                              Navigator.pop(context)
                              },
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
                Marker(
                  icon: destinationHandicapFullIcon,
                  markerId: const MarkerId("destination2"),
                  position: destinationHandicapFull,
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
                            onPressed: () => {
                              reserveParkingSpot(destinationHandicapFull),
                              Navigator.pop(context)
                              },
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

                //Destination 3 - Free Handicap Parking
                Marker(
                  icon: destinationHandicapEmptyIcon,
                  markerId: const MarkerId("destination3"),
                  position: destinationEmpty,
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
                            onPressed: () => {
                              reserveParkingSpot(destinationEmpty),
                              Navigator.pop(context)
                              },
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
                )
              },
              
            ),

          /*Positioned(
              left: 10.0, // Adjust right as needed
              top: 10.0,
              child:
                Container(
                  width: 260,
                  color: const Color.fromARGB(255, 76, 163, 175).withOpacity(0.5),
                  child: 
                  
                        DropdownButton<String>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: originSelectedItem,
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        // Update the selected item when the user makes a selection
                                        originSelectedItem = newValue;
                                      });
                                      
                                    }
                                  },
                                  items: originList.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text('$item'),
                                    );
                                  }).toList(),
                                ),
                  
                )
          ),

            /*Positioned(
              right: 110.0, // Adjust right as needed
              top: 10.0, // Adjust top as needed
              child: Container(
              width: 130,
              color: Colors.blue.withOpacity(0.5),
              child: 

                    DropdownButton<String>(
                                  
                                  //https://youtu.be/GHkwpepeLoE
                                  value: destinationSelectedItem,
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                      // Update the selected item when the user makes a selection
                                        destinationSelectedItem = newValue;
                                      });
                                    }
                                  },
                                  items: destinationList.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text('$item'),
                                    );
                                  }).toList(),
                                ),

            )),*/


            Positioned(
              right: 5.0, // Adjust right as needed
              top: 10.0, // Adjust top as needed
              child: Container(
              width: 100,
              
              child: 
                     ElevatedButton(
                      onPressed: searchPlace,
                      child: const Text('Pesquisar'),
              )
            ))*/

            ],
            ),
            ));
  }
}

