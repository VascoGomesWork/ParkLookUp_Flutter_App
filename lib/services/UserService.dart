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
      try{
        return Future.value(jsonMap["UserInfo"].values.toList());
      } catch (e) {
        return Future.value(jsonMap["UserInfo"]);
      }

      //return Future.value(jsonMap["UserInfo"].values.toList());
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

      try{
        if(jsonData[0]["username"].toString() == userNameParameter && jsonData[0]["password"].toString() == passwordParameter){
          print("USERNAME Map Data = ${jsonData[0]["username"]}");
          print("Password Map Data = ${jsonData[0]["password"]}");
          print("It is NOt EMPTY");
          return true;
        }
      }catch (e){
        print("USERNAME Map Data = ${jsonData[1]}");
        print("Password Map Data = ${jsonData[3]}");

        if(jsonData[1].toString() == userNameParameter && jsonData[3].toString() == passwordParameter){
          
          return true;
        }
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

    try{
      this.specialNecessityParkNumber = specialNecessityParkNumber;
    } catch (e){
      this.specialNecessityParkNumber = int.parse(specialNecessityParkNumber);
    }

    try{
      this.paidPark = paidPark;
    } catch (e){
      this.paidPark = bool.fromEnvironment(paidPark.toLowerCase());
    }
    
  }  

  Future<Map<String, dynamic>> userParkingInfoToJSON() async {
    //return {"UserParkingInfo": [{"name": name, "specialNecessityParkNumber": specialNecessityParkNumber, "paidPark": paidPark}]};
    List<dynamic> jsonData = await readUserInfoJSONData("UserInfo");
    try{
      return {"UserInfo": {"name": jsonData[0]["name"].toString(), "username": jsonData[0]["username"].toString(), "email": jsonData[0]["email"].toString(), "password": jsonData[0]["password"].toString()}, "UserParkingInfo": [{"name": name, "specialNecessityParkNumber": specialNecessityParkNumber, "paidPark": paidPark}]};
    } catch (e){
      //TODO -> GET THE DATA FROM THE USERPARKINGLIST BEFORE AND USE A FOR LOOP TO ADD IT AGAIN AND ADD THE NEW DATA

      //Get old data from the UserParkingInfoList
      List<dynamic> oldParkingInfoJsonData = await readUserListParkingJSONData("UserParkingInfo");
      List<dynamic> newParkingInfoJsonData = [];
      UserParkingInfo newUserParkingInfoList = UserParkingInfo(name, specialNecessityParkNumber, paidPark);

      //For Loop to loop through
      for(int i = 0; i < oldParkingInfoJsonData.length; i++){
        print("OLD PARKING LIST DATA NAME = " + oldParkingInfoJsonData[i]["name"].toString());
        print("OLD PARKING LIST DATA PARKING NUMBER = " + oldParkingInfoJsonData[i]["specialNecessityParkNumber"].toString());
        print("OLD PARKING LIST DATA PAID PARK = " + oldParkingInfoJsonData[i]["paidPark"].toString());

        newParkingInfoJsonData.add({"name": oldParkingInfoJsonData[i]["name"].toString(), "specialNecessityParkNumber": oldParkingInfoJsonData[i]["specialNecessityParkNumber"].toString(), "paidPark": oldParkingInfoJsonData[i]["paidPark"].toString()});

       
        //oldParkingInfoJsonData[1][0];
      }

      newParkingInfoJsonData.add({"name": name, "specialNecessityParkNumber": specialNecessityParkNumber, "paidPark": paidPark});

      print("NEW PARKING LIST = " + newParkingInfoJsonData.toString());


      return {"UserInfo": {"name": jsonData[0].toString(), "username": jsonData[1].toString(), "email": jsonData[2].toString(), "password": jsonData[3].toString()}, "UserParkingInfo": newParkingInfoJsonData};
    }
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

      
      //Put Data into the JSON File
      try{
        print("USER APRKING INFO DATA = ${jsonData[1]}");//["specialNecessityParkNumber"].toString());
        writeUserParkingInfoJSONData(jsonData[1]);
      }
      catch (e){
        //userParkingInfoToJSON()
        print("USER APRKING INFO DATA = ${jsonData[4]}");//["specialNecessityParkNumber"].toString());
        writeUserParkingInfoJSONData(new UserParkingInfo(jsonData[4].name, jsonData[4].specialNecessityParkNumber, jsonData[4].paidPark));
      }
      

  }

  Future<List<dynamic>> readUserListParkingJSONData(String dataToRetrieve) async {
    final path = await _localPath;
    final file = File('$path/data.json');

    if (await file.exists()) {
      final jsonData = await file.readAsString();
      //print("DATA FROM FILE = " + jsonData);
      final Map<String, dynamic> jsonParkingListMap = json.decode(jsonData);
      print("Data to Retrieve = ${jsonParkingListMap[dataToRetrieve]}");
      //print("USERNAME Map Data = " + jsonMap[dataToRetrieve][0]["username"].toString());
      if(jsonParkingListMap[dataToRetrieve] != null){
        return jsonParkingListMap[dataToRetrieve];
      }
      
    } else {
      throw const FileSystemException('File does not exist.');
    }
    return List.empty();
  }

  Future<List<dynamic>> getUserListParkingSpot() async {

    List<dynamic> jsonData = await readUserListParkingJSONData("UserParkingInfo");

    if(jsonData != List.empty()){

      for(int i = 0; i < jsonData.length; i++){
        print("Nome do Parque Map Data = ${jsonData[i]["name"]}");
        print("Número do Parque de Estacionamento Map Data = ${jsonData[i]["specialNecessityParkNumber"]}");
        print("Parque Pago Map Data = ${jsonData[i]["paidPark"]}");
      }

      return jsonData;
    }
    return List.empty();
  }

}