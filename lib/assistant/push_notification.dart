

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parcel_you_driver_app/assistant/notification_dialog_box.dart';
import 'package:parcel_you_driver_app/global/global.dart';
import 'package:parcel_you_driver_app/models/user_ride_request_info.dart';

class PushNotificationService{

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future initializeCloudMessaging(BuildContext context) async {

    //1. Terminated
    //When the app is completely closed

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if(remoteMessage != null){
        
        readUserRideRequestInfo(remoteMessage.data["ride_id"], context);

        //display ride request info//
      }

    });



    //2. Foreground
    // When the app is open and receives a notification

    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {


      readUserRideRequestInfo(remoteMessage!.data["ride_id"], context);
    });


    //3. Background
    // when the app is running in background

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {


      readUserRideRequestInfo(remoteMessage!.data["ride_id"], context);
    });
  }

  readUserRideRequestInfo(String userRideRequestId, BuildContext context){

    FirebaseDatabase.instance.ref()
        .child("rideRequest")
        .child(userRideRequestId)
        .once()
        .then((snapData) {
      if(snapData.snapshot.value !=null){

        audioPlayer.open(Audio("sound/DriverNotificationSound.mp3"));
        audioPlayer.play();

        double originLat = double.parse((snapData.snapshot.value! as Map)["location"]["latitude"]);
        double originLng = double.parse((snapData.snapshot.value! as Map)["location"]["longitude"]);
        String originAddress = (snapData.snapshot.value as Map)["pickup_address"];

        double destinationLat = double.parse((snapData.snapshot.value! as Map)["destination"]["latitude"]);
        double destinationLng = double.parse((snapData.snapshot.value! as Map)["destination"]["longitude"]);
        String destinationAddress = (snapData.snapshot.value! as Map)["destination_address"];

        String userName = (snapData.snapshot.value! as Map)["rider_name"];
        String userPhone = (snapData.snapshot.value! as Map)["rider_number"];

        UserRideRequestInfo userRideRequestDetails = UserRideRequestInfo();
        userRideRequestDetails.originLatLng = LatLng(originLat, originLng);
        userRideRequestDetails.originAddress = originAddress;

        userRideRequestDetails.destinationLatLng = LatLng(destinationLat, destinationLng);
        userRideRequestDetails.destinationAddress = destinationAddress;

        userRideRequestDetails.riderName = userName;
        userRideRequestDetails.riderNumber = userPhone;
        userRideRequestDetails.rideRequestId = userRideRequestId;

        showDialog(
            context: context,
            builder: (BuildContext context) =>
                NotificationDialogBox(userRideRequestDetails: userRideRequestDetails,

            ),

        );



      }
      else{
        Fluttertoast.showToast(msg: "This request does not exist");
      }
    });

  }
  
  Future  generatingAndGetToken() async{
    
  String? registrationToken = await messaging.getToken();

  print("FCM Registration Token");
  print(registrationToken);

  FirebaseDatabase.instance.ref()
      .child("drivers")
      .child(currentFirebaseUser!.uid)
      .child("token")
      .set(registrationToken);

  messaging.subscribeToTopic("allDrivers");
  messaging.subscribeToTopic("allUsers");
    
  }
}