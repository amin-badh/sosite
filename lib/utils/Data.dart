/// Created by Amin BADH on 15 Jun, 2022

import 'package:cloud_firestore/cloud_firestore.dart';

class DataSingleton {
  static final DataSingleton _singleton = DataSingleton._internal();

  factory DataSingleton() {
    return _singleton;
  }

  DataSingleton._internal();

  static DocumentSnapshot<Map<String, dynamic>>? userDoc;
  static Map<String, dynamic>? helpInfo;
}