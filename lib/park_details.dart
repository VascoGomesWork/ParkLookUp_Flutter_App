import 'package:flutter/material.dart';  
import 'package:parking_space_project/reservation_list.dart';
  
void main() { runApp(const ParkDetails()); }  
  
class ParkDetails extends StatelessWidget {
  const ParkDetails({super.key});
  
  @override  
  Widget build(BuildContext context) {  
    return const MaterialApp(  
        
        home: MyTextPage()  
    );  
  }  
}  
class MyTextPage extends StatelessWidget {
  const MyTextPage({super.key});
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      body:
        Center(  
          child: Column(
            children: <Widget>[
              Container(
                child:const Text("Welcome to Javatpoint")
                ),
              
              
              ElevatedButton(
                  onPressed: () {
                    //Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  const ReservationList())
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