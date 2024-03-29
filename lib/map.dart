import 'package:flutter/material.dart';
import 'package:parking_space_project/google_map.dart';
import 'package:parking_space_project/reservation_list.dart';

String username = "LOGIN";

void main() {
  username = "MAP";
  runApp(MaterialApp(home: Map(username)));
  print("USERNAME START= " + username);
}

class Map extends StatelessWidget {
  const Map(String username);
  
  static const appTitle = 'ParkLookUp';

  @override
  Widget build(BuildContext context) {
    username = username;
    print("USERNAME BUILD= " + username);
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MapState();
}


//MAP STATE

class _MapState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
      
  static List<Widget> _widgetOptions = <Widget>[

    //Activity for Google Maps
    GoogleMapActivity(username),

    //Activity for Reservation List
    ReservationList(),
  ];

  void _onItemTapped(int index, BuildContext buildContext) {
    setState(() {
      _selectedIndex = index;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Color.fromARGB(255, 173, 99, 255),),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 28, 28),
              ),
              child: Image.asset(
                      'assets/parklookup_logo.png', // Provide the path to your custom logo image
                      width: 300, // Adjust the width as needed
                      height: 300, // Adjust the height as needed
                    ),
            ),
            ListTile(
              title: const Text('Pesquisar Parques'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0, context);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            username == "LOGIN" ? ListTile(
              title: const Text('Reserva de Lugares'),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1, context);
                // Then close the drawer
                Navigator.pop(context);
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (buildContext) => const ReservationList()));*/
              },
            ) : Text("")
          ],
        ),
      ),
    );
  }
}