import 'dart:io';
import 'package:assets_audio_player/assets_audio_player.dart' hide  NotificationSettings;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parcel_you_driver_app/global/global.dart';
import 'package:parcel_you_driver_app/models/user_ride_request_information.dart';
import 'package:parcel_you_driver_app/widgets/notificiation_dialog.dart';
import 'package:parcel_you_driver_app/widgets/progress_dialog.dart';


class PushNotificationSystem{

  FirebaseMessaging messaging = FirebaseMessaging.instance;


  Future initializeCloudMessaging(BuildContext context) async {
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

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage) {

      if (remoteMessage != null) {

        //display ride request information - user information who requested a ride
        print("this is remote message: ");
        print(remoteMessage.data["ride_id"]);

        readUserRideInfo(remoteMessage.data["ride_id"], context);

      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {

      print("this is remote message: ");
      print(remoteMessage!.data["ride_id"]);

      readUserRideInfo(remoteMessage.data["ride_id"], context);
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      print("this is remote message: ");
      print(remoteMessage!.data["ride_id"]);

      readUserRideInfo(remoteMessage.data["ride_id"], context);
    });

  }

  Future generateAndGetToken() async{
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


  
  readUserRideInfo(String rideId, BuildContext context){
    
    FirebaseDatabase.instance.ref()
        .child("rideRequest")
        .child(rideId)
        .once()
        .then((snapData) {


          if(snapData.snapshot.value != null){

            audioPlayer.open(Audio("sound/DriverNotificationSound.mp3"));
            audioPlayer.play();

          double pickupLat =  double.parse((snapData.snapshot.value! as Map)["location"]["latitude"].toString());
          double pickupLng =  double.parse((snapData.snapshot.value! as Map)["location"]["longitude"].toString());
          String pickupAddress = (snapData.snapshot.value! as Map)["pickup_address"];

          double destinationLat =  double.parse((snapData.snapshot.value! as Map)["destination"]["latitude"].toString());
          double destinationLng =  double.parse((snapData.snapshot.value! as Map)["destination"]["longitude"].toString());
          String destinationAddress = (snapData.snapshot.value! as Map)["destination_address"];

          String userName = (snapData.snapshot.value! as Map)["user_name"];
          String userNumber = (snapData.snapshot.value! as Map)["user_number"];
          String receiversName = (snapData.snapshot.value! as Map)["receiver's_name"];
          String receiversNumber = (snapData.snapshot.value! as Map)["receiver's_number"];
          String paymentMethod = (snapData.snapshot.value! as Map)["payment_method"];



          UserRideRequestInformation userRideRequestInformation = UserRideRequestInformation();

          userRideRequestInformation.pickupLatLng = LatLng(pickupLat, pickupLng);
          userRideRequestInformation.pickupAddress = pickupAddress;

          userRideRequestInformation.destinationLatLng = LatLng(destinationLat, destinationLng);
          userRideRequestInformation.destinationAddress = destinationAddress;

          userRideRequestInformation.userName = userName.toUpperCase();
          userRideRequestInformation.userNumber = userNumber;
          userRideRequestInformation.receiversName = receiversName;
          userRideRequestInformation.receiversNumber = receiversNumber;
          userRideRequestInformation.paymentMethod = paymentMethod;
          userRideRequestInformation.rideID = rideId;

          showDialog(
              context: context,
              builder: (BuildContext context) => NotificationDialog(userRideRequestInformation: userRideRequestInformation),

          );

          }else{
            Fluttertoast.showToast(msg: "This request cannot be completed");
          }

        });
  }
}


