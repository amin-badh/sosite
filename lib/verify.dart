/// Created by Amin BADH on 14 Jun, 2022

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sosite/screens/create_account.dart';
import 'package:sosite/screens/home.dart';

class Verify extends StatelessWidget {
  const Verify({Key? key}) : super(key: key);
  static const routeName = '/verify';

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final db = FirebaseFirestore.instance;
    
    return Scaffold(
      body: FutureBuilder(
        future: db.collection('users').doc(auth.currentUser?.uid).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            if (snapshot.hasData) {
              if (snapshot.data!.exists) {
                Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (Route<dynamic> route) => false);
              } else {
                Navigator.of(context).pushNamed(CreateAccountScreen.routeName);
              }
            } else if (snapshot.hasError) {
              if (kDebugMode) {
                print(snapshot.error.toString());
              }
            }
          });
          return const SizedBox();
        },
      ),
    );
  }
}
