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
        
        home: MyTextPage(userParkingInfo)  
    );  
  }  
}  
class MyTextPage extends StatelessWidget {

  UserParkingInfo userParkingInfo = UserParkingInfo("", -1, false);

  MyTextPage(this.userParkingInfo);
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      body:
        Center(  
          child: Column(
            children: <Widget>[
              Container(
                child: Text("ParkDetails Name : " + this.userParkingInfo.name.toString())
              ),

              Container(
                child: Text("ParkDetails Special Necessity Park Number : " + this.userParkingInfo.specialNecessityParkNumber.toString())
              ),

              Container(
                child: Text("ParkDetails Paid Park : " + this.userParkingInfo.paidPark.toString())
              ),
              
              ElevatedButton(
                  onPressed: () {
                    //Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ReservationList())
                    );

                  },
                  child: const Text('Go back!'),
              )
            ]
      ),
        ), 
    );  
  }  
}  