import 'package:flutter/material.dart';
import 'login.dart';
import 'services/UserService.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

void login(BuildContext buildContext){
  Navigator.of(buildContext).push(MaterialPageRoute(builder: (_){
    return Login();
  }));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          backgroundColor: Color.fromARGB(255, 173, 99, 255),
        ),
        body: const MyTextFieldWidget(),
      ),
    );
  }
}

class MyTextFieldWidget extends StatefulWidget {
  const MyTextFieldWidget({super.key});

  @override
  _MyTextFieldWidgetState createState() => _MyTextFieldWidgetState();
}

class _MyTextFieldWidgetState extends State<MyTextFieldWidget> {
  
  //const MyApp({Key? key}) : super(key: key);
  String nameValue = "";
  String userName = "";
  String userEmail = "";
  String password = "";
  String repeatPassword = "";

  

  void updateName(String value){
    setState((){
      nameValue = value;
    });
  }

  void updateUsername(String value){
    setState((){
      userName = value;
    });
  }

  void updateEmail(String value){
    setState((){
      userEmail = value;
    });
  }

  void updatePassword(String value){
    setState((){
      password = value;
    });
  }

  void updateRepeatPassword(String value){
    setState((){
      repeatPassword = value;
    });
  }

  void register(){

    print("Final Name Value = $nameValue");
    print("Final UserName Value = $userName");
    print("Final Email Value = $userEmail");
    print("Final Password Value = $password");
    print("Final Repeat Password Value = $repeatPassword");


    if(nameValue.isNotEmpty && userName.isNotEmpty && userEmail.isNotEmpty && password.isNotEmpty && repeatPassword.isNotEmpty && password == repeatPassword){
      //Calls the Service and Navigates away
      print("Registo efetuado com sucesso");
      UserInfo userInfo = UserInfo(nameValue, userName, userEmail, password);
      userInfo.writeUserDataToJSON(nameValue, userName, userEmail, password);

      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: SingleChildScrollView(child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Image.asset(
                      'assets/parklookup_logo.png', // Provide the path to your custom logo image
                      width: 120, // Adjust the width as needed
                      height: 120, // Adjust the height as needed
                    )
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    child: TextField(
                      onChanged: updateName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Nome',
                      ),
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
                      onChanged: updateEmail,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Email',
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
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: TextField(
                      onChanged: updateRepeatPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                        labelText: 'Repeat Password',
                      ),
                    ),
                  ),

                  Container(
                      height: 80,
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Color.fromARGB(255, 26, 200, 202),
                        ),
                        child: const Text('Efetuar Registo'),
                        onPressed: () {
                          register();
                        },
                      )),

                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: const Text("Já tem conta? Realize o Login."),
                    ),

                      Container(
                      height: 80,
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Color.fromARGB(255, 26, 200, 202),
                        ),
                        child: const Text('Login'),
                        onPressed: () {
                          login(context);
                        },
                      )),

                  
                ],
              ),
            )));
  }
}