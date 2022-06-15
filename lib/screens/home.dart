/// Created by Amin BADH on 14 Jun, 2022

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sosite/screens/home/home_assistant.dart';
import 'package:sosite/screens/home/home_disabled.dart';
import 'package:sosite/utils/Data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    if (DataSingleton.userDoc?.get('role') == "Disabled") {
      return const HomeDisabledScreen();
    } else if (DataSingleton.userDoc?.get('role') == "Assistant") {
      return const HomeAssistantScreen();
    } else {
      /// TODO error screen.
      return const Scaffold();
    }
  }
}
