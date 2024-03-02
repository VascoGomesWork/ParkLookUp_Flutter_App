import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parking_space_project/map.dart';
import 'services/UserService.dart';



void main() {
  runApp(MaterialApp(home: GoogleMapActivity(username)));
}

//https://youtu.be/B9hsWOCXb_o

const String google_api_key = "AIzaSyCsgQMdy2MoeXZYKAm7VOr_ZKPlvZ2jXxA";
const Color primaryColor = Color(0xFF7B61FF);
const double defaultPadding = 16.0;
///////////////////////////////////////////////////////GOOGLE MAPS STUFF/////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////SOURCE LOCATION - Handicap Normal/////////////////////////////////////////////////////////////////////
String parkingNameSourceLocationHandicapNormal = "Busparkplatt";
const List<int> parkNumbersListSourceLocationHandicapNormal = [1, 5, 10];
int selectedItemSourceLocationHandicapNormal = 1;
int parkingNumbersListSizeSourceLocationHandicapNormal = parkNumbersListSourceLocationHandicapNormal.length;
bool paidParkSourceLocationHandicapNormal = false;
///////////////////////////////////////////////////////SOURCE LOCATION - Handicap Full/////////////////////////////////////////////////////////////////////
String parkingNameSourceLocationHandicapFull = "Parking Évora";
const List<int> parkNumbersListSourceLocationHandicapFull = [2, 6, 14];
int selectedItemSourceLocationHandicapFull = 2;
int parkingNumbersListSizeSourceLocationHandicapFull = parkNumbersListSourceLocationHandicapFull.length;
bool paidParkSourceLocationHandicapFull = false;
///////////////////////////////////////////////////////SOURCE LOCATION - Handicap Empty/////////////////////////////////////////////////////////////////////
String parkingNameSourceLocationHandicapEmpty = "Estacionamento Arena d'Évora";
const List<int> parkNumbersListSourceLocationHandicapEmpty = [1, 7, 9];
int selectedItemSourceLocationHandicapEmpty = 1;
int parkingNumbersListSizeSourceLocationHandicapEmpty = parkNumbersListSourceLocationHandicapEmpty.length;
bool paidParkSourceLocationHandicapEmpty = false;

///////////////////////////////////////////////////////Lisboa - Handicap Normal/////////////////////////////////////////////////////////////////////
String parkingNameLisboaHandicapNormal = "Estacionamento Campo Pequeno";
const List<int> parkNumbersListLisboaHandicapNormal = [1, 2, 3, 4, 5];
int selectedItemLisboaHandicapNormal = 1;
int parkingNumbersListSizeLisboaHandicapNormal = parkNumbersListLisboaHandicapNormal.length;
bool paidParkLisboaHandicapNormal = false;
///////////////////////////////////////////////////////Lisboa - Handicap Full/////////////////////////////////////////////////////////////////////
String parkingNameLisboaHandicapFull = "Parque Largo do Rato";
const List<int> parkNumbersListLisboaHandicapFull = [7, 16, 26];
int selectedItemLisboaHandicapFull = 7;
int parkingNumbersListSizeLisboaHandicapFull = parkNumbersListLisboaHandicapFull.length;
bool paidParkLisboaHandicapFull = false;
///////////////////////////////////////////////////////Lisboa - Handicap Empty/////////////////////////////////////////////////////////////////////
String parkingNameLisboaHandicapEmpty = "Parque Largo de Jesus";
const List<int> parkNumbersListLisboaHandicapEmpty = [1, 6, 7, 9, 11, 16];
int selectedItemLisboaHandicapEmpty = 1;
int parkingNumbersListSizeLisboaHandicapEmpty = parkNumbersListLisboaHandicapEmpty.length;
bool paidParkLisboaHandicapEmpty = false;


///////////////////////////////////////////////////////Porto - Handicap Normal/////////////////////////////////////////////////////////////////////
String parkingNamePortoHandicapNormal = "Fox Gym";
const List<int> parkNumbersListPortoHandicapNormal = [1, 3];
int selectedItemPortoHandicapNormal = 1;
int parkingNumbersListSizePortoHandicapNormal = parkNumbersListPortoHandicapNormal.length;
bool paidParkPortoHandicapNormal = false;
///////////////////////////////////////////////////////Porto - Handicap Full/////////////////////////////////////////////////////////////////////
String parkingNamePortoHandicapFull = "Lidl Porto - Av Fernão M";
const List<int> parkNumbersListPortoHandicapFull = [1, 2, 3, 4, 5];
int selectedItemPortoHandicapFull = 1;
int parkingNumbersListSizePortoHandicapFull = parkNumbersListPortoHandicapFull.length;
bool paidParkPortoHandicapFull = false;
///////////////////////////////////////////////////////Porto - Handicap Empty/////////////////////////////////////////////////////////////////////
String parkingNamePortoHandicapEmpty = "Escola Secundária Carolina M";
const List<int> parkNumbersListPortoHandicapEmpty = [1, 2, 3];
int selectedItemPortoHandicapEmpty = 1;
int parkingNumbersListSizePortoHandicapEmpty = parkNumbersListPortoHandicapEmpty.length;
bool paidParkPortoHandicapEmpty = false;

