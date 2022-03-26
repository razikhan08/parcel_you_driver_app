import 'package:flutter/material.dart';
import 'package:parcel_you_driver_app/futureUseScreens/get_started_screen.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.deepPurpleAccent,
        body: Column(
          children: <Widget>[
            SizedBox(height: 300,),
             const Text('ParcelYou Driver',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 300),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
              child: Center(
                child: Container(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(onPressed: () => {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>  GetStartedPage()))
                  },
                    child: const Text('Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
                      elevation: 0,
                      shadowColor: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: const Text('Get it delivered with ParcelYou',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ],

        ),
      ),
    );
  }
}

