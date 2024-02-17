import 'dart:ffi';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
//import 'package:shared_preferences/shared_preferences.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<void> writeUserInfoJSONData(UserInfo userInfo) async {
  final path = await _localPath;
  final file = File("$path/data.json");
  //UserInfo userInfo = new UserInfo(name, );
  final jsonData = json.encode(userInfo.userInfoToJSON());

  await file.writeAsString(jsonData);
}

Future<List<dynamic>> readJSONData(String dataToRetrieve) async {
  final path = await _localPath;
  final file = File('$path/data.json');

  if (await file.exists()) {
    final jsonData = await file.readAsString();
    //print("DATA FROM FILE = " + jsonData);
    final Map<String, dynamic> jsonMap = json.decode(jsonData);
    //print("Map Data = " + jsonMap[dataToRetrieve].toString());
    //print("USERNAME Map Data = " + jsonMap[dataToRetrieve][0]["username"].toString());
    return jsonMap[dataToRetrieve];
  } else {
    throw FileSystemException('File does not exist.');
  }
  return List.empty();
}

class UserInfo{

  String name = "";
  String username = "";
  String email = "";
  String password = "";

  //Future<List<dynamic>> jsonDataGlobal = Future.value([]);

  Map<String, dynamic> userInfoToJSON(){
    return {"UserInfo": [{"name": name, "username": username, "email": email, "password": password}]};
  }

  UserInfo(name, username, email, password){
    this.name = name;
    this.username = username;
    this.email = email;
    this.password = password;
  }

  bool writeUserDataToJSON(String name, String username, String userEmail, String password){

    UserInfo userInfo = UserInfo(name, username, userEmail, password);
    writeUserInfoJSONData(userInfo);
    return true;
  }

  Future<bool> checkLoginCredentials(String userNameParameter, passwordParameter) async{

    List<dynamic> jsonData = await readJSONData("UserInfo");

    if(jsonData != List.empty()){

      if(jsonData[0]["username"].toString() == userNameParameter && jsonData[0]["password"].toString() == passwordParameter){
        print("USERNAME Map Data = " + jsonData[0]["username"].toString());
        print("Password Map Data = " + jsonData[0]["password"].toString());
        print("It is NOt EMPTY");
        return true;
      }
    }

    return false;
  }

}

class UserParkingInfo{
  String name = "";
  int specialNecessityParkNumber = -1;
  bool paidPark = false;

  UserParkingInfo(name, specialNecessityParkNumber, paidPark){
    this.name = name;
    this.specialNecessityParkNumber = specialNecessityParkNumber;
    this.paidPark = paidPark;
  }  

  Map<String, dynamic> userParkingInfoToJSON(){
    return {"UserParkingInfo": [{"name": name, "specialNecessityParkNumber": specialNecessityParkNumber, "paidPark": paidPark}]};
  }

  Future<void> writeUserParkingInfoJSONData(UserParkingInfo userParkingInfo) async {
    final path = await _localPath;
    final file = File("$path/data.json");
    //UserInfo userInfo = new UserInfo(name, );
    final jsonData = json.encode(userParkingInfo.userParkingInfoToJSON());

    await file.writeAsString(jsonData);
  }

  void reserveParkingSpot(UserParkingInfo userParkingInfo){

    print("UserParkingInfo Name = " + userParkingInfo.name.toString());
    print("UserParkingInfo Número do Parque de Estacionamento = " + userParkingInfo.specialNecessityParkNumber.toString());
    print("UserParkingInfo Parque Pago = " + userParkingInfo.paidPark.toString());

    //Put Data into the JSON File
    writeUserParkingInfoJSONData(new UserParkingInfo(name, specialNecessityParkNumber, paidPark));

  }

  void getUserListParkingSpot(){

  }

}

/*class AppState{

  UserInfo userInfo = new UserInfo("", "", "", "");
  List<UserParkingInfo> userParkingInfoList = new List.empty();

}*/