///////////////////////////////////////////////////////Coimbra - Handicap Normal/////////////////////////////////////////////////////////////////////
String parkingNameCoimbraHandicapNormal = "Decathlon Coimbra";
const List<int> parkNumbersListCoimbraHandicapNormal = [1, 15, 25];
int selectedItemCoimbraHandicapNormal = 1;
int parkingNumbersListSizeCoimbraHandicapNormal = parkNumbersListCoimbraHandicapNormal.length;
bool paidParkCoimbraHandicapNormal = false;
///////////////////////////////////////////////////////Coimbra - Handicap Full/////////////////////////////////////////////////////////////////////
String parkingNameCoimbraHandicapFull = "Alma Shopping";
const List<int> parkNumbersListCoimbraHandicapFull = [2, 3, 14, 20, 27, 28];
int selectedItemCoimbraHandicapFull = 2;
int parkingNumbersListSizeCoimbraHandicapFull = parkNumbersListCoimbraHandicapFull.length;
bool paidParkCoimbraHandicapFull = false;
///////////////////////////////////////////////////////Coimbra - Handicap Empty/////////////////////////////////////////////////////////////////////
String parkingNameCoimbraHandicapEmpty = "Museu da Ciência de Coimbra";
const List<int> parkNumbersListCoimbraHandicapEmpty = [1, 2, 3];
int selectedItemCoimbraHandicapEmpty = 1;
int parkingNumbersListSizeCoimbraHandicapEmpty = parkNumbersListCoimbraHandicapEmpty.length;
bool paidParkCoimbraHandicapEmpty = false;
/////////////////////////////////////////////////////////////DROPDOWN STUFF/////////////////////////////////////////////////////////////////
//ORIGIN
const List<String> originList = ["Localização Atual", "Lisboa", "Porto", "Coimbra"];
String originSelectedItem = "Localização Atual";
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////USER INFO////////////////////////////////////////////////////////////////
//UserInfo userInfo = new UserInfo("", "", "", "");
String usernameGlobal = "";

class GoogleMapActivity extends StatefulWidget {
  const GoogleMapActivity(String username);
  
  @override
  State<GoogleMapActivity> createState() => GoogleMapState(username);
}

class GoogleMapState extends State<GoogleMapActivity> {
  
  final Completer<GoogleMapController> _controller = Completer();

  /////////////////////////////////////////SOURCE LOCATION/////////////////////////////////////////////////////////////////////////
  static LatLng sourceLocation = const LatLng(38.569791168839295, -7.906492510540867);
  static LatLng initialDestinationSourceLocation = const LatLng(38.57005702971896, -7.9065052341653645);
  static const LatLng destinationHandicapNormal = LatLng(38.57373688370198, -7.912808185813289);
  static const LatLng destinationHandicapFull = LatLng(38.57173204693666, -7.903861526859222);
  static const LatLng destinationEmpty = LatLng(38.57783548697596, -7.905856004970001);
/////////////////////////////////////////////LISBOA////////////////////////////////////////////////////////////////////////////////
  static LatLng lisboaSourceLocation = const LatLng(38.765720610090774, -9.205036667402148);
  static LatLng initialDestinationLisboa = const LatLng(38.76581005929401, -9.205117224984388);
  static const LatLng lisboaDestinationHandicapNormal = LatLng(38.80202179114487, -9.17810434050634);
  static const LatLng lisboaDestinationHandicapFull = LatLng(38.77579639495337, -9.215869841502556);
  static const LatLng lisboaDestinationEmpty = LatLng(38.76027069793011, -9.16162484916254);
//////////////////////////////////////////////PORTO//////////////////////////////////////////////////////////////////////////////////
  static LatLng portoSourceLocation = const LatLng(41.16286622732716, -8.63916461073044);
  static LatLng initialDestinationPorto = const LatLng(41.16288825662522, -8.63918438983451);
  static const LatLng portoDestinationHandicapNormal = LatLng(41.15845123589461, -8.645180183854443);
  static const LatLng portoDestinationHandicapFull = LatLng(41.162923193015004, -8.63780259417406);
  static const LatLng portoDestinationEmpty = LatLng(41.15808093277244, -8.641018466598842);
////////////////////////////////////////////COIMBRA//////////////////////////////////////////////////////////////////////////////////
  static LatLng coimbraSourceLocation = const LatLng(40.19759053748225, -8.41372822660357);
  static LatLng initialDestinationCoimbra = const LatLng(40.19747171084348, -8.413669218008264);
  static const LatLng coimbraDestinationHandicapNormal = LatLng(40.199049993598386, -8.408925899843966);
  static const LatLng coimbraDestinationHandicapFull = LatLng(40.19959307935994, -8.40472437116147);
  static const LatLng coimbraDestinationEmpty = LatLng(40.19618637855491, -8.40042588412476);

  LatLng destinationPoints = initialDestinationSourceLocation;
  bool globalReservation = false;

  List<LatLng> polylineCoordinates = [];
  
  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationHandicapNormalIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationHandicapFullIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationHandicapEmptyIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  GlobalKey<GoogleMapState> googleMapKey = GlobalKey<GoogleMapState>();

  //CAMERA POSITION
  CameraPosition cameraPosition = CameraPosition(target: sourceLocation,zoom: 14.5);
  
  GoogleMapState(String username);

  void getPolyPoints(LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints();

    destinationPoints = destination;

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, 
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude), 
      
