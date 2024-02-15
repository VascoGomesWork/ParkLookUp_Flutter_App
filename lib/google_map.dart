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
const List<String> originList = ["Localização Atual", "Lisboa", "Porto", "Coimbra"];
String originSelectedItem = "Localização Atual";
//DESTINATION
//const List<String> destinationList = ["Destination 1", "Destination 2", "Destination 3"];
//String destinationSelectedItem = "Destination 1";
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class GoogleMapActivity extends StatefulWidget {
  const GoogleMapActivity({Key? key}) : super(key: key);

  @override
  State<GoogleMapActivity> createState() => GoogleMapState();
}

class GoogleMapState extends State<GoogleMapActivity> {
  
  final Completer<GoogleMapController> _controller = Completer();

  /////////////////////////////////////////SOURCE LOCATION/////////////////////////////////////////////////////////////////////////
  static LatLng sourceLocation = LatLng(38.569791168839295, -7.906492510540867);
  static LatLng destinationHandicapNormal = LatLng(38.57373688370198, -7.912808185813289);
  static const LatLng destinationHandicapFull = LatLng(38.57173204693666, -7.903861526859222);
  static const LatLng destinationEmpty = LatLng(38.57783548697596, -7.905856004970001);
/////////////////////////////////////////////LISBOA////////////////////////////////////////////////////////////////////////////////
  static LatLng lisboaSourceLocation = LatLng(38.765720610090774, -9.205036667402148);
  static LatLng lisboaDestinationHandicapNormal = LatLng(38.80202179114487, -9.17810434050634);
  static const LatLng lisboaDestinationHandicapFull = LatLng(38.77579639495337, -9.215869841502556);
  static const LatLng lisboaDestinationEmpty = LatLng(38.76027069793011, -9.16162484916254);
//////////////////////////////////////////////PORTO//////////////////////////////////////////////////////////////////////////////////
  static LatLng portoSourceLocation = LatLng(41.16286622732716, -8.63916461073044);
  static LatLng portoDestinationHandicapNormal = LatLng(41.15845123589461, -8.645180183854443);
  static const LatLng portoDestinationHandicapFull = LatLng(41.162923193015004, -8.63780259417406);
  static const LatLng portoDestinationEmpty = LatLng(41.15808093277244, -8.641018466598842);
////////////////////////////////////////////COIMBRA//////////////////////////////////////////////////////////////////////////////////
  static LatLng coimbraSourceLocation = LatLng(40.19754414214365, -8.413450623040502);
  static LatLng coimbraDestinationHandicapNormal = LatLng(40.199049993598386, -8.408925899843966);
  static const LatLng coimbraDestinationHandicapFull = LatLng(40.19959307935994, -8.40472437116147);
  static const LatLng coimbraDestinationEmpty = LatLng(40.19618637855491, -8.40042588412476);

  List<LatLng> polylineCoordinates = [];
  
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationHandicapNormalIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationHandicapFullIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationHandicapEmptyIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  GlobalKey<GoogleMapState> googleMapKey = GlobalKey<GoogleMapState>();

  //CAMERA POSITION
  CameraPosition cameraPosition = CameraPosition(target: sourceLocation,zoom: 14.5);

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

