import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserRideRequestInformation {

LatLng? pickupLatLng;
LatLng? destinationLatLng;
String? pickupAddress;
String? destinationAddress;
String? rideID;
String? userName;
String? userNumber;
String? paymentMethod;
String? receiversName;
String? receiversNumber;


UserRideRequestInformation({
  this.pickupLatLng,
  this.destinationLatLng,
  this.pickupAddress,
  this.destinationAddress,
  this.rideID,
  this.userName,
  this.userNumber,
  this.paymentMethod,
  this.receiversName,
  this.receiversNumber,  
});
}