/// Created by Amin BADH on 14 Jun, 2022

import 'package:flutter/material.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);
  static const routeName = '/create_account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Create Account", style: Theme.of(context).textTheme.headline3),
      ),
    );
  }
}
