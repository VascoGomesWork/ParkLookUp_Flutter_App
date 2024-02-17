import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
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

Future<List<dynamic>> readUserInfoJSONData(String dataToRetrieve) async {
  final path = await _localPath;
  final file = File('$path/data.json');

  if (await file.exists()) {
    final jsonData = await file.readAsString();
    //print("DATA FROM FILE = " + jsonData);
    final Map<String, dynamic> jsonMap = json.decode(jsonData);
    print("USER INFO Map Data = ${jsonMap[dataToRetrieve]}");
    //print("USERNAME Map Data = " + jsonMap[dataToRetrieve][0]["username"].toString());

    //CHECKS IF THE DATA TO RETRIEVE IS THE CORRECT TYPE
    if(jsonMap[dataToRetrieve].runtimeType is! Future<List<dynamic>>){
      //IF NOT CASTS IT TO THE RIGHT TYPE
      return await Future.delayed(jsonMap[dataToRetrieve]);
    }

    return jsonMap[dataToRetrieve];
  } else {
    throw const FileSystemException('File does not exist.');
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

    List<dynamic> jsonData = await readUserInfoJSONData("UserInfo");

    if(jsonData != List.empty()){

      if(jsonData[0]["username"].toString() == userNameParameter && jsonData[0]["password"].toString() == passwordParameter){
        print("USERNAME Map Data = ${jsonData[0]["username"]}");
        print("Password Map Data = ${jsonData[0]["password"]}");
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

  Future<Map<String, dynamic>> userParkingInfoToJSON() async {
    //return {"UserParkingInfo": [{"name": name, "specialNecessityParkNumber": specialNecessityParkNumber, "paidPark": paidPark}]};
    List<dynamic> jsonData = await readUserInfoJSONData("UserInfo");
    return {"UserInfo": {"name": jsonData[0]["name"].toString(), "username": jsonData[0]["username"].toString(), "email": jsonData[0]["email"].toString(), "password": jsonData[0]["password"].toString()}, "UserParkingInfo": [{"name": name, "specialNecessityParkNumber": specialNecessityParkNumber, "paidPark": paidPark}]};
  }


  Future<void> writeUserParkingInfoJSONData(UserParkingInfo userParkingInfo) async {
    final path = await _localPath;
    final file = File("$path/data.json");
    //UserInfo userInfo = new UserInfo(name, );

    print("UserINFO = ${userParkingInfo.userParkingInfoToJSON()}");
    final jsonData = json.encode(await userParkingInfo.userParkingInfoToJSON());

    await file.writeAsString(jsonData);
  }

  Future<void> reserveParkingSpot(UserParkingInfo userParkingInfo) async {

      List<dynamic> jsonData = await readUserInfoJSONData("UserInfo");

      print("UserParkingInfo Name = ${userParkingInfo.name}");
      print("UserParkingInfo Número do Parque de Estacionamento = ${userParkingInfo.specialNecessityParkNumber}");
      print("UserParkingInfo Parque Pago = ${userParkingInfo.paidPark}");

      //Adds data to the existing data
      jsonData.add(UserParkingInfo (name, specialNecessityParkNumber, paidPark));

      print("USER APRKING INFO DATA = ${jsonData[1]}");//["specialNecessityParkNumber"].toString());
      //Put Data into the JSON File
      writeUserParkingInfoJSONData(jsonData[1]);

  }

  Future<List<dynamic>> readUserListParkingJSONData(String dataToRetrieve) async {
    final path = await _localPath;
    final file = File('$path/data.json');

    if (await file.exists()) {
      final jsonData = await file.readAsString();
      //print("DATA FROM FILE = " + jsonData);
      final Map<String, dynamic> jsonMap = json.decode(jsonData);
      print("Data to Retrieve = ${jsonMap[1]}");
      //print("USERNAME Map Data = " + jsonMap[dataToRetrieve][0]["username"].toString());
      return jsonMap[1];
    } else {
      throw const FileSystemException('File does not exist.');
    }
    return List.empty();
  }

  Future<void> getUserListParkingSpot() async {

    List<dynamic> jsonData = await readUserListParkingJSONData("UserParkingInfo");

    if(jsonData != List.empty()){

      print("Nome do Parque Map Data = ${jsonData[0]["name"]}");
      print("Número do Parque de Estacionamento Map Data = ${jsonData[0]["specialNecessityParkNumber"]}");
      print("Parque Pago Map Data = ${jsonData[0]["paidPark"]}");

    }

    
  }

}

class AppState{

  UserInfo userInfo = UserInfo("", "", "", "");
  List<UserParkingInfo> userParkingInfoList = List.empty();

}