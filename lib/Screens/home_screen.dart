import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parcel_you_driver_app/Screens/welcome_screen.dart';

import '../global/global.dart';
import '../widgets/drawer.dart';
import 'method/assistant_method.dart';


class HomePage extends StatefulWidget {

  String? name;
  HomePage({this.name});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  double offlineContainer = 250.0;

  double bottomMapPadding = 0;

  String userName = "";

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel')
    );
    Widget logOutButton = TextButton(
        onPressed: () {
           offlineDrivers();
          fbAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c) => const WelcomePage()));

        },
        child: const Text('Log out')
    );

    AlertDialog alert = AlertDialog(
      content: const Text("Are you sure you want to log out?"),
      actions: [
        cancelButton,
        logOutButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  final Completer<GoogleMapController> _googleMapController = Completer();

  GoogleMapController? newGoogleMapController;
  // Controller for the Map//

  static  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Position? driverCurrentPosition;
  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  String statusText = "Offline";
  Color statusColor = Colors.grey.shade300;
  bool isDriverOnline = false;


  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateDriverCurrentPosition() async {
    Position cPosition =  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress = await AssistantMethods.searchAddressForGeographicCoordinates(driverCurrentPosition!, context);
    print("this is your address =" + humanReadableAddress);

    userName = userModelCurrentInfo!.name!;
  }

  @override
  void initState() {
    super.initState();

    checkIfLocationPermissionAllowed();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: MyDrawer(name:userName), //userName -- use it
      backgroundColor: Colors.white,
      body:Stack(
        children:<Widget> [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomMapPadding = 250),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController mapController) {
              _googleMapController.complete(mapController);
              newGoogleMapController = mapController;
              locateDriverCurrentPosition();
            },
          ),

          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState!.openDrawer();
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.grey,
                child: Icon(Icons.menu,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          //ui for online an offline driver//
          statusText != "Online"
              ?  Positioned(
            left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 120),
                  vsync: this,
                  curve: Curves.easeIn,
                  child: Container(
                    decoration:  BoxDecoration(
                      border: Border.all(
                        color: Colors.white
                      ),
                      boxShadow: const [BoxShadow(
                        color: Colors.white,
                      )]
                    ),
                    height: offlineContainer,
          ),
                ),
              )
              : Container(),

          //button for online and offline
          Positioned(
            top: statusText != "Online"
            ? MediaQuery.of(context).size.height * 0.75
            : 25,
            right: 50,
            left: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:<Widget> [
                Container(
                  child: statusText != "Online"
                      ? const Text("Go online to start driving",
                    style: TextStyle(
                      fontSize: 18,fontWeight: FontWeight.bold
                    ),

                  )
                      : null
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    primary: statusColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    )
                  ),
                  onPressed: (){
                    if (isDriverOnline != true) {
                      availableDrivers();
                      updateRealtimeDriversLocation();

                      setState(() {
                        statusText ="Online";
                        isDriverOnline = true;
                        statusColor = Colors.orange.shade300;
                      });
                      //display Toast
                      Fluttertoast.showToast(msg: "You are online now");

                    } else{

                      offlineDrivers();

                      setState(() {
                        statusText ="Offline";
                        isDriverOnline = false;
                        statusColor = Colors.grey.shade300;
                      });
                      Fluttertoast.showToast(msg: "You are offline now");
                    }
                  },
                  child: statusText !="Online"
                      ? Text(statusText,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  )
                      :  const Icon(Icons.phonelink_ring,
                    color: Colors.white,
                    size: 25,

                  ),
                ),
                ElevatedButton(onPressed: (){availableDrivers();}, child: Text('press')),


              ],

            ),

          ),

        ],
      ),
    );
  }

  availableDrivers() async{

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = position;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(
        currentFirebaseUser!.uid, 
        driverCurrentPosition!.latitude, 
        driverCurrentPosition!.longitude,
    );
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("Driver's Information")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");

    ref.set("idle"); // searching or ride request
    ref.onValue.listen((event) { });
  }

  updateRealtimeDriversLocation(){
    streamSubscriptionPosition = Geolocator.getPositionStream()
        .listen((Position position) {
          driverCurrentPosition = position;

          if(isDriverOnline == true){

            Geofire.setLocation(
              currentFirebaseUser!.uid,
              driverCurrentPosition!.latitude,
              driverCurrentPosition!.longitude,
            );
          }
          LatLng latLng = LatLng(driverCurrentPosition!.latitude,
              driverCurrentPosition!.longitude);

          newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });


  }

  offlineDrivers(){
    Geofire.removeLocation(currentFirebaseUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance.ref().child("Driver's Information")
        .child(currentFirebaseUser!.uid)
        .child("newRideStatus");

    ref.onDisconnect();
    ref.remove();
    ref = null;

   // Future.delayed(const Duration(milliseconds: 2000), (){

     // SystemChannels.platform.invokeMethod("SystemNavigator.pop");

    // });

  }
}
