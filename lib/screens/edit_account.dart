/// Created by Amin BADH on 15 Jun, 2022 *

import 'package:flutter/material.dart';
import 'package:sosite/screens/edit_account/edit_account_assistant.dart';
import 'package:sosite/screens/edit_account/edit_account_disabled.dart';
import 'package:sosite/utils/Data.dart';
import 'package:sosite/widgets/error_support.dart';

class EditAccountScreen extends StatelessWidget {
  const EditAccountScreen({Key? key}) : super(key: key);
  static const routeName = '/edit_account';

  @override
  Widget build(BuildContext context) {
    if (DataSingleton.userDoc?.get('role') == "Disabled") {
      return const EditAccountDisabledScreen();
    } else if (DataSingleton.userDoc?.get('role') == "Assistant") {
      return const EditAccountAssistantScreen();
    } else {
      return const ErrorSupportScreen();
    }
  }
}
