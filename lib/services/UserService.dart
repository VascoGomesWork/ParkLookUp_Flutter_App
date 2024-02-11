import 'dart:ffi';

class USerInfo{

  String nome = "";
  String Username = "";
  String email = "";
  String password = "";

}

class UserParkingInfo{
  String nome = "";
  int specialNecessityPark = -1;
  int parkNumber = -1;
  bool paidPark = false;
}

class AppState{

  USerInfo userInfo = new USerInfo();
  List<UserParkingInfo> userParkingInfoList = new List.empty();

}