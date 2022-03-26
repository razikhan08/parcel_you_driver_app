import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parcel_you_driver_app/Screens/signup_screen.dart';
import 'package:parcel_you_driver_app/widgets/screen_overlay.dart';

import '../global/global.dart';
import '../splashscreen/splash_screen.dart';
import '../widgets/progress_dialog.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin{

  validateForm(){
    if(emailTextController.text.isEmpty && passwordTextController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please fill in all the required fields');
    }
    else if(emailTextController.text.isEmpty) {
      Fluttertoast.showToast(msg: "You must enter your email");

    }
    else if(!emailTextController.text.contains("@")) {
      Fluttertoast.showToast(msg: "You must enter a valid email");
    }
    else if(passwordTextController.text.isEmpty) {
      Fluttertoast.showToast(msg: "You must enter your password");
    }
    else {
      loginDriver();
    }
  }

  loginDriver() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: 'Please wait');
        }

    );

    final User? firebaseUser = (
        await fbAuth.signInWithEmailAndPassword(
          email: emailTextController.text.trim(), password: passwordTextController.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error" + msg.toString());
        })
    ).user;

    if (firebaseUser != null) {

      DatabaseReference driversInfo =  FirebaseDatabase.instance.ref().child("Driver's Information");
      driversInfo.child(firebaseUser.uid).once().then((driverKey) {

        final snap = driverKey.snapshot;
        if(snap.value !=null) {

          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Please wait while we setup your experience");
          Navigator.push(context, MaterialPageRoute(builder: (c) =>  LoadingScreen()));
        } else {

          Fluttertoast.showToast(msg: "User does not exist");
          fbAuth.signOut();
          Navigator.pop(context);
        }
      });

    }
    else{
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Please provided information is correct");
    }

  }


  TabController? tabController;
  int selectedIndex = 0;

   onItemSelected(int index)
   {
     setState(() {
       selectedIndex = index;
       tabController!.index = selectedIndex;
     });
   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 2, vsync: this);
  }

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurpleAccent.shade200,
        elevation: 1,
        bottom:  TabBar(
          indicatorColor: Colors.white,
          controller: tabController,
          tabs: const [
            Tab(
              child: Text("Sign In",
              style: TextStyle(
                color: Colors.white,
                fontSize:18,
                fontWeight: FontWeight.bold,
              ),
              ),
            ),
            Tab(
              child: Text("New User",
                style: TextStyle(
                  color: Colors.white,
                  fontSize:18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )

          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                const Text("Welcome Back",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Form(
                    child: SizedBox(
                      width: 350,
                      child: TextFormField(
                          controller: emailTextController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedErrorBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.zero,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.black)
                            ),
                          )
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: Form(
                    child: SizedBox(
                      width: 350,
                      child: TextFormField(
                        obscureText: true,
                          controller: passwordTextController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            focusedErrorBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.zero,
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.zero,
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.black)
                            ),

                          )

                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 350,
                  height: 50,
                  child: ElevatedButton (
                    onPressed: () {
                       validateForm();

                    },
                    child: const Text('Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurpleAccent,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
                      elevation:0,
                      shadowColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SignupScreen(),

        ],
      ),
    );
  }
}
