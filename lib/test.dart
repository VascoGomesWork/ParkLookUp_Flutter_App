import 'package:flutter/material.dart';
import 'services/UserService.dart';

void main() => runApp(const MaterialApp(home: ReservationList()));

UserParkingInfo userParkingInfo = UserParkingInfo("", -1, false);

class ReservationList extends StatelessWidget {
  const ReservationList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> items = [];
  List<dynamic> userParkingListJsonData = [];


  @override
  void initState() {
    super.initState();
    // Simulate fetching data
    getDataToList().then((data) {
      setState(() {
        userParkingListJsonData = data;
      });
      // After list initialization
      print('List initialized with ${userParkingListJsonData.length} items');
    });
  }

  Future<List<dynamic>> getDataToList() async{

    List<dynamic> userParkingListLocalJsonData = await userParkingInfo.getUserListParkingSpot();

    return userParkingListLocalJsonData;

  }

  void test(){
    print("Item Pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView Initialization Example'),
      ),
      body: ListView.builder(
        itemCount: userParkingListJsonData.length,
        
        itemBuilder: (context, index) {
          // Conditional logic for the last item
          if (index == userParkingListJsonData.length) {
            // Perform action after list initialization
            // Example: Display a message for the last item
            
          } else {
            // Regular list item
            return ListTile(
              onTap: test,
              title: Text(userParkingListJsonData[index]["name"]),
            );
          }
        },
      ),
    );
  }
}