      PointLatLng(destinationPoints.latitude, destinationPoints.longitude),
      
      );
      //IMPORTANT CHECKS
      print("IS NOT EMPTY = ");
      print(polylineCoordinates);
      //Removes Previous Coordinates
      if(polylineCoordinates.isNotEmpty){
        polylineCoordinates.clear();
      }

      if(result.points.isNotEmpty){
        for (var point in result.points) { 
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
        setState(() {
          
        });
      }

  }

  Future<void> setCustomMarkerIcon() async {
    //UserInfo userInfo = new UserInfo("", "", "", "");
    //List<dynamic> jsonData = await readUserInfoJSONData("UserInfo");
    print("TESTE USER INFO!!!!!!!!!!!!! = " + username);

    print("<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");

    var markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/handicap_green.png'
    );

    usernameGlobal = username;

    //CURRENT USER LOCATION
    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/car.png")
    .then((icon) => {
        currentLocationIcon = icon
      },
    );

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, "assets/handicap.png")
    .then((icon) => {
        sourceIcon = icon
      },
    );

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, username == "LOGIN" ? "assets/handicap.png" : "assets/park.png")
    .then((icon) => {
        destinationHandicapNormalIcon = icon
      },
    );

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, username == "LOGIN" ? "assets/handicap_red.png" : "assets/park_red.png")
    .then((icon) => {
        destinationHandicapFullIcon = icon
      },
    );

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, username == "LOGIN" ? "assets/handicap_green.png" : "assets/park_green.png")
    .then((icon) => {
        destinationHandicapEmptyIcon = icon
      },
    );

  }

  Future<void> searchPlace() async {
    print("Origin = ");
    print(originSelectedItem);

    if(originSelectedItem == "Localização Atual"){

      setState(() => {
        //Sets the coordinates to Localização Atual
        sourceLocation = const LatLng(38.569791168839295, -7.906492510540867),
        cameraPosition = CameraPosition(target: sourceLocation,zoom: 14.5),
        destinationPoints = initialDestinationSourceLocation,
        //If the source point changes so it the destination
        getPolyPoints(initialDestinationSourceLocation)
      });
      
        final GoogleMapController controller = await _controller.future;
        controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
        

    }else if(originSelectedItem == "Lisboa"){

      setState(() => {
        //Sets the coordinates to Lisboa
        sourceLocation = lisboaSourceLocation,
        cameraPosition = CameraPosition(target: sourceLocation,zoom: 14.5),
        destinationPoints = initialDestinationLisboa,
        //If the source point changes so it the destination
        getPolyPoints(initialDestinationLisboa)
      });
      //https://stackoverflow.com/questions/62722671/google-maps-camera-position-updating-issues-in-flutter
        final GoogleMapController controller = await _controller.future;
        controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
        

    } else if(originSelectedItem == "Porto"){

      setState(() => {
        //Sets the coordinates to Porto
        sourceLocation = portoSourceLocation,
        cameraPosition = CameraPosition(target: sourceLocation,zoom: 14.5),
        destinationPoints = initialDestinationPorto,
        //If the source point changes so it the destination
        getPolyPoints(initialDestinationPorto)
      });
      
        final GoogleMapController controller = await _controller.future;
        controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));

    } else if(originSelectedItem == "Coimbra"){

      setState(() => {
        //Sets the coordinates to Coimbra
        sourceLocation = coimbraSourceLocation,
        cameraPosition = CameraPosition(target: sourceLocation,zoom: 14.5),
        destinationPoints = initialDestinationCoimbra,
        //If the source point changes so it the destination
        getPolyPoints(initialDestinationCoimbra)
      });

        final GoogleMapController controller = await _controller.future;
        controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
      
    }
    
    
  }

  void reserveParkingSpot(LatLng destination){

    UserParkingInfo userParkingInfo = UserParkingInfo("", -1, false);

    getPolyPoints(destination);
    print("Reserve Parking Spot");
    switch (destinationPoints){

      case destinationHandicapNormal:
        print("Source Destination Handicap Normal");
        userParkingInfo = UserParkingInfo(parkingNameSourceLocationHandicapNormal, selectedItemSourceLocationHandicapNormal, false);
        userParkingInfo.reserveParkingSpot(userParkingInfo);
        globalReservation = true;
        //userParkingInfo.getUserListParkingSpot();
        break;

      case destinationHandicapFull:
        print("Source Destination Handicap Full");
        userParkingInfo = UserParkingInfo(parkingNameSourceLocationHandicapFull, selectedItemSourceLocationHandicapFull, false);
        userParkingInfo.reserveParkingSpot(userParkingInfo);
        globalReservation = true;
        //userParkingInfo.getUserListParkingSpot();
        break;

      case destinationEmpty:
        print("Source Destination Handicap Empty");
        userParkingInfo = UserParkingInfo(parkingNameSourceLocationHandicapEmpty, selectedItemSourceLocationHandicapEmpty, false);
        userParkingInfo.reserveParkingSpot(userParkingInfo);
        globalReservation = true;
        //userParkingInfo.getUserListParkingSpot();
        break;

      case lisboaDestinationHandicapNormal:
        print("Lisboa Handicap Normal");
        userParkingInfo = UserParkingInfo(parkingNameLisboaHandicapNormal, selectedItemLisboaHandicapNormal, false);
        userParkingInfo.reserveParkingSpot(userParkingInfo);
        globalReservation = true;
        break;

      case lisboaDestinationHandicapFull:
        print("Lisboa Handicap Full");
        userParkingInfo = UserParkingInfo(parkingNameLisboaHandicapFull, selectedItemLisboaHandicapFull, false);
        userParkingInfo.reserveParkingSpot(userParkingInfo);
        globalReservation = true;
        break;

      case lisboaDestinationEmpty:
        print("Lisboa Handicap Empty");
        userParkingInfo = UserParkingInfo(parkingNameLisboaHandicapEmpty, selectedItemLisboaHandicapEmpty, false);
        userParkingInfo.reserveParkingSpot(userParkingInfo);
        globalReservation = true;
        break;

      case portoDestinationHandicapNormal:
        print("Porto Handicap Normal");
        userParkingInfo = UserParkingInfo(parkingNamePortoHandicapNormal, selectedItemPortoHandicapNormal, false);
        userParkingInfo.reserveParkingSpot(userParkingInfo);
        globalReservation = true;
        break;

      case portoDestinationHandicapFull:
        print("Porto Handicap Full");
        userParkingInfo = UserParkingInfo(parkingNamePortoHandicapFull, selectedItemPortoHandicapFull, false);
        userParkingInfo.reserveParkingSpot(userParkingInfo);
        globalReservation = true;
        break;

      case portoDestinationEmpty :
        print("Porto Handicap Empty");
        userParkingInfo = UserParkingInfo(parkingNamePortoHandicapEmpty, selectedItemPortoHandicapEmpty, false);
        userParkingInfo.reserveParkingSpot(userParkingInfo);
        globalReservation = true;
        break;

      case coimbraDestinationHandicapNormal:
        print("Coimbra Handicap Normal");
        userParkingInfo = UserParkingInfo(parkingNameCoimbraHandicapNormal, selectedItemCoimbraHandicapNormal, false);
        userParkingInfo.reserveParkingSpot(userParkingInfo);
        globalReservation = true;
        break;

      case coimbraDestinationHandicapFull:
        print("Coimbra Handicap Full");
        userParkingInfo = UserParkingInfo(parkingNameCoimbraHandicapFull, selectedItemCoimbraHandicapFull, false);
        userParkingInfo.reserveParkingSpot(userParkingInfo);
        globalReservation = true;
        break;

      case coimbraDestinationEmpty:
        print("Coimbra Handicap Empty");
        userParkingInfo = UserParkingInfo(parkingNameCoimbraHandicapEmpty, selectedItemCoimbraHandicapEmpty, false);
        userParkingInfo.reserveParkingSpot(userParkingInfo);
        globalReservation = true;
        break;

    }
  }

  @override
  void initState(){

    getPolyPoints(initialDestinationSourceLocation);
    
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
            
            body: SizedBox(
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
                        
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:
                        AlertDialog(
                        title: Text(parkingNameSourceLocationHandicapNormal),
                        content: Column(
                          children: [
                            //One Row for each Item inside the Pop-Up
                            Row(
                              children: [
                                const Text("Lugares de Necessidades Especiais: "),
                                Text('$parkingNumbersListSizeSourceLocationHandicapNormal'),
                              ],
                            ),

                            Row(
                              children: [
                                const Text("Número do Lugar: "),
                                DropdownButton<int>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: selectedItemSourceLocationHandicapNormal,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      // Update the selected item when the user makes a selection
                                      selectedItemSourceLocationHandicapNormal = newValue;
                                    }
                                  },
                                  items: parkNumbersListSourceLocationHandicapNormal.map((int item) {
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
                                const Text("Pago: "),
                                Text(paidParkSourceLocationHandicapNormal ? 'Sim' : 'Não'),
                              ],
                            )
                            
                          ]
                          ),
                          actions: [
                            TextButton(
                              child: Text(usernameGlobal == "LOGIN" ? "Reservar Lugar" : "Marcar GPS"), 
                              onPressed: () => {
                                reserveParkingSpot(destinationHandicapNormal),
                                Navigator.pop(context),

                                //If the reservation has been successfull then shows a green message else shows a red message
                              showDialog(
                                context: context,
                                builder: (context) => 
                                SizedBox(
                                  
                                  child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AlertDialog(
                                    backgroundColor: globalReservation == true ? Colors.green : Colors.red,
                                  title: Text(globalReservation == true ? "Reserva efetuada com sucesso!" : "Reserva falhou"),
                                  
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Ok", 
                                        style: TextStyle(
                                        color: Colors.black, // Change the text color
                                        fontSize: 24.0,
                                      ),), 
                                      onPressed: () => {
                                        Navigator.pop(context)
                                      }
                                    ),
                                  ],
                                  )
                                ))),

                                },
                            ),

                            TextButton(
                              child: const Text("Cancelar"), 
                              onPressed: () => {
                                Navigator.pop(context)
                              },
                            )
                          ],
                        )
                      ))
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
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AlertDialog(
                        title: Text(parkingNameSourceLocationHandicapFull),
                        content: Column(
                          children: [
                            //One Row for each Item inside the Pop-Up
                            Row(
                              children: [
                                const Text("Lugares de Necessidades Especiais: "),
                                Text('$parkingNumbersListSizeSourceLocationHandicapFull'),
                              ],
                            ),

                            Row(
                              children: [
                                const Text("Número do Lugar: "),
                                DropdownButton<int>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: selectedItemSourceLocationHandicapFull,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      // Update the selected item when the user makes a selection
                                      selectedItemSourceLocationHandicapFull = newValue;
                                    }
                                  },
                                  items: parkNumbersListSourceLocationHandicapFull.map((int item) {
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
                                const Text("Pago: "),
                                Text(paidParkSourceLocationHandicapFull ? 'Sim' : 'Não'),
                              ],
                            )
                            
                          ]
                          ),
                        actions: [
                          TextButton(
                            child: Text(usernameGlobal == "LOGIN" ? "Reservar Lugar" : "Marcar GPS"), 
                            onPressed: () => {
                              reserveParkingSpot(destinationHandicapFull),
                              Navigator.pop(context),

                              //If the reservation has been successfull then shows a green message else shows a red message
                              showDialog(
                                context: context,
                                builder: (context) => 
                                SizedBox(
                                  
                                  child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AlertDialog(
                                    backgroundColor: globalReservation == true ? Colors.green : Colors.red,
                                  title: Text(globalReservation == true ? "Reserva efetuada com sucesso!" : "Reserva falhou"),
                                  
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Ok", 
                                        style: TextStyle(
                                        color: Colors.black, // Change the text color
                                        fontSize: 24.0,
                                      ),), 
                                      onPressed: () => {
                                        Navigator.pop(context)
                                      }
                                    ),
                                  ],
                                  )
                                ))),

                              },
                          ),

                          TextButton(
                            child: const Text("Cancelar"), 
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                          )
                        ],
                        )
                      ))
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
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AlertDialog(
                        title: Text(parkingNameSourceLocationHandicapEmpty),
                        content: Column(
                          children: [
                            //One Row for each Item inside the Pop-Up
                            Row(
                              children: [
                                const Text("Lugares de Necessidades Especiais: "),
                                Text('$parkingNumbersListSizeSourceLocationHandicapEmpty'),
                              ],
                            ),

                            Row(
                              children: [
                                const Text("Número do Lugar: "),
                                DropdownButton<int>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: selectedItemSourceLocationHandicapEmpty,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      // Update the selected item when the user makes a selection
                                      selectedItemSourceLocationHandicapEmpty = newValue;
                                    }
                                  },
                                  items: parkNumbersListSourceLocationHandicapEmpty.map((int item) {
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
                                const Text("Pago: "),
                                Text(paidParkSourceLocationHandicapEmpty ? 'Sim' : 'Não'),
                              ],
                            )
                            
                          ]
                          ),
                        actions: [
                          TextButton(
                            child: Text(usernameGlobal == "LOGIN" ? "Reservar Lugar" : "Marcar GPS"), 
                            onPressed: () => {
                              reserveParkingSpot(destinationEmpty),
                              Navigator.pop(context),

                              //If the reservation has been successfull then shows a green message else shows a red message
                              showDialog(
                                context: context,
                                builder: (context) => 
                                SizedBox(
                                  
                                  child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AlertDialog(
                                    backgroundColor: globalReservation == true ? Colors.green : Colors.red,
                                  title: Text(globalReservation == true ? "Reserva efetuada com sucesso!" : "Reserva falhou"),
                                  
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Ok", 
                                        style: TextStyle(
                                        color: Colors.black, // Change the text color
                                        fontSize: 24.0,
                                      ),), 
                                      onPressed: () => {
                                        Navigator.pop(context)
                                      }
                                    ),
                                  ],
                                  )
                                ))),


                              },
                          ),

                          TextButton(
                            child: const Text("Cancelar"), 
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                          )
                        ],
                        )
                      ))
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
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AlertDialog(
                        title: Text(parkingNameLisboaHandicapNormal),
                        content: Column(
                          children: [
                            //One Row for each Item inside the Pop-Up
                            Row(
                              children: [
                                const Text("Lugares de Necessidades Especiais: "),
                                Text('$parkingNumbersListSizeLisboaHandicapNormal'),
                              ],
                            ),

                            Row(
                              children: [
                                const Text("Número do Lugar: "),
                                DropdownButton<int>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: selectedItemLisboaHandicapNormal,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      // Update the selected item when the user makes a selection
                                      selectedItemLisboaHandicapNormal = newValue;
                                    }
                                  },
                                  items: parkNumbersListLisboaHandicapNormal.map((int item) {
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
                                const Text("Pago: "),
                                Text(paidParkLisboaHandicapNormal ? 'Sim' : 'Não'),
                              ],
                            )
                            
                          ]
                          ),
                        actions: [
                          TextButton(
                            child: Text(usernameGlobal == "LOGIN" ? "Reservar Lugar" : "Marcar GPS"), 
                            onPressed: () => {
                              reserveParkingSpot(lisboaDestinationHandicapNormal),
                              Navigator.pop(context),

                              //If the reservation has been successfull then shows a green message else shows a red message
                              showDialog(
                                context: context,
                                builder: (context) => 
                                SizedBox(
                                  
                                  child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AlertDialog(
                                    backgroundColor: globalReservation == true ? Colors.green : Colors.red,
                                  title: Text(globalReservation == true ? "Reserva efetuada com sucesso!" : "Reserva falhou"),
                                  
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Ok", 
                                        style: TextStyle(
                                        color: Colors.black, // Change the text color
                                        fontSize: 24.0,
                                      ),), 
                                      onPressed: () => {
                                        Navigator.pop(context)
                                      }
                                    ),
                                  ],
                                  )
                                ))),

                              },
                          ),

                          TextButton(
                            child: const Text("Cancelar"), 
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                          )
                        ],
                        )
                      ))
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
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AlertDialog(
                        title: Text(parkingNameLisboaHandicapFull),
                        content: Column(
                          children: [
                            //One Row for each Item inside the Pop-Up
                            Row(
                              children: [
                                const Text("Lugares de Necessidades Especiais: "),
                                Text('$parkingNumbersListSizeLisboaHandicapFull'),
                              ],
                            ),

                            Row(
                              children: [
                                const Text("Número do Lugar: "),
                                DropdownButton<int>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: selectedItemLisboaHandicapFull,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      // Update the selected item when the user makes a selection
                                      selectedItemLisboaHandicapFull = newValue;
                                    }
                                  },
                                  items: parkNumbersListLisboaHandicapFull.map((int item) {
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
                                const Text("Pago: "),
                                Text(paidParkLisboaHandicapFull ? 'Sim' : 'Não'),
                              ],
                            )
                            
                          ]
                          ),
                        actions: [
                          TextButton(
                            child: Text(usernameGlobal == "LOGIN" ? "Reservar Lugar" : "Marcar GPS"), 
                            onPressed: () => {
                              reserveParkingSpot(lisboaDestinationHandicapFull ),
                              Navigator.pop(context),

                              //If the reservation has been successfull then shows a green message else shows a red message
                              showDialog(
                                context: context,
                                builder: (context) => 
                                SizedBox(
                                  
                                  child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AlertDialog(
                                    backgroundColor: globalReservation == true ? Colors.green : Colors.red,
                                  title: Text(globalReservation == true ? "Reserva efetuada com sucesso!" : "Reserva falhou"),
                                  
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Ok", 
                                        style: TextStyle(
                                        color: Colors.black, // Change the text color
                                        fontSize: 24.0,
                                      ),), 
                                      onPressed: () => {
                                        Navigator.pop(context)
                                      }
                                    ),
                                  ],
                                  )
                                ))),

                              },
                          ),

                          TextButton(
                            child: const Text("Cancelar"), 
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                          )
                        ],
                        )
                      ))
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
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AlertDialog(
                        title: Text(parkingNameLisboaHandicapEmpty),
                        content: Column(
                          children: [
                            //One Row for each Item inside the Pop-Up
                            Row(
                              children: [
                                const Text("Lugares de Necessidades Especiais: "),
                                Text('$parkingNumbersListSizeLisboaHandicapEmpty'),
                              ],
                            ),

                            Row(
                              children: [
                                const Text("Número do Lugar: "),
                                DropdownButton<int>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: selectedItemLisboaHandicapEmpty,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      // Update the selected item when the user makes a selection
                                      selectedItemLisboaHandicapEmpty = newValue;
                                    }
                                  },
                                  items: parkNumbersListLisboaHandicapEmpty.map((int item) {
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
                                const Text("Pago: "),
                                Text(paidParkLisboaHandicapEmpty ? 'Sim' : 'Não'),
                              ],
                            )
                            
                          ]
                          ),
                        actions: [
                          TextButton(
                            child: Text(usernameGlobal == "LOGIN" ? "Reservar Lugar" : "Marcar GPS"), 
                            onPressed: () => {
                              reserveParkingSpot(lisboaDestinationEmpty ),
                              Navigator.pop(context),

                              //If the reservation has been successfull then shows a green message else shows a red message
                              showDialog(
                                context: context,
                                builder: (context) => 
                                SizedBox(
                                  
                                  child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AlertDialog(
                                    backgroundColor: globalReservation == true ? Colors.green : Colors.red,
                                  title: Text(globalReservation == true ? "Reserva efetuada com sucesso!" : "Reserva falhou"),
                                  
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Ok", 
                                        style: TextStyle(
                                        color: Colors.black, // Change the text color
                                        fontSize: 24.0,
                                      ),), 
                                      onPressed: () => {
                                        Navigator.pop(context)
                                      }
                                    ),
                                  ],
                                  )
                                ))),

                              },
                          ),

                          TextButton(
                            child: const Text("Cancelar"), 
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                          )
                        ],
                        )
                      ))
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
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AlertDialog(
                        title: Text(parkingNamePortoHandicapNormal),
                        content: Column(
                          children: [
                            //One Row for each Item inside the Pop-Up
                            Row(
                              children: [
                                const Text("Lugares de Necessidades Especiais: "),
                                Text('$parkingNumbersListSizePortoHandicapNormal'),
                              ],
                            ),

                            Row(
                              children: [
                                const Text("Número do Lugar: "),
                                DropdownButton<int>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: selectedItemPortoHandicapNormal,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      // Update the selected item when the user makes a selection
                                      selectedItemPortoHandicapNormal = newValue;
                                    }
                                  },
                                  items: parkNumbersListPortoHandicapNormal.map((int item) {
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
                                const Text("Pago: "),
                                Text(paidParkPortoHandicapNormal ? 'Sim' : 'Não'),
                              ],
                            )
                            
                          ]
                          ),
                        actions: [
                          TextButton(
                            child: Text(usernameGlobal == "LOGIN" ? "Reservar Lugar" : "Marcar GPS"), 
                            onPressed: () => {
                              reserveParkingSpot(portoDestinationHandicapNormal ),
                              Navigator.pop(context),

                              //If the reservation has been successfull then shows a green message else shows a red message
                              showDialog(
                                context: context,
                                builder: (context) => 
                                SizedBox(
                                  
                                  child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AlertDialog(
                                    backgroundColor: globalReservation == true ? Colors.green : Colors.red,
                                  title: Text(globalReservation == true ? "Reserva efetuada com sucesso!" : "Reserva falhou"),
                                  
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Ok", 
                                        style: TextStyle(
                                        color: Colors.black, // Change the text color
                                        fontSize: 24.0,
                                      ),), 
                                      onPressed: () => {
                                        Navigator.pop(context)
                                      }
                                    ),
                                  ],
                                  )
                                ))),

                              },
                          ),

                          TextButton(
                            child: const Text("Cancelar"), 
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                          )
                        ],
                        )
                      ))
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
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AlertDialog(
                        title: Text(parkingNamePortoHandicapFull),
                        content: Column(
                          children: [
                            //One Row for each Item inside the Pop-Up
                            Row(
                              children: [
                                const Text("Lugares de Necessidades Especiais: "),
                                Text('$parkingNumbersListSizePortoHandicapFull'),
                              ],
                            ),

                            Row(
                              children: [
                                const Text("Número do Lugar: "),
                                DropdownButton<int>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: selectedItemPortoHandicapFull,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      // Update the selected item when the user makes a selection
                                      selectedItemPortoHandicapFull = newValue;
                                    }
                                  },
                                  items: parkNumbersListPortoHandicapFull.map((int item) {
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
                                const Text("Pago: "),
                                Text(paidParkPortoHandicapFull ? 'Sim' : 'Não'),
                              ],
                            )
                            
                          ]
                          ),
                        actions: [
                          TextButton(
                            child: Text(usernameGlobal == "LOGIN" ? "Reservar Lugar" : "Marcar GPS"), 
                            onPressed: () => {
                              reserveParkingSpot(portoDestinationHandicapFull ),
                              Navigator.pop(context),

                              //If the reservation has been successfull then shows a green message else shows a red message
                              showDialog(
                                context: context,
                                builder: (context) => 
                                SizedBox(
                                  
                                  child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AlertDialog(
                                    backgroundColor: globalReservation == true ? Colors.green : Colors.red,
                                  title: Text(globalReservation == true ? "Reserva efetuada com sucesso!" : "Reserva falhou"),
                                  
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Ok", 
                                        style: TextStyle(
                                        color: Colors.black, // Change the text color
                                        fontSize: 24.0,
                                      ),), 
                                      onPressed: () => {
                                        Navigator.pop(context)
                                      }
                                    ),
                                  ],
                                  )
                                ))),

                              },
                          ),

                          TextButton(
                            child: const Text("Cancelar"), 
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                          )
                        ],
                        )
                      ))
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
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AlertDialog(
                        title: Text(parkingNamePortoHandicapEmpty),
                        content: Column(
                          children: [
                            //One Row for each Item inside the Pop-Up
                            Row(
                              children: [
                                const Text("Lugares de Necessidades Especiais: "),
                                Text('$parkingNumbersListSizePortoHandicapEmpty'),
                              ],
                            ),

                            Row(
                              children: [
                                const Text("Número do Lugar: "),
                                DropdownButton<int>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: selectedItemPortoHandicapEmpty,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      // Update the selected item when the user makes a selection
                                      selectedItemPortoHandicapEmpty = newValue;
                                    }
                                  },
                                  items: parkNumbersListPortoHandicapEmpty.map((int item) {
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
                                const Text("Pago: "),
                                Text(paidParkPortoHandicapEmpty ? 'Sim' : 'Não'),
                              ],
                            )
                            
                          ]
                          ),
                        actions: [
                          TextButton(
                            child: Text(usernameGlobal == "LOGIN" ? "Reservar Lugar" : "Marcar GPS"), 
                            onPressed: () => {
                              reserveParkingSpot(portoDestinationEmpty ),
                              Navigator.pop(context),

                              //If the reservation has been successfull then shows a green message else shows a red message
                              showDialog(
                                context: context,
                                builder: (context) => 
                                SizedBox(
                                  
                                  child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AlertDialog(
                                    backgroundColor: globalReservation == true ? Colors.green : Colors.red,
                                  title: Text(globalReservation == true ? "Reserva efetuada com sucesso!" : "Reserva falhou"),
                                  
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Ok", 
                                        style: TextStyle(
                                        color: Colors.black, // Change the text color
                                        fontSize: 24.0,
                                      ),), 
                                      onPressed: () => {
                                        Navigator.pop(context)
                                      }
                                    ),
                                  ],
                                  )
                                ))),

                              },
                          ),

                          TextButton(
                            child: const Text("Cancelar"), 
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                          )
                        ],
                        )
                      ))
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
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AlertDialog(
                        title: Text(parkingNameCoimbraHandicapNormal),
                        content: Column(
                          children: [
                            //One Row for each Item inside the Pop-Up
                            Row(
                              children: [
                                const Text("Lugares de Necessidades Especiais: "),
                                Text('$parkingNumbersListSizeCoimbraHandicapNormal'),
                              ],
                            ),

                            Row(
                              children: [
                                const Text("Número do Lugar: "),
                                DropdownButton<int>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: selectedItemCoimbraHandicapNormal,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      // Update the selected item when the user makes a selection
                                      selectedItemCoimbraHandicapNormal = newValue;
                                    }
                                  },
                                  items: parkNumbersListCoimbraHandicapNormal.map((int item) {
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
                                const Text("Pago: "),
                                Text(paidParkCoimbraHandicapNormal ? 'Sim' : 'Não'),
                              ],
                            )
                            
                          ]
                          ),
                        actions: [
                          TextButton(
                            child: Text(usernameGlobal == "LOGIN" ? "Reservar Lugar" : "Marcar GPS"), 
                            onPressed: () => {
                              reserveParkingSpot(coimbraDestinationHandicapNormal),
                              Navigator.pop(context),

                              
                              //If the reservation has been successfull then shows a green message else shows a red message
                              showDialog(
                                context: context,
                                builder: (context) => 
                                SizedBox(
                                  
                                  child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AlertDialog(
                                    backgroundColor: globalReservation == true ? Colors.green : Colors.red,
                                  title: Text(globalReservation == true ? "Reserva efetuada com sucesso!" : "Reserva falhou"),
                                  
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Ok", 
                                        style: TextStyle(
                                        color: Colors.black, // Change the text color
                                        fontSize: 24.0,
                                      ),), 
                                      onPressed: () => {
                                        Navigator.pop(context)
                                      }
                                    ),
                                  ],
                                  )
                                ))),
                              
                              },
                          ),

                          TextButton(
                            child: const Text("Cancelar"), 
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                          )
                        ],
                        )
                      ))
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
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AlertDialog(
                        title: Text(parkingNameCoimbraHandicapFull),
                        content: Column(
                          children: [
                            //One Row for each Item inside the Pop-Up
                            Row(
                              children: [
                                const Text("Lugares de Necessidades Especiais: "),
                                Text('$parkingNumbersListSizeCoimbraHandicapFull'),
                              ],
                            ),

                            Row(
                              children: [
                                const Text("Número do Lugar: "),
                                DropdownButton<int>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: selectedItemCoimbraHandicapFull,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      // Update the selected item when the user makes a selection
                                      selectedItemCoimbraHandicapFull = newValue;
                                    }
                                  },
                                  items: parkNumbersListCoimbraHandicapFull.map((int item) {
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
                                const Text("Pago: "),
                                Text(paidParkCoimbraHandicapFull ? 'Sim' : 'Não'),
                              ],
                            )
                            
                          ]
                          ),
                        actions: [
                          TextButton(
                            child: Text(usernameGlobal == "LOGIN" ? "Reservar Lugar" : "Marcar GPS"), 
                            onPressed: () => {
                              reserveParkingSpot(coimbraDestinationHandicapFull),
                              Navigator.pop(context),

                              //If the reservation has been successfull then shows a green message else shows a red message
                              showDialog(
                                context: context,
                                builder: (context) => 
                                SizedBox(
                                  
                                  child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AlertDialog(
                                    backgroundColor: globalReservation == true ? Colors.green : Colors.red,
                                  title: Text(globalReservation == true ? "Reserva efetuada com sucesso!" : "Reserva falhou"),
                                  
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Ok", 
                                        style: TextStyle(
                                        color: Colors.black, // Change the text color
                                        fontSize: 24.0,
                                      ),), 
                                      onPressed: () => {
                                        Navigator.pop(context)
                                      }
                                    ),
                                  ],
                                  )
                                ))),

                              },
                          ),

                          TextButton(
                            child: const Text("Cancelar"), 
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                          )
                        ],
                        )
                      ))
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
                        child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AlertDialog(
                        title: Text(parkingNameCoimbraHandicapEmpty),
                        content: Column(
                          children: [
                            //One Row for each Item inside the Pop-Up
                            Row(
                              children: [
                                const Text("Lugares de Necessidades Especiais: "),
                                Text('$parkingNumbersListSizeCoimbraHandicapEmpty'),
                              ],
                            ),

                            Row(
                              children: [
                                const Text("Número do Lugar: "),
                                DropdownButton<int>(
                                  //https://youtu.be/GHkwpepeLoE
                                  value: selectedItemCoimbraHandicapEmpty,
                                  onChanged: (int? newValue) {
                                    if (newValue != null) {
                                      // Update the selected item when the user makes a selection
                                      selectedItemCoimbraHandicapEmpty = newValue;
                                    }
                                  },
                                  items: parkNumbersListCoimbraHandicapEmpty.map((int item) {
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
                                const Text("Pago: "),
                                Text(paidParkCoimbraHandicapEmpty ? 'Sim' : 'Não'),
                              ],
                            )
                            
                          ]
                          ),
                        actions: [
                          TextButton(
                            child: Text(usernameGlobal == "LOGIN" ? "Reservar Lugar" : "Marcar GPS"), 
                            onPressed: () => {
                              reserveParkingSpot(coimbraDestinationEmpty),
                              Navigator.pop(context),


                              //If the reservation has been successfull then shows a green message else shows a red message
                              showDialog(
                                context: context,
                                builder: (context) => 
                                SizedBox(
                                  
                                  child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AlertDialog(
                                    backgroundColor: globalReservation == true ? Colors.green : Colors.red,
                                  title: Text(globalReservation == true ? "Reserva efetuada com sucesso!" : "Reserva falhou"),
                                  
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Ok", 
                                        style: TextStyle(
                                        color: Colors.black, // Change the text color
                                        fontSize: 24.0,
                                      ),), 
                                      onPressed: () => {
                                        Navigator.pop(context)
                                      }
                                    ),
                                  ],
                                  )
                                ))),

                              },
                          ),

                          TextButton(
                            child: const Text("Cancelar"), 
                            onPressed: () => {
                              Navigator.pop(context)
                            },
                          )
                        ],
                        )
                      ))
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
                                      child: Text(item),
                                    );
                                  }).toList(),
                                ),
                  
                )
          ),

            Positioned(
              right: 5.0, // Adjust right as needed
              top: 10.0, // Adjust top as needed
              child: SizedBox(
              width: 100,
              
              child: 
                     ElevatedButton(
                      onPressed: () => searchPlace(),
                      child: const Text('Pesquisar'),
                      style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 26, 200, 202),
                          ),
              )
            ))

            ],
            ),
            ));
  }
}

