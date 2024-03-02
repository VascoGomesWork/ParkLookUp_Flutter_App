import 'package:flutter/material.dart';
import 'map.dart';
import 'services/UserService.dart';
import 'main.dart';

void main() {
  runApp(const MaterialApp(home: Login()));
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 173, 99, 255),
          title: const Text('Login'),
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

  String userName = "";
  String password = "";

  bool loginForm = false;

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

    
    setState((){
      loginForm = true;
    });


    Navigator.of(buildContext).push(MaterialPageRoute(builder: (_){
      return Map(userName);
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
            
            body: SingleChildScrollView( child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Image.asset(
                      'assets/parklookup_logo.png', // Provide the path to your custom logo image
                      width: 250, // Adjust the width as needed
                      height: 250, // Adjust the height as needed
                    )
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                          backgroundColor: Color.fromARGB(255, 26, 200, 202),
                        ),
                        child: const Text('Log In'),
                        onPressed: () {

                          login(context);

                          Future.delayed(Duration(seconds: 1), () {
                          loginForm == false ? showDialog(
                            
                            context: context,
                            builder: (context) => 
                            SizedBox(
                              
                              child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: AlertDialog(
                                backgroundColor: Colors.red,
                              title: const Text("Login Falhou\n\nPor favor preencha todos os \ncampos corretamente"),
                              
                              actions: [
                                TextButton(
                                  child: const Text(
                                    "Ok", 
                                    style: TextStyle(
                                    color: Colors.black, // Change the text color
                                    fontSize: 24.0,
                                  ),), 
                                  onPressed: () => {
                                    Navigator.pop(context)
                                  }
                                ),
                              ],
                              )
                            ))): "";});

                        },
                      )),

                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        height: 60,
                        //padding: const EdgeInsets.all(20),
                        child: Text("Ainda não tem conta?")),

                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      height: 40,
                      child: 
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Color.fromARGB(255, 26, 200, 202),
                          ),
                          child: const Text('Registe-se!'),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_){
                              return const MyApp();
                            }));
                          },
                        )
                      ),

                ],
              ),
            )));
  }
}