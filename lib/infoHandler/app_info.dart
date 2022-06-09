import 'package:flutter/material.dart';

import '../models/directions.dart';

class AppData extends ChangeNotifier{

Directions? userPickUpLocation, userDropoffLocation;

void updatePickUpLocationAddress(Directions userPickUpAddress){


  userPickUpLocation = userPickUpAddress;
  notifyListeners();

}

void updateDropoffLocationAddress(Directions userDropoffAddress){

  userDropoffLocation = userDropoffAddress;
  notifyListeners();

}

}