

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

import '../models/model_user.dart';

final FirebaseAuth fbAuth = FirebaseAuth.instance;
User? currentFirebaseUser;

UserModel? userModelCurrentInfo;
StreamSubscription<Position>? streamSubscriptionPosition;