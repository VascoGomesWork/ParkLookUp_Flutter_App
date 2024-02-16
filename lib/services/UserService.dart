import 'dart:ffi';
import 'dart:convert';

import 'package:flutter/services.dart';
//import 'package:shared_preferences/shared_preferences.dart';


class UserInfo{

  String name = "";
  String username = "";
  String email = "";
  String password = "";

  void writeJSONData(){

  }

  Future<void> readJSONData() async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = await json.decode(response);
    print("JSON DATA = " + data);
  }

  void showData(){
    readJSONData();
    print("Data -> Name = " + name + " Username = " + username + " Email " + email + " Password = " + password);
  }

}

class UserParkingInfo{
  String nome = "";
  int specialNecessityPark = -1;
  int parkNumber = -1;
  bool paidPark = false;
}

class AppState{

  UserInfo userInfo = new UserInfo();
  List<UserParkingInfo> userParkingInfoList = new List.empty();

}