  Future<void> searchPlace() async {
    print("Origin = ");
    print(originSelectedItem);

    //TODO - PUT MARKER IN POSITION

    if(originSelectedItem == "Localização Atual"){

      setState(() => {
        //Sets the coordinates to Localização Atual
        sourceLocation = const LatLng(38.569791168839295, -7.906492510540867),
        cameraPosition = CameraPosition(target: sourceLocation,zoom: 14.5),
      });
      
        final GoogleMapController controller = await _controller.future;
        controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));

    }else if(originSelectedItem == "Lisboa"){

      setState(() => {
        //Sets the coordinates to Lisboa
        sourceLocation = lisboaSourceLocation,
        cameraPosition = CameraPosition(target: sourceLocation,zoom: 14.5),
      });
      //https://stackoverflow.com/questions/62722671/google-maps-camera-position-updating-issues-in-flutter
        final GoogleMapController controller = await _controller.future;
        controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));

    } else if(originSelectedItem == "Porto"){

      setState(() => {
        //Sets the coordinates to Porto
        sourceLocation = portoSourceLocation,
        cameraPosition = CameraPosition(target: sourceLocation,zoom: 14.5)
      });
      
        final GoogleMapController controller = await _controller.future;
        controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));

    } else if(originSelectedItem == "Coimbra"){

      setState(() => {
        //Sets the coordinates to Coimbra
        sourceLocation = coimbraSourceLocation,
        cameraPosition = CameraPosition(target: sourceLocation,zoom: 14.5)
      });

        final GoogleMapController controller = await _controller.future;
        controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
      
    }
    
    
  }

  void reserveParkingSpot(LatLng destination){
    getPolyPoints(destination);

    //Passar a Informação para o User Service e mostrar na lista e nos detalhes do parque
  }

  @override
  void initState(){

    getPolyPoints(const LatLng(38.76602254726568, -9.2053378559166));
    
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
              initialCameraPosition: cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
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
                //Current Location Normal Handicap
                //Destination 1 - Park Normal
                Marker(
                  icon: destinationHandicapNormalIcon,
                  markerId: const MarkerId("currentLocationNormalHandicap"),
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

                //Current Location Full Handicap
                //Destination - Almost Full Handicap Parking
                Marker(
                  icon: destinationHandicapFullIcon,
                  markerId: const MarkerId("currentLocationFullHandicap"),
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

                //Current Location Empty Handicap
                //Destination 3 - Free Handicap Parking
                Marker(
                  icon: destinationHandicapEmptyIcon,
                  markerId: const MarkerId("currentLocationEmptyHandicap"),
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
                ),

                //LISBOA
                //LISBOA Normal Handicap
                Marker(
                  icon: destinationHandicapNormalIcon,
                  markerId: const MarkerId("lisboaNormalHandicap"),
                  position: lisboaDestinationHandicapNormal,
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
                ),

                //LISBOA Full Handicap
                Marker(
                  icon: destinationHandicapFullIcon,
                  markerId: const MarkerId("lisboaFullHandicap"),
                  position: lisboaDestinationHandicapFull,
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
                ),

                //LISBOA Empty Handicap
                Marker(
                  icon: destinationHandicapEmptyIcon,
                  markerId: const MarkerId("lisboaEmptyHandicap"),
                  position: lisboaDestinationEmpty,
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
                ),


                //PORTO

                //PORTO Normal Handicap
                Marker(
                  icon: destinationHandicapNormalIcon,
                  markerId: const MarkerId("portoNormalHandicap"),
                  position: portoDestinationHandicapNormal,
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
                ),

                //PORTO Full Handicap
                Marker(
                  icon: destinationHandicapFullIcon,
                  markerId: const MarkerId("portoFullHandicap"),
                  position: portoDestinationHandicapFull,
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
                ),

                //PORTO Empty Handicap
                Marker(
                  icon: destinationHandicapEmptyIcon,
                  markerId: const MarkerId("portoEmptyHandicap"),
                  position: portoDestinationEmpty,
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
                ),

                //COIMBRA

                //COIMBRA Normal Handicap
                Marker(
                  icon: destinationHandicapNormalIcon,
                  markerId: const MarkerId("coimbraNormalHandicap"),
                  position: coimbraDestinationHandicapNormal,
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
                ),

                //COIMBRA Full Handicap
                Marker(
                  icon: destinationHandicapFullIcon,
                  markerId: const MarkerId("coimbraFullHandicap"),
                  position: coimbraDestinationHandicapFull,
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
                ),

                //COIMBRA Empty Handicap
                Marker(
                  icon: destinationHandicapEmptyIcon,
                  markerId: const MarkerId("coimbraHandicapHandicap"),
                  position: coimbraDestinationEmpty,
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

          Positioned(
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

            Positioned(
              right: 5.0, // Adjust right as needed
              top: 10.0, // Adjust top as needed
              child: Container(
              width: 100,
              
              child: 
                     ElevatedButton(
                      onPressed: () => searchPlace(),
                      child: const Text('Pesquisar'),
              )
            ))

            ],
            ),
            ));
  }
}

