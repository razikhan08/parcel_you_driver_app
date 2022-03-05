
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parcel_you_driver_app/infoHandler/app_info.dart';
import 'package:parcel_you_driver_app/splashscreen/splash_screen.dart';
import 'package:provider/provider.dart';


Future<void> main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
     ParcelYouDriver(
        child: ChangeNotifierProvider(
          create: (context) => AppInfo(),
          child: MaterialApp(
            home: MySplashScreen(),
            debugShowCheckedModeBanner: false,

          ),
        ),
    ),
  );
}

class ParcelYouDriver extends StatefulWidget {

  final Widget? child;
  
   ParcelYouDriver({this.child});
  
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_ParcelYouDriverState>()!.restartApp();
  }
  
  
  
  @override
  _ParcelYouDriverState createState() => _ParcelYouDriverState();
}

class _ParcelYouDriverState extends State<ParcelYouDriver> {
  
  Key key = UniqueKey();
  void restartApp()
  {
    setState(() {
      key = UniqueKey();
    });
  }
  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
        child: widget.child!,

    );
  }
}

 

