import 'package:flutter/material.dart';

import '../models/directions.dart';

class AppInfo extends ChangeNotifier {

  Directions? userPickUpLocation, userDropOffLocation;

  void updatePickUpLocationAddress(Directions userPickUpAddress) {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }


  void updateDropOffLocationAddress(Directions userDropOffAddress) {
    userDropOffLocation = userDropOffAddress;
    notifyListeners();
  }
}

