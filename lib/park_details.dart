import 'package:flutter/material.dart';  
import 'package:parking_space_project/reservation_list.dart';
  
void main() { runApp(ParkDetails()); }  
  
class ParkDetails extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
        
        home: MyTextPage()  
    );  
  }  
}  
class MyTextPage extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      body:
        Center(  
          child: Column(
            children: <Widget>[
              Container(
                child:Text("Welcome to Javatpoint")
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