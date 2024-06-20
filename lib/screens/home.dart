/// Created by Amin BADH on 14 Jun, 2022 *

import 'package:flutter/material.dart';
import 'package:sosite/screens/home/home_assistant.dart';
import 'package:sosite/screens/home/home_disabled.dart';
import 'package:sosite/utils/data.dart';
import 'package:sosite/widgets/error_support.dart';
import 'package:location/location.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home';
  
  testLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    
    await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    testLocation();
    if (DataSingleton.userDoc?.get('role') == "Disabled") {
      return const HomeDisabledScreen();
    } else if (DataSingleton.userDoc?.get('role') == "Assistant") {
      return const HomeAssistantScreen();
    } else {
      return const ErrorSupportScreen();
    }
  }
}
