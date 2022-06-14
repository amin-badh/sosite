import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Created by Amin BADH on 14 Jun, 2022

class Themes {
  static ThemeData appThemeData() {
    return ThemeData.light().copyWith(
      primaryColor: const Color(0xff356FCC),
      colorScheme: ColorScheme(
          primary: const Color(0xff356FCC),
          secondary: const Color(0xFFbd4301),
          surface: Colors.grey[50]!,
          background: Colors.grey[50]!,
          error: Colors.red[700]!,
          onPrimary: Colors.grey[50]!,
          onSecondary: Colors.grey[50]!,
          onSurface: Colors.grey[900]!,
          onBackground: Colors.grey[900]!,
          onError: Colors.grey[50]!,
          brightness: Brightness.light),
      textTheme: TextTheme(
        bodyText1: GoogleFonts.inter().copyWith(color: Colors.grey[900]),
        bodyText2: GoogleFonts.inter().copyWith(
          color: Colors.grey[900],
          fontSize: 16,
        ),
        headline6: GoogleFonts.inter().copyWith(color: Colors.grey[900]),
        headline5: GoogleFonts.inter().copyWith(color: Colors.grey[900]),
        headline4: GoogleFonts.inter().copyWith(color: Colors.grey[900]),
        headline3: GoogleFonts.inter().copyWith(color: Colors.grey[900]),
        headline2: GoogleFonts.inter().copyWith(color: Colors.grey[900]),
      ),
    );
  }
}