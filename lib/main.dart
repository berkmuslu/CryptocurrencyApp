import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mycurrencyapp/homepage.dart';
import 'package:mycurrencyapp/login_page.dart';




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,

      ),
      home: WaitingPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WaitingPage extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context,  snapshot){

          if(snapshot.hasError){

            return Scaffold(
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );

          }


          if(snapshot.connectionState == ConnectionState.done){

            return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.active){

                  final user = snapshot.data;

                  if(user == null){
                    return LoginPage();
                  }else{
                    return MyHomePage();
                  }
                }

                return Scaffold(
                  body: Center(

                    child: Column(

                      children: [

                        SizedBox(

                            height: 180,
                            width:  180,
                            child: Image.asset("img/logo.png")

                        ),

                        CircularProgressIndicator(),

                      ],

                    ),

                  ),
                );


              },
            );

          }

          return Scaffold(
            body: Container(
              color: Colors.lightBlue,

              child: Center(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    SizedBox(

                        height: 180,
                        width:  180,
                        child: Image.asset("img/logo.png")

                    ),

                    CircularProgressIndicator(),

                  ],

                ),

              ),
            ),
          );
        }


    );
  }
}


