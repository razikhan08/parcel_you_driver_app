import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parcel_you_driver_app/assistant/request_assistant.dart';
import 'package:parcel_you_driver_app/models/user_model.dart';
import 'package:provider/provider.dart';

import '../global/global.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../models/directions.dart';
import '../models/directions_details.dart';

class AssistantMethods{


  static void readCurrentOnlineUserInfo() async{
    
    currentFirebaseUser = fAuth.currentUser;

    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap)
    {
      if(snap.snapshot.value != null){

       userModelCurrentInfo = userModel.fromSnapshot(snap.snapshot);

      }

    });
  }

  static Future<DirectionsDetails?> pickupToDestinationDirections(LatLng originPosition, LatLng destinationPosition) async {

    String urlPickupToDestinationDirections = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(urlPickupToDestinationDirections);

    if(responseDirectionApi == "Error Occurred. Failed, Please try again"){

      return null;
    }
    DirectionsDetails directionsDetails = DirectionsDetails();
    directionsDetails.encoded_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionsDetails.distance_text =  responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionsDetails.distance_value =  responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionsDetails.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionsDetails.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionsDetails;
  }


  static double generateRandomNumber(int max){

    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);

    return randInt.toDouble();

  }


  static int estimatedFares(DirectionsDetails details){

    // per km = $0.30/km,
    // per min = $0.18/km,
    // base fee = $5,

    double baseFare = 5;
    double distanceFare = (details.distance_value!/1000) * 0.30;
    double perMinuteFare =(details.duration_value!/60) * 0.18;

    double totalFare = baseFare + distanceFare + perMinuteFare;
    return totalFare.truncate();


  }

  static void disableHomeScreenLocationUpdates(){
    
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }
  
  static void enableHomeScreenLocationUpdates(){
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(currentFirebaseUser!.uid, driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    
  }
}

