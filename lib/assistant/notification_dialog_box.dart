

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parcel_you_driver_app/assistant/assistant_methods.dart';
import 'package:parcel_you_driver_app/global/global.dart';
import 'package:parcel_you_driver_app/mainScreens/new_trip_screen.dart';
import 'package:parcel_you_driver_app/models/user_ride_request_info.dart';
import 'package:parcel_you_driver_app/widgets/progress_dialog.dart';

class NotificationDialogBox extends StatelessWidget {

  UserRideRequestInfo? userRideRequestDetails;
  NotificationDialogBox({this.userRideRequestDetails});

  @override
  Widget build(BuildContext context) {
    return Dialog(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:  [
           const  SizedBox(height: 16,),
             const Text("New Delivery",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
            ),


            const SizedBox(height: 20,),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [

                  //pickup location
                  Row(
                    children: [
                      const Icon(Icons.adjust),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: Container(
                          child: Text(userRideRequestDetails!.originAddress!,
                          style: const TextStyle(
                            fontSize: 16,

                          ),
                          ),
                        ),
                      )
                    ],

                  ),

                  const SizedBox(height: 20,),


                  //Destination location
                  Row(
                    children: [
                      const Icon(Icons.adjust),
                       const SizedBox(width: 8,),
                      Expanded(
                        child: Container(
                          child: Text(userRideRequestDetails!.destinationAddress!,
                            style: const TextStyle(
                              fontSize: 16,

                            ),
                          ),
                        ),
                      )
                    ],

                  ),
                ],
              ),
            ),

           const Divider(
             height: 3,
             thickness: 3,
           ),

            // button row//
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget> [

                  //cancel request button//
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey
                    ),
                    onPressed: (){
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();
                      //cancel delivery request//

                      Navigator.pop(context);
                    },
                    child: Text("Decline".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,

                      ),

                    ),
                  ),

                  const SizedBox(width: 35,),
                  //accept request button//
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black
                    ),
                    onPressed: ()async {
                      audioPlayer.pause();
                      audioPlayer.stop();
                      audioPlayer = AssetsAudioPlayer();
                      checkAvailability(context);
                      //accept delivery request//

                      Navigator.pop(context);
                    },
                    child: Text("Accept".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white

                      ),

                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  
  void checkAvailability(context){

    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => ProgressDialog(message: "looking for a deliver person",),
    );
    
    DatabaseReference newRideRef = FirebaseDatabase.instance.ref()
        .child("drivers/${currentFirebaseUser!.uid}/newRideStatus");
    newRideRef.once().then((snap) {

      Navigator.pop(context);

      String thisRideID = "";
      if(snap.snapshot.value !=null){
        thisRideID = snap.snapshot.value.toString();
      }
      else{
        Fluttertoast.showToast(msg: "Ride not found");
      }

      if(thisRideID ==  userRideRequestDetails!.rideRequestId){
        newRideRef.set("accepted");
        AssistantMethods.disableHomeScreenLocationUpdates();
        Navigator.push(context, MaterialPageRoute(builder: (c) => NewTripScreen(userRideRequestDetails: userRideRequestDetails,)));
      }
      else if (thisRideID == "cancelled"){
        Fluttertoast.showToast(msg: "Ride has been cancelled");
      }
      else if(thisRideID == "timeout"){
        Fluttertoast.showToast(msg: "Ride has timed out");
      }
      else{
        Fluttertoast.showToast(msg: "Ride not found");
      }
    });
    
  }
}
