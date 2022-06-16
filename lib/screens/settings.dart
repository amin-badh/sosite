/// Created by Amin BADH on 15 Jun, 2022

import 'package:flutter/material.dart';
import 'package:sosite/screens/settings/settings_assistant.dart';
import 'package:sosite/screens/settings/settings_disabled.dart';
import 'package:sosite/utils/Data.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    if (DataSingleton.userDoc?.get('role') == "Disabled") {
      return const SettingsDisabledScreen();
    } else if (DataSingleton.userDoc?.get('role') == "Assistant") {
      return const SettingsAssistantScreen();
    } else {
      /// TODO error screen.
      return const Scaffold();
    }
  }
}
