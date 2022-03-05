import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:parcel_you_driver_app/global/global.dart';



class PushNotificationSystem{

  FirebaseMessaging messaging = FirebaseMessaging.instance;


  Future initializeCloudMessaging() async {
    if (Platform.isIOS) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      print('User granted permission: ${settings.authorizationStatus}');
    }

    FirebaseMessaging.instance.getInitialMessage().then((
        RemoteMessage? remoteMessage) {
      print("onMessage: $remoteMessage");

      if (remoteMessage != null) {

      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      print("onMessage: $remoteMessage");
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      print("onMessage: $remoteMessage");
    });

    String? registrationToken = await messaging.getToken();
    print("Token:");
    print(registrationToken);

     FirebaseDatabase.instance.ref()
         .child("Driver's Information")
         .child(currentFirebaseUser!.uid)
         .child("token")
         .set(registrationToken);

    messaging.subscribeToTopic("alldrivers");
    messaging.subscribeToTopic("allusers");
  }
}











