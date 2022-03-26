import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:parcel_you_driver_app/global/global.dart';
import '../models/user_ride_request_information.dart';
import 'method/assistant_method.dart';

class NewTripScreen extends StatefulWidget {

  UserRideRequestInformation?  userRideRequestInformation;
  NewTripScreen({this.userRideRequestInformation});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {

  double bottomMapPadding = 0;

  final Completer<GoogleMapController> _googleMapController = Completer();

  GoogleMapController? RideGoogleMapController;
  // Controller for the Map//

  static  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> _markersSet = Set<Marker>();
  Set<Circle> _circlesSet = Set<Circle>();
  Set<Polyline> _polyLineSet = Set<Polyline>();

  List<LatLng> pLineCoordinatesList = [];
  PolylinePoints polylinePoints = PolylinePoints();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:<Widget> [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomMapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            mapToolbarEnabled: true,
            myLocationButtonEnabled: true,
            trafficEnabled: true,
            compassEnabled: true,
            initialCameraPosition: _kGooglePlex,
            circles: _circlesSet,
            markers: _markersSet,
            polylines: _polyLineSet,
            onMapCreated: (GoogleMapController mapController) async {
              _googleMapController.complete(mapController);
              RideGoogleMapController = mapController;

              setState(() {
                bottomMapPadding =(Platform.isIOS) ? 255 : 270;
              });
              
              var currentLatLng = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
              var pickupLatLng = widget.userRideRequestInformation!.pickupLatLng;

              await drawPolylineFromSourceToDestination(currentLatLng, pickupLatLng);


            },
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: Platform.isIOS ? 280 : 260,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.zero,
                boxShadow: [BoxShadow(
                  color: Colors.white,
                  blurRadius: 15.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                )]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Text("14 mins"),

                    const SizedBox(height: 5,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:const <Widget> [
                        Text("Razi"),
                        Padding(padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.call),
                        ),

                      ],
                    ),

                    const SizedBox(height: 25,),

                    Row(
                      children: <Widget> [
                         const Icon(Icons.adjust_rounded),
                        SizedBox(width: 15,),

                        Expanded(
                          child: Container(
                            child: Text("Pickup Location",
                            overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],

                    ),

                    SizedBox(height: 18,),

                    Row(
                      children: <Widget> [
                        const Icon(Icons.adjust_rounded),
                        SizedBox(width: 15,),

                        Expanded(
                          child: Container(
                            child: Text("Pickup Location",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],

                    ),

                    SizedBox(height: 25,),

                      Center(
                        child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    elevation: 10,
                    primary: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                    )
                    ),
                    onPressed: (){},
                          child: Text("Arrived"),


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
  
  void acceptTrip(){
    String? rideID = widget.userRideRequestInformation!.rideID;
    rideRef = FirebaseDatabase.instance.ref().child("rideRequest").child(rideID!);
    
    rideRef!.child("status").child("accepted");

    
  }

  Future<void> drawPolylineFromSourceToDestination(LatLng sourceLatLng, destinationLatLng) async {


    var directionsDetailsInfo = await AssistantMethods
        .getOriginToDestinationDirections(sourceLatLng, destinationLatLng);

    // Navigator.pop(context);

    print("These are point = ");
    print(directionsDetailsInfo!.e_points);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolylinePointsResultList = polylinePoints
        .decodePolyline(directionsDetailsInfo.e_points!);

    pLineCoordinatesList.clear();

    if (decodedPolylinePointsResultList.isNotEmpty) {
      decodedPolylinePointsResultList.forEach((PointLatLng pointLatLng) {
        pLineCoordinatesList.add(
            LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    _polyLineSet.clear();

    setState(() {
      Polyline polyLine = Polyline(

        color: Colors.black,
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinatesList,
        startCap: Cap.squareCap,
        endCap: Cap.squareCap,
        geodesic: true,
      );

      _polyLineSet.add(polyLine);
    });

    LatLngBounds boundsLatLng;
    if (sourceLatLng.latitude > destinationLatLng.latitude &&
        sourceLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: sourceLatLng);
    }
    else if (sourceLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(sourceLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, sourceLatLng.longitude),

      );
    }
    else if (sourceLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, sourceLatLng.longitude),
        northeast: LatLng(sourceLatLng.latitude, destinationLatLng.longitude),
      );
    }
    else {
      boundsLatLng =
          LatLngBounds(southwest: sourceLatLng, northeast: destinationLatLng);
    }
    RideGoogleMapController!.animateCamera(
        CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker sourceMarker = Marker(
      markerId: const MarkerId("sourceID"),
      position: sourceLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),

    );


    Marker destinationMarker = Marker(
      markerId: const MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),

    );

    setState(() {
      _markersSet.add(sourceMarker);
      _markersSet.add(destinationMarker);
    });


    Circle originCircle = Circle(
      circleId: const CircleId("sourceID"),
      fillColor: Colors.red,
      radius: 12,
      strokeColor: Colors.blueGrey,
      strokeWidth: 3,
      center: sourceLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId("destinationID"),
      fillColor: Colors.yellow,
      radius: 12,
      strokeColor: Colors.blueGrey,
      strokeWidth: 3,
      center: destinationLatLng,
    );

    setState(() {
      _circlesSet.add(originCircle);
      _circlesSet.add(destinationCircle);
    });
  }
}
