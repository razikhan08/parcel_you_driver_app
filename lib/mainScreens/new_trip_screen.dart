import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parcel_you_driver_app/global/global.dart';
import '../assistant/assistant_methods.dart';
import '../models/user_ride_request_info.dart';

class NewTripScreen extends StatefulWidget {

  UserRideRequestInfo? userRideRequestDetails;
  NewTripScreen({this.userRideRequestDetails});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {

  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  double bottomMapPadding = 0;

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};
  Set<Polyline> polyLines = {};

  List<LatLng> polyLineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  var geoLocator = Geolocator();
  var locationOptions = LocationAccuracy.bestForNavigation;

  Timer? timer;
  int durationCounter = 0;
  
  String? buttonTitle = "arrived";
  Color? buttonColor = Colors.green;

  String statusButton = "accepted";

  BitmapDescriptor? movingVehicleIcon;

  Position? onlineDriverCurrentPosition;

  String rideRequestStatus = "accepted";

  String durationFromOriginToDestination = "";

  bool requestDirectionDetails = false;

  void createMovingVehicleIcon(){
    if(movingVehicleIcon == null){
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context, size: Size(2, 2));
      BitmapDescriptor.fromAssetImage(imageConfiguration, (Platform.isIOS)
      ? "images/car.png"
      : "images/car.png"
      ).then((icon) => {
        movingVehicleIcon = icon
      });
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    acceptTrip();
  }


