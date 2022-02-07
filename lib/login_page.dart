import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycurrencyapp/homepage.dart';
import 'package:mycurrencyapp/main.dart';


class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var username = TextEditingController();
  var password = TextEditingController();

  Future<void> _loginAccount(var uname, var pswd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: uname,
          password: pswd
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Email or Password is wrong!'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else if (e.code == 'wrong-password') {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Email or Password is wrong!'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Container(

          color: Colors.lightBlue,
          child: Center(

            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  SizedBox(

                      height: 180,
                      width:  180,
                      child: Image.asset("img/logo.png")

                  ),

                  SizedBox(

                    height: 30,

                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 240.0,bottom: 10),
                    child: Text("Email",style: TextStyle(fontSize: 17,color: Colors.white),),
                  ),
                  SizedBox(width: 300,child: TextField(
                    controller: username,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),

                  )),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.only(right: 210.0,bottom: 10),
                    child: Text("Password",style: TextStyle(fontSize: 17,color: Colors.white),),
                  ),
                  SizedBox(width: 300,child: TextField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),

                  )),
                  SizedBox(height: 15,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: 120,child: ElevatedButton(onPressed: (){

                        _loginAccount(username.text, password.text);

                      },style: ElevatedButton.styleFrom(primary: Colors.blueGrey) ,child: Text("Login",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))),

                      SizedBox(width: 120,child: ElevatedButton(onPressed: (){

                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));

                      } ,style: ElevatedButton.styleFrom(primary: Colors.blueGrey) ,child: Text("Register",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),


                    ],

                  )

                ],

              ),
            ),

          ),

        ),




    );
  }
}

class RegisterPage extends StatefulWidget {

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var username = TextEditingController();
  var password = TextEditingController();

  Future<void> _registerUser(var uname, var pwd) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: uname,
          password: pwd

      );
      await FirebaseAuth.instance.signOut();


    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Password is too weak!'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Email is already in use!'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(

        color: Colors.lightBlue,
        child: Center(
          
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                SizedBox(

                    height: 180,
                    width:  180,
                    child: Image.asset("img/logo.png")

                ),

                SizedBox(

                  height: 30,

                ),
                Padding(
                  padding: EdgeInsets.only(right: 240.0,bottom: 10),
                  child: Text("Email",style: TextStyle(fontSize: 17,color: Colors.white),),
                ),
                SizedBox(width: 300,child: TextField(
                  controller: username,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  ),

                )),
                SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.only(right: 210.0,bottom: 10),
                  child: Text("Password",style: TextStyle(fontSize: 17,color: Colors.white),),
                ),
                SizedBox(width: 300,child: TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                  ),

                )),
                SizedBox(height: 15,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: 120,child: ElevatedButton(onPressed: (){
                      print("Kullanıcı Adi: ${username.text}");
                      print("Parola: ${password.text}");
                      _registerUser(username.text, password.text);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WaitingPage()));


                    },style: ElevatedButton.styleFrom(primary: Colors.blueGrey) ,child: Text("Register",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))),

                  ],

                )

              ],

            ),
          ),

        ),

      ),



    );
  }
}
