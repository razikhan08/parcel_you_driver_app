import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:parcel_you_driver_app/Screens/welcome_screen.dart';

import 'home_screen.dart';

class TermsAndConditions extends StatefulWidget {

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel')
    );
    Widget logOutButton = TextButton(
        onPressed: () {
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

  bool _enabled = false;

  @override
  Widget build(BuildContext context) {

    var _onPressed;
    if(_enabled) {
      _onPressed = () {
        Map driverMap = {

          "terms_accepted": _enabled.toString(),
        };

        DatabaseReference driversInfo =  FirebaseDatabase.instance.ref().child("Driver's Personal Data");
        driversInfo.set(driverMap);
        Navigator.push(context, MaterialPageRoute(builder: (c) =>  HomePage()));
      };
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget> [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Tooltip(
              message: 'Log out',
              child: IconButton(icon: const Icon(Icons.logout),
                onPressed: () {
                  showAlertDialog(context);

                },
              ),
            ),
          ),
        ],
        elevation: 0,
        title: const Text('ParcelYou',
          style: TextStyle(color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.green.shade200,
      ),
      body: Column(
        children:<Widget> [

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Text('This is where the TERMS AND CONDITIONS will go'),

            ),
          ),
          Row(
            children: <Widget> [

              Checkbox(
                value: _enabled,
                onChanged: (bool? value) {
                  setState(() {
                    _enabled = value!;
                  });
                },
              ),
              Text('I have read and agree to the terms and conditions')

            ],
          ),

          SizedBox(height: 400,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ElevatedButton (
                onPressed: _onPressed,
                child: const Text('Contnue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 130,vertical: 15),
                  primary: Colors.black,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
                  elevation:0,
                  shadowColor: Colors.black,
                ),
              ),
            ),
          ),
        ],
          ),
    );
  }
}

