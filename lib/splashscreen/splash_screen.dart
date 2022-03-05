import 'dart:async';
import 'package:flutter/material.dart';


import '../Screens/home_screen.dart';
import '../Screens/welcome_screen.dart';
import '../global/global.dart';

class MySplashScreen extends StatefulWidget {


  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  

  startTimer(){
    Timer(const Duration(seconds: 3), () async {

          if ( fbAuth.currentUser !=null) {
            currentFirebaseUser = fbAuth.currentUser;
            Navigator.push(
                context, MaterialPageRoute(builder: (c) =>  HomePage()));
          } else {
            Navigator.push(context,
                MaterialPageRoute(builder: (c) => const WelcomePage()));
          }
        });

  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.deepPurpleAccent,
        child: const Center(child: Text('ParcelYou',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40
          ),

        ),
        ),
      ),
    );
  }
}
