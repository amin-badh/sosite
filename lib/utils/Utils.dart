/// Created by Amin BADH on 15 Jun, 2022

import 'package:flutter/material.dart';

class NoGlowScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}