import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../Screens/home_screen.dart';
import '../Screens/welcome_screen.dart';
import '../global/global.dart';

class LoadingScreen extends StatefulWidget {


  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (fbAuth.currentUser != null) {
        currentFirebaseUser = fbAuth.currentUser;
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => HomePage()));
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Lottie.asset("assets/loading_lottie_file.json",
              repeat: true,
              reverse: true,
              animate: true,
            ),
          ],
        ),

      ),
    );
  }
}