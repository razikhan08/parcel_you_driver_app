import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Screens/home_screen.dart';
import '../Screens/terms_and_conditions_screen.dart';
import '../global/global.dart';


class ScreenOverlay extends StatefulWidget {


  String? message;
  ScreenOverlay({this.message});

  @override
  State<ScreenOverlay> createState() => _ScreenOverlayState();
}

class _ScreenOverlayState extends State<ScreenOverlay> {


  startTimer(){
    Timer(const Duration(seconds: 3), () async {

      DatabaseReference driversInfo =  FirebaseDatabase.instance.ref().child("Driver's Personal Data");
      driversInfo.once().then((driverKey) {

        final snap = driverKey.snapshot;
        if(snap.value !=null) {

          currentFirebaseUser = fbAuth.currentUser;

          Navigator.push(context, MaterialPageRoute(builder: (c) =>  HomePage()));
        } else {

          Navigator.push(context, MaterialPageRoute(builder: (c) =>  TermsAndConditions()));

        }

      });

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
        color: Colors.green.shade200,
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
