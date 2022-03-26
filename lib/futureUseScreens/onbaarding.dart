import 'package:flutter/material.dart';
import 'package:parcel_you_driver_app/Screens/welcome_screen.dart';
import 'package:parcel_you_driver_app/global/global.dart';

class DriverOnboarding extends StatefulWidget {

  @override
  State<DriverOnboarding> createState() => _DriverOnboardingState();
}

class _DriverOnboardingState extends State<DriverOnboarding> {

 bool profilePhoto = false;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children:<Widget>[
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Welcome,",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
             //Profile Photo
            GestureDetector(
              onTap: () {
                setState(() {
                  profilePhoto = true;
                });
              },
              child: const Card(
                elevation: 3,
                child: ListTile(
                  leading: Icon(Icons.article,color: Colors.deepPurpleAccent,),
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 8, 10),
                    child: Text("Profile photo",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Text("This will appear in your driver portal"),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepPurpleAccent),
                ),
              ),
            ),

             //Vehicle Details
             GestureDetector(
               onTap: () {},
               child: const Card(
                 elevation: 3,
                child: ListTile(
                  leading: Icon(Icons.article,color: Colors.deepPurpleAccent,),
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 8, 10),
                    child: Text("Vehicle details",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Text("Add the color, year, make and model of your vehicle"),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepPurpleAccent),
                ),
            ),
             ),

            // Driver's License
            GestureDetector(
              onTap: () {},
              child: const Card(
                elevation: 3,
                child: ListTile(
                  leading: Icon(Icons.article,color: Colors.deepPurpleAccent,),
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 8, 15),
                    child: Text("Driver's license",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Text("This will help us confirm your identity"),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepPurpleAccent),
                ),
              ),
            ),

            //proof of work eligibility
            GestureDetector(
              onTap: () {},
              child: const Card(
                elevation: 3,
                child: ListTile(
                  leading: Icon(Icons.article,color: Colors.deepPurpleAccent,),
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 8, 10),
                    child: Text("Proof of work eligibility",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Text("This will help us determine you are eligible to work in your country"),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepPurpleAccent),
                ),
              ),
            ),

            //vehicle Registration
            GestureDetector(
              onTap: () {},
              child: const Card(
                elevation: 3,
                child: ListTile(
                  leading: Icon(Icons.article,color: Colors.deepPurpleAccent,),
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 8, 10),
                    child: Text("Vehicle registration",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Text("Vehicle registration is required to deliver"),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepPurpleAccent),
                ),
              ),
            ),

            //vehicle insurance
            GestureDetector(
              onTap: () {},
              child: const Card(
                elevation: 3,
                child: ListTile(
                  leading: Icon(Icons.article,color: Colors.deepPurpleAccent,),
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 8, 10),
                    child: Text("Vehicle insurance",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Text("Vehicle insurance is required to deliver"),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepPurpleAccent),
                ),
              ),
            ),

            //guidelines and expectations
            GestureDetector(
              onTap: () {},
              child: const Card(
                elevation: 3,
                child: ListTile(
                  leading: Icon(Icons.article,color: Colors.deepPurpleAccent,),
                  title: Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 8, 10),
                    child: Text("Guidelines and expectations",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Text("Please read and agree to our guidelines and expectations to start driving"),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.deepPurpleAccent),
                ),
              ),
            ),


            const SizedBox(height: 50),

            Row(
              children: const <Widget> [
                 Padding(
                   padding: EdgeInsets.all(16.0),
                   child: Text("Under Review",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                 ),

                SizedBox(height: 30,),

              ],

            ),
          ],
        ),
      ),
    );
  }
}
