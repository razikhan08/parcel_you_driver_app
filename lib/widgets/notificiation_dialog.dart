import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parcel_you_driver_app/Screens/new_trip_screen.dart';
import 'package:parcel_you_driver_app/global/global.dart';
import 'package:parcel_you_driver_app/models/user_ride_request_information.dart';
import 'package:parcel_you_driver_app/widgets/progress_dialog.dart';

class NotificationDialog extends StatelessWidget {


  UserRideRequestInformation?  userRideRequestInformation;

  NotificationDialog({ this.userRideRequestInformation});

  @override
  Widget build(BuildContext context) {
    return  Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 10,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min ,
          children:  <Widget>[
            const SizedBox(height: 20,),

            const Text("UPCOMING TRIP",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 20),

            Padding(padding: const EdgeInsets.all(16),
              child: Column(
                children:<Widget> [
                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children:  <Widget> [
                    const Icon(Icons.adjust_rounded,color: Colors.deepPurpleAccent,),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Container(child:
                      Text(userRideRequestInformation!.pickupAddress!, style: const TextStyle(fontSize: 18),)),
                    ),

                  ],
                  ),

                  const SizedBox(height: 15),

                  Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      const Icon(Icons.adjust_rounded,color: Colors.black,),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Container(child:
                        Text(userRideRequestInformation!.destinationAddress!, style: const TextStyle(fontSize: 18),)),
                      ),
                    ],
                  ),
                ],


              ),


            ),

            const SizedBox(height: 20,),

            const Divider(
              height: 2,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:<Widget> [
                  Expanded(child: Container(
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.deepPurpleAccent),
                          borderRadius: BorderRadius.circular(50.0)
                        ),

                        primary: Colors.white,
                      ),
                      icon: const Icon(Icons.close, color: Colors.black,),
                      onPressed: (){
                        Navigator.pop(context);
                        audioPlayer.pause();
                        audioPlayer.stop();
                        audioPlayer = AssetsAudioPlayer();

                      }, label: const Text("DECLINE",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),),
                    ),
                  ),
                  ),
                  const SizedBox(width: 10,),


                  Expanded(child: Container(
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.deepPurpleAccent),
                            borderRadius: BorderRadius.circular(50.0)
                        ),

                        primary: Colors.deepPurpleAccent,
                      ),
                      icon: const Icon(Icons.arrow_forward, color: Colors.white,),
                      onPressed: () async {
                        audioPlayer.pause();
                        audioPlayer.stop();
                        audioPlayer = AssetsAudioPlayer();
                        checkAvailability(context);

                      }, label: const Text("ACCEPT",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),),
                    ),
                  ),
                  ),

                ],
              ),

            )

          ],
        ),
      ),
    );
  }
   
  void checkAvailability(context){

    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(message: "Accepting request"),
    );
    
    DatabaseReference newRideRef = FirebaseDatabase.instance.ref()
        .child("Driver's Information").child(currentFirebaseUser!.uid)
        .child("newRideStatus");

    newRideRef.once().then((snapData){

      Navigator.pop(context);

      String thisRideID = "";
      if(snapData.snapshot.value !=null){

        Navigator.pop(context);

        thisRideID = snapData.snapshot.value.toString();
      }
      else{
        print("ride not found");
      }
      if(thisRideID == userRideRequestInformation!.rideID){
        newRideRef.set("accepted");
       Navigator.push(context, MaterialPageRoute(builder: (c) => NewTripScreen(userRideRequestInformation: userRideRequestInformation))
       );
      }
      else if (thisRideID == "cancelled"){
        Fluttertoast.showToast(msg: "Ride has been cancelled");
      }
      else if(thisRideID == "timeout"){
        Fluttertoast.showToast(msg: "Ride has been timed out");

      }
      else{
        Fluttertoast.showToast(msg: "Ride not found");


      }
    });
  }
      
}

