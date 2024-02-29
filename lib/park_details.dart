import 'dart:async';

import 'package:flutter/material.dart';  
import 'package:parking_space_project/reservation_list.dart';
import 'services/UserService.dart';
  
void main() { 
  runApp(ParkDetails( userParkingInfo)); 
  
  }  
  
class ParkDetails extends StatelessWidget {
  
  UserParkingInfo userParkingInfo = UserParkingInfo("", -1, false);

  ParkDetails( this.userParkingInfo);
  
  @override  
  Widget build(BuildContext context) {  

    print("ParkDetails Name = " + this.userParkingInfo.name.toString());
    print("ParkDetails Special Necessity Park Number = " + this.userParkingInfo.specialNecessityParkNumber.toString());
    print("ParkDetails Paid Park = " + this.userParkingInfo.paidPark.toString());

    return MaterialApp(  
        
        home: MyTextPage(userParkingInfo),
        debugShowCheckedModeBanner: false,
    );  
  }  
}  
class MyTextPage extends StatelessWidget {

  UserParkingInfo userParkingInfo = UserParkingInfo("", -1, false);

  MyTextPage(this.userParkingInfo);
  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              Text("ParkDetails Name: " + userParkingInfo.name),
              SizedBox(height: 20),

              Text(
                "ParkDetails Special Necessity Park Number: " + userParkingInfo.specialNecessityParkNumber.toString()),
              SizedBox(height: 20),

              Text("ParkDetails Paid Park: " + userParkingInfo.paidPark.toString()),
              SizedBox(height: 20),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 26, 200, 202),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReservationList()),
                  );
                },
                child: const Text('Go back!'),
              ),
            ],
          ),
        ),
      ),
    );  
  }  
}  