import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:parcel_you_driver_app/global/global.dart';
import 'package:parcel_you_driver_app/mainScreens/home_screen.dart';
import 'package:parcel_you_driver_app/splashScreen/splash_screen.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({Key? key}) : super(key: key);

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {


  TextEditingController carModelTextController = TextEditingController();
  TextEditingController carNumberTextController = TextEditingController();
  TextEditingController carColorTextController = TextEditingController();

  List<String> vehicleTypeList = ["Sedan", "Pickup Truck", "Van", "Minivan",];
  String? selectedVehicleType;

  validateForm(){
    if(carModelTextController.text.isEmpty && carColorTextController.text.isEmpty && carNumberTextController.text.isEmpty){
      Fluttertoast.showToast(msg: 'Please fill in all the required fields');
    }
    else if (carModelTextController.text.isEmpty){
      Fluttertoast.showToast(msg: 'Please enter a valid car model');
    }

    else if(carNumberTextController.text.isEmpty){
      Fluttertoast.showToast(msg: 'Please enter a valid license plate');
    }
    else if(carColorTextController.text.isEmpty){
      Fluttertoast.showToast(msg: 'Please enter a valid vehicle color');
    }
    else if(vehicleTypeList.toString().isEmpty){
      Fluttertoast.showToast(msg: 'Please select a valid vehicle type');
    }
    else {
      saveVehicleInfo();
    }
  }

  saveVehicleInfo(){
    Map driverVehicleInfoMap = {
      "vehicle_model": carModelTextController.text.trim(),
      "vehicle_plate_number": carNumberTextController.text.trim(),
      "vehicle_color": carColorTextController.text.trim(),
      "type": selectedVehicleType,
    };

    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
    driversRef.child(currentFirebaseUser!.uid).child("vehicle_details").set(driverVehicleInfoMap);

    Fluttertoast.showToast(msg: "Setting up your account");
    Navigator.push(context, MaterialPageRoute(builder: (c) => const MySplashScreen()));


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              const SizedBox(height: 50,),

              const Padding(padding: EdgeInsets.all(20.0),
                child: Text("Vehicle details",
                style: TextStyle(
                  fontSize: 20,fontWeight: FontWeight.bold,
                ),
                ),
              ),
              SizedBox(
                width: 350,
                child: TextFormField(
                    controller: carModelTextController,
                    decoration: const InputDecoration(
                      hintText: 'Vehicle Model',
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
              //car model field//
             const SizedBox(height: 10,),

              SizedBox(
                width: 350,
                child: TextFormField(
                    controller: carNumberTextController,
                    decoration: const InputDecoration(
                      hintText: 'License Plate',
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
              //car number field//
              SizedBox(height: 10,),

              SizedBox(
                width: 350,
                child: TextFormField(
                    controller: carColorTextController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      hintText: 'Vehicle Color',
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
              //car color field//
              const SizedBox(height: 10,),

              SizedBox(
                width: 350,
                child: DropdownButton(
                  isExpanded: true,

                  hint: const Text("Type of Vehicle"),
                  value: selectedVehicleType,
                  onChanged: (newValue){
                    setState(() {
                      selectedVehicleType = newValue.toString();
                    });
                  },
                  items: vehicleTypeList.map((vehicle) {
                    return DropdownMenuItem(child:Text(
                      vehicle,
                      style: const TextStyle(color: Colors.black),
                    ),
                      value: vehicle,

                    );
                  }).toList(),

                ),
              ),
              // Type of vehicle dropdown//

              SizedBox(height: 30),

              Container(
                width: 350,
                child: ElevatedButton (
                  onPressed: () {
                    validateForm();
                  },
                  child: const Text('Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 100,vertical: 15),
                    primary: Colors.black,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero)),
                    elevation:0,
                    shadowColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),

        ),
      );
  }
}
