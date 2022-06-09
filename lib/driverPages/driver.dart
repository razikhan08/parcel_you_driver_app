import 'dart:core';

import 'package:firebase_database/firebase_database.dart';
import 'package:parcel_you_driver_app/models/user_model.dart';

class Driver {

  String? name;
  String? email;
  String? phone;
  String? id;
  String? vehicleModel;
  String? vehicleColor;
  String? vehiclePlateNumber;

  Driver({
    this.name,
    this.email,
    this.phone,
    this.id,
    this.vehicleModel,
    this.vehicleColor,
    this.vehiclePlateNumber,

  });

  Driver.fromSnapshot(DataSnapshot snap) {
    id = snap.key;
    name = (snap.value as dynamic)["name"];
    phone = (snap.value as dynamic)["number"];
    email = (snap.value as dynamic)["email"];
    vehicleColor = (snap.value as dynamic)["vehicle_details"]["vehicle_color"];
    vehicleModel = (snap.value as dynamic)["vehicle_details"]["vehicle_model"];
    vehiclePlateNumber =
    (snap.value as dynamic)["vehicle_details"]["vehicle_plate_number"];
  }



}