import 'dart:ffi';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
//import 'package:shared_preferences/shared_preferences.dart';


class UserInfo{

  String name = "";
  String username = "";
  String email = "";
  String password = "";

  //Future<List<dynamic>> jsonDataGlobal = Future.value([]);

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> writeJSONData(UserInfo userInfo) async {
    final path = await _localPath;
    final file = File("$path/data.json");
    //UserInfo userInfo = new UserInfo(name, );
    final jsonData = json.encode(userInfo.toJSON());

    await file.writeAsString(jsonData);
  }

  Map<String, dynamic> toJSON(){
    return {"UserInfo": [{"name": name, "username": username, "email": email, "password": password}]};
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

  UserInfo(name, username, email, password){
    this.name = name;
    this.username = username;
    this.email = email;
    this.password = password;
  }

  

  bool writeDataToJSON(String name, String username, String userEmail, String password){

    UserInfo userInfo = UserInfo(name, username, userEmail, password);
    writeJSONData(userInfo);
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
  String nome = "";
  int specialNecessityPark = -1;
  int parkNumber = -1;
  bool paidPark = false;
}

class AppState{

  UserInfo userInfo = new UserInfo("", "", "", "");
  List<UserParkingInfo> userParkingInfoList = new List.empty();

}