import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

void login(BuildContext buildContext){
  Navigator.of(buildContext).push(MaterialPageRoute(builder: (_){
    return Login();
  }));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text('Login Screen'),
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
                    child: FlutterLogo(
                      size: 20,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    child: TextField(
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
                        ),
                        child: const Text('Efetuar Registo'),
                        onPressed: () {
                          login(context);
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                        },
                      )),

                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Text("Já tem conta? Realize o Login."),
                    ),

                      Container(
                      height: 80,
                      padding: const EdgeInsets.all(20),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        child: const Text('Login'),
                        onPressed: () {
                          login(context);
                        },
                      )),

                  
                ],
              ),
            ));
  }
}