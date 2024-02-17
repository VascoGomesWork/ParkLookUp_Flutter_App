import 'package:flutter/material.dart';
import 'map.dart';
import 'services/UserService.dart';

void main() {
  runApp(MaterialApp(home: Login()));
}




class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: MyTextFieldWidget(),
      ),
    );
  }
}

class MyTextFieldWidget extends StatefulWidget {
  @override
  _MyTextFieldWidgetState createState() => _MyTextFieldWidgetState();
}

class _MyTextFieldWidgetState extends State<MyTextFieldWidget> {

  String userName = "";
  String password = "";

  void updateUsername(String value){
    setState((){
      userName = value;
    });
  }

  void updatePassword(String value){
    setState((){
      password = value;
    });
  }

  Future<void> login(BuildContext buildContext) async {

  UserInfo userInfo = UserInfo("", "", "", "");
  
  if(await userInfo.checkLoginCredentials(userName, password)){
    Navigator.of(buildContext).push(MaterialPageRoute(builder: (_){
      return Map();
    }));
  } else {
    //INCORRECT LOGGIN DATA -> SHOW WARNING
    print("Incorrect Loggin Data");
  }
}

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
                    child: FlutterLogo(
                      size: 40,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      onChanged: updateUsername,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Username',
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      onChanged: updatePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Password',
                      ),
                    ),
                  ),

                  Container(
                      height: 80,
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Log In'),
                        onPressed: () {
                          login(context);
                        },
                      )),

                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),

                ],
              ),
            ));
  }
}