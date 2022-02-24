import 'package:flutter/material.dart';

import 'login_screen.dart';



class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('images/MainScreen.jpg'), context);
    return MaterialApp(
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 400,
              child: Image.asset('images/MainScreen.jpg',
                fit: BoxFit.fill,
              ),
            ),
             const SizedBox(height: 20),
             const Text('Welcome to ParcelYou Driver',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              child: const Text('Want to earn? Signup and start delivering today.',
                style: TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 130),
            ElevatedButton(onPressed: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginScreen()))
            },
              child: const Text('Get Started',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 130,vertical: 15),
                primary: Colors.black,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
                elevation: 0,
                shadowColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              child: const Text('Get it delivered with ParcelYou',
                style: TextStyle(
                  decoration: TextDecoration.underline,
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

