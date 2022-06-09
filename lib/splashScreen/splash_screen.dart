import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parcel_you_driver_app/authScreens/login_screen.dart';
import 'package:parcel_you_driver_app/authScreens/welcome_screen.dart';
import 'package:parcel_you_driver_app/global/global.dart';

import '../assistant/assistant_methods.dart';
import '../mainScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  startTimer(){

    fAuth.currentUser !=null ?  AssistantMethods.readCurrentOnlineUserInfo() : null;
    Timer(const Duration(seconds: 3), () async{

      if(await fAuth.currentUser !=null){

        //send user te HomeScreen
        Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      } else{

        //send user te WelcomeScreen
        Navigator.push(context, MaterialPageRoute(builder: (c) => const WelcomeScreen()));
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
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Center(child: Text("ParcelYou",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
          )
          ),
        ],
      ),
    );
  }
}
