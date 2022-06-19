/// Created by Amin BADH on 19 Jun, 2022

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosite/screens/request_details/request_details_assistant.dart';
import 'package:sosite/screens/request_details/request_details_disabled.dart';
import 'package:sosite/utils/Data.dart';

class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen({Key? key, required this.requestDoc}) : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> requestDoc;

  @override
  Widget build(BuildContext context) {
    if (DataSingleton.userDoc?.get('role') == "Disabled") {
      return RequestDetailsDisabledScreen(requestDoc: requestDoc);
    } else if (DataSingleton.userDoc?.get('role') == "Assistant") {
      return RequestDetailsAssistantScreen(requestDoc: requestDoc);
    } else {
      /// TODO error screen.
      return const Scaffold();
    }
  }
}