/// Created by Amin BADH on 14 Jun, 2022

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sosite/screens/home.dart';
import 'package:sosite/screens/sign_in.dart';
import 'package:sosite/utils/themes.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOSITE',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      navigatorKey: _navigatorKey,
      theme: Themes.appThemeData(),
      routes: {
        SignInScreen.routeName: (context) => const SignInScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
      },
      home: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (_, snapshot) {
          /// TODO
          if (snapshot.hasError) return const SizedBox();

          if (snapshot.connectionState == ConnectionState.done) {
            FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false);

            FirebaseAuth.instance.userChanges().listen((User? user) {
              if (user == null) {
                _navigatorKey.currentState!.pushReplacementNamed(SignInScreen.routeName);
              } else {
                _navigatorKey.currentState!.pushReplacementNamed(HomeScreen.routeName);
              }
            });
          }

          /// TODO: Loading Screen
          return const Scaffold();
        },
      ),
    );
  }
}
