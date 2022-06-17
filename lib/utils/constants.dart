/// Created by Amin BADH on 14 Jun, 2022

import 'package:flutter/material.dart';

class Constants {

  static const String localeKey = "LOCALEKEY";
  static const String embKey = "EMBKEY";

  static void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(text),
        // duration: const Duration(seconds: 10),
      ),
    );
  }

  static void showSnackBarResp(BuildContext context, String text) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(text),
        margin: MediaQuery.of(context).size.width > 500
            ? EdgeInsets.fromLTRB(15.0, 5.0, MediaQuery.of(context).size.width - 500, 10.0)
            : null,
        duration: Duration(milliseconds: text.length * 75),
      ),
    );
  }

  /// Returns the InputDecoration used in most of the text fields in the app.
  static InputDecoration inputDecoration(String labelText, String hintText, BuildContext context) {
    return InputDecoration(
      alignLabelWithHint: true,
      labelText: labelText,
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.onSurface.withOpacity(.6), width: 1.0)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error.withOpacity(.6), width: 1.0)),
      focusedErrorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1.0)),
    );
  }

  /// Returns the InputDecoration used in most of the text fields in the app in light mode.
  static InputDecoration inputDecorationLight(String hintText, BuildContext context) {
    return InputDecoration(
      alignLabelWithHint: true,
      labelText: hintText,
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(.6), width: 1.0)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error.withOpacity(.6), width: 1.0)),
      focusedErrorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1.0)),
    );
  }

  /// Returns the text link color.
  static Color getLinkColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary.withOpacity(.8);
  }
}
