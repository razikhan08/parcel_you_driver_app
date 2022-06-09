import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parcel_you_driver_app/assistant/push_notification.dart';
import 'package:parcel_you_driver_app/driverPages/driver.dart';
import 'package:parcel_you_driver_app/global/global.dart';
import 'package:parcel_you_driver_app/widgets/drawer.dart';

import '../assistant/assistant_methods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String userName = "";
  double DriverToggleButtonContainerHeight = (Platform.isIOS) ? 300 : 270;
  double mapBottomPadding = (Platform.isAndroid) ? 280 : 270;

  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  locationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if(_locationPermission == LocationPermission.denied){
      _locationPermission =  await Geolocator.requestPermission();
    }
  }


  locateDriverPosition()async{
    Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = currentPosition;

    LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));


    //userName = userModelCurrentInfo!.name!;

  }

  String statusText = "Go Online";
  Color statusColor = Colors.deepPurpleAccent;
  bool isDriverAvailable = false;


  readCurrentDriverInfo()async{
      currentFirebaseUser  = fAuth.currentUser;
      DatabaseReference driverRef = FirebaseDatabase.instance.ref().child("drivers/${currentFirebaseUser!.uid}");
      driverRef
          .once()
          .then((snap) {
            if(snap.snapshot.value !=null){
              currentDriverInfo = Driver.fromSnapshot(snap.snapshot);
            }
      });
      PushNotificationService pushNotificationService = PushNotificationService();
      pushNotificationService.initializeCloudMessaging(context);
      pushNotificationService.generatingAndGetToken();
  }



  @override
  void initState() {

    locationPermissionAllowed();
    super.initState();

    AssistantMethods.readCurrentOnlineUserInfo();
    readCurrentDriverInfo();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: MyDrawer(
        name: userName,
      ),
      body: Stack(
        children: [

          //Google Map Int//
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              locateDriverPosition();
            },
          ),

          //ui for driver to go online and offline//
          statusText !="Online" ? Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 120),
              vsync: this,
              curve: Curves.easeIn,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:  const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.white,
                  ),
                  boxShadow: const [BoxShadow(
                    blurRadius: 15.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7),
                    color: Colors.black26,
                  )]
                ),
                height: DriverToggleButtonContainerHeight,
              ),
            ),
          )
          : Container(),

          //button for online and offline

          Positioned(
            top: statusText !="Online"
                ? MediaQuery.of(context).size.height * 0.75
                : 30,
            right: 50,
            left: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    primary: statusColor,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    )
                  ),
                  onPressed: (){


                    if(isDriverAvailable !=true){
                      driverIsOnline();
                      updateDriverLocation();

                      setState(() {
                        statusText = "Online";
                        isDriverAvailable = true;
                        //statusColor = Colors.transparent;
                      });
                      //Display Toast
                      Fluttertoast.showToast(msg: "You are online now");

                    }else{
                      driverIsOfflineNow();
                      setState(() {
                        statusText = "Go Online";
                        isDriverAvailable = false;
                        //statusColor = Colors.transparent;
                      });
                      Fluttertoast.showToast(msg: "You are offline now");

                    }
                  },
                  child: statusText !="Online"
                      ? Text(
                    statusText,style: const TextStyle(
                      fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white

                  ),
                  )
                      : const Text("Go Offline",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  ),
                ),

              ],
            ),
          ),

          //Drawer Icon UI//

          Positioned(
            top: 70,
            left: 20,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.menu,
                  color: Colors.blueGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }




  //determines if driver is online//
  driverIsOnline()async {

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = position;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(
        currentFirebaseUser!.uid,
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");

    ref.set("idle");// searching for ride request
    ref.onValue.listen((event) { });
  }

  updateDriverLocation(){

    streamSubscriptionPosition = Geolocator.getPositionStream()
        .listen((Position position)
    {
      driverCurrentPosition = position;

      if(isDriverAvailable == true){

        Geofire.setLocation(
            currentFirebaseUser!.uid,
            driverCurrentPosition!.latitude,
            driverCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(
        driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude,
      );

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });

  }

  driverIsOfflineNow(){
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;


  }
}