  @override
  Widget build(BuildContext context) {

    createMovingVehicleIcon();

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomMapPadding),
            initialCameraPosition: _kGooglePlex,
            compassEnabled: true,
            mapToolbarEnabled: true,
            mapType: MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            circles: circleSet,
            markers: markerSet,
            polylines: polyLines,
            onMapCreated: (GoogleMapController controller) async {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomMapPadding =(Platform.isAndroid) ? 280 : 270;
              });

              var currentLatLng = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
              var pickupLatLng = widget.userRideRequestDetails!.originLatLng;

              await  drawPolylineFromPickupToDestination(currentLatLng, pickupLatLng!);

              getLocationUpdates();


            },
          ),

          Positioned(
            left: 20,
            top: 50,
            child: Stack(
              children: <Widget>[
                ElevatedButton(

                  onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurpleAccent,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10),)),
                  ),
                  child: Row(
                    children:const <Widget> [
                      Icon(Icons.close),

                      SizedBox(width: 20,),
                      Text("Cancel Trip"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // start trip container//
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
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
              height: Platform.isIOS ? 300:270,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget> [
                    Text(
                     durationFromOriginToDestination,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.userRideRequestDetails!.riderName!,
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                        ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 10),
                          child: Icon(Icons.call),
                        ),
                      ],

                    ),
                    const SizedBox(height: 25,),

                    Row(
                      children: [
                        Icon(Icons.adjust),
                        SizedBox(width: 18,),

                        Expanded(
                          child: Container(
                            child: Text(
                             widget.userRideRequestDetails!.originAddress!,
                              style: const TextStyle(
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 15,),

                    Row(
                      children: [
                        Icon(Icons.adjust),
                        SizedBox(width: 18,),

                        Expanded(
                          child: Container(
                            child: Text(
                              widget.userRideRequestDetails!.destinationAddress!,
                              style: const TextStyle(
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis

                                ,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),

                    SizedBox(height: 25,),

                    Container(
                      width: 350,
                      child: ElevatedButton (
                        child:  Text(buttonTitle!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: buttonColor,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10),)),
                          elevation:0,
                          shadowColor: Colors.black,
                        ),
                        onPressed: ()  async {
                          if(statusButton == "accepted"){
                            statusButton = "arrived";
                            
                            FirebaseDatabase.instance.ref()
                            .child("rideRequest")
                            .child(widget.userRideRequestDetails!.rideRequestId!)
                            .child("status")
                            .child(statusButton);

                            setState(() {
                              buttonTitle = "Let's Go";
                              buttonColor = Colors.deepPurpleAccent;
                            });

                            await drawPolylineFromPickupToDestination(
                              widget.userRideRequestDetails!.originLatLng!,
                              widget.userRideRequestDetails!.destinationLatLng!,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void acceptTrip() {
    String rideID = widget.userRideRequestDetails!.rideRequestId!;
    rideRef = FirebaseDatabase.instance.ref().child("rideRequest/$rideID");

    rideRef!.child("newRideStatus").set("accepted");
    rideRef!.child("driver_name").set(currentDriverInfo!.name);
    rideRef!.child("car_details")
        .set("${currentDriverInfo!.vehicleColor} - "
        "${currentDriverInfo!.vehicleModel} - "
        "${currentDriverInfo!.vehiclePlateNumber}");

    rideRef!.child("driver_phone").set(currentDriverInfo!.phone);
    rideRef!.child("driver_id").set(currentDriverInfo!.id);

    Map locationMap = {
      'latitude' : driverCurrentPosition!.latitude.toString(),
      'longitude' : driverCurrentPosition!.longitude.toString(),
    };

    rideRef!.child("driver_location").set(locationMap);
  }

  void getLocationUpdates(){

    LatLng oldLatLng = const LatLng(0, 0);

    streamSubscriptionDriverLivePosition = Geolocator.getPositionStream().listen((Position position) {

      driverCurrentPosition = position;
      onlineDriverCurrentPosition = position;

      LatLng latLngLiveDriverPosition = LatLng(
          onlineDriverCurrentPosition!.latitude,
          onlineDriverCurrentPosition!.longitude
      );

      Marker animatingMarker = Marker(
        markerId: const MarkerId("AnimatedMarker"),
        position: latLngLiveDriverPosition,
        icon: movingVehicleIcon!,
        infoWindow: const InfoWindow(title: "This is your Position"),


      );
      setState(() {
         CameraPosition cameraPosition = CameraPosition(target:latLngLiveDriverPosition, zoom: 16);
         newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

         markerSet.removeWhere((element) => element.markerId.value == "AnimatedMarker");
         markerSet.add(animatingMarker);
      });

      oldLatLng = latLngLiveDriverPosition;
      updateTripDetails();

      // update driver live location on FBDatabase//
      Map driverLatLngDataMap = {
        "latitude": onlineDriverCurrentPosition!.latitude.toString(),
        "longitude": onlineDriverCurrentPosition!.longitude.toString(),
      };
      FirebaseDatabase.instance.ref()
          .child("rideRequest")
          .child(widget.userRideRequestDetails!.rideRequestId!)
          .child("driver_location").set(driverLatLngDataMap);
    });
  }

  void updateTripDetails()async{

    if(requestDirectionDetails == false){

      requestDirectionDetails = true;

      if(onlineDriverCurrentPosition == null){
        return;
      }
      var positionLatLng = LatLng(onlineDriverCurrentPosition!.latitude, onlineDriverCurrentPosition!.longitude);

      var destinationLatLng;

      if(rideRequestStatus == "accepted"){
        destinationLatLng = widget.userRideRequestDetails!.originLatLng;

      } else{
        destinationLatLng = widget.userRideRequestDetails!.destinationLatLng;
      }
      var directionInformation = await AssistantMethods.pickupToDestinationDirections(positionLatLng, destinationLatLng);

      if(directionInformation != null){

        setState(() {
          durationFromOriginToDestination  = directionInformation.duration_text!;
        });
      }
      requestDirectionDetails = false;
    }
  }

  void startTimer(){
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {

      durationCounter++;
    });
  }

 Future <void> drawPolylineFromPickupToDestination(LatLng originLatLng, LatLng destinationLatLng) async{

    var directionsDetailsInfo = await AssistantMethods.pickupToDestinationDirections(originLatLng, destinationLatLng);


    // Navigator.pop(context);

    print("These are point =");
    print(directionsDetailsInfo!.encoded_points);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsList = polylinePoints.decodePolyline(directionsDetailsInfo.encoded_points!);

    polyLineCoordinates.clear();

    if(decodedPolylinePointsList.isNotEmpty){
      decodedPolylinePointsList.forEach((PointLatLng pointLatLng) {
        polyLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));

      });

    }

    polyLines.clear();

    setState(() {
      Polyline polyline = Polyline(
          color: Colors.deepPurpleAccent,
          polylineId:const PolylineId("PolylineID"),
          jointType: JointType.round,
          points: polyLineCoordinates,
          startCap: Cap.squareCap,
          endCap: Cap.roundCap,
          geodesic: true,
          width: 5

      );

      polyLines.add(polyline);
    });

    LatLngBounds latLngBounds;

    if(originLatLng.latitude > destinationLatLng.latitude
        && originLatLng.longitude > destinationLatLng.longitude){

      latLngBounds = LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);

    } else if(originLatLng.longitude > destinationLatLng.longitude){

      latLngBounds = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude)
      );

    }
    else if(originLatLng.latitude > destinationLatLng.latitude){

      latLngBounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
          northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude)
      );

    } else{

      latLngBounds = LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);

    }
    newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 65));

    Marker pickupMarker = Marker(
      markerId: const MarkerId("pickupID"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );

    setState(() {
      markerSet.add(pickupMarker);
      markerSet.add(destinationMarker);
    });

    Circle pickupCircle = Circle(
      circleId: const CircleId("pickupID"),
      fillColor: Colors.white,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.white,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    setState(() {
      circleSet.add(pickupCircle);
      circleSet.add(destinationCircle);
    });
  }



}
