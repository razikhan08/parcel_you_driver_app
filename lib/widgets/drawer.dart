import 'package:flutter/material.dart';
import 'package:parcel_you_driver_app/driverPages/help.dart';
import 'package:parcel_you_driver_app/driverPages/my_deliveries.dart';
import 'package:parcel_you_driver_app/driverPages/my_earnings.dart';
import 'package:parcel_you_driver_app/driverPages/my_ratings.dart';
import 'package:parcel_you_driver_app/driverPages/settings.dart';
import 'package:parcel_you_driver_app/global/global.dart';
import 'package:parcel_you_driver_app/splashScreen/splash_screen.dart';

class MyDrawer extends StatefulWidget {

  String? name;
  MyDrawer({this.name});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  logoutButtonDialog(BuildContext context) {

    Widget cancelButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel')
    );
    Widget logOutButton = TextButton(
        onPressed: () {
          fAuth.signOut();
          Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
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

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: 270,
        child: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
              children:<Widget>[
                Container(height: 165,
                color: Colors.grey,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ) ,
                      child: Row(
                        children:  [
                          const Icon(Icons.person,
                            size: 40,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 16),

                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 50,),
                              Text(userModelCurrentInfo!.name!.toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(height: 30,),
                              const Text("View Profile",
                                style: TextStyle(fontSize: 15, color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => MyDeliveries()));
                  },
                  child:const ListTile(
                    title: Text('My Deliveries'),
                    leading: Icon(Icons.history,color: Colors.black,),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => MyRatings()));
                  },
                  child: const ListTile(
                    title: Text('My Rating'),
                    leading: Icon(Icons.star,color: Colors.black,),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => MyEarnings()));
                  },
                  child: const ListTile(
                    title: Text('My Earnings'),
                    leading: Icon(Icons.payment,color: Colors.black,),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => Settings()));
                  },
                  child: const ListTile(
                    title: Text('Settings'),
                    leading: Icon(Icons.settings,color: Colors.black,),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => Help()));
                  },
                  child: const ListTile(
                    title: Text('Help'),
                    leading: Icon(Icons.help,color: Colors.black,),
                  ),
                ),
                SizedBox(height: 250,),
                GestureDetector(
                  onTap: (){
                    logoutButtonDialog(context);
                  },
                  child:const ListTile(
                    title: Text('Log Out',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold
                    ),
                    ),
                    leading: Icon(Icons.logout,color: Colors.black,),
                  ),
                ),
              ],
            ),
        ),
      );
  }
}
