import 'package:firebase_database/firebase_database.dart';

class userModel{
  String? number;
  String? name;
  String? id;
  String? email;

  userModel({this.name, this.number, this.email, this.id});

  userModel.fromSnapshot(DataSnapshot snap) {

    name = (snap.value as dynamic)["name"];
    number = (snap.value as dynamic)["number"];
    email = (snap.value as dynamic)["email"];
    id = snap.key;

  }
}