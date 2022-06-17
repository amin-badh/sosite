/// Created by Amin BADH on 14 Jun, 2022

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosite/screens/get_help/get_help_info.dart';
import 'package:sosite/utils/constants.dart';
import 'package:sosite/screens/create_account.dart';
import 'package:sosite/screens/create_account/c_a_assistant.dart';
import 'package:sosite/screens/create_account/c_a_disable.dart';
import 'package:sosite/screens/edit_account.dart';
import 'package:sosite/screens/history.dart';
import 'package:sosite/screens/home.dart';
import 'package:sosite/screens/settings.dart';
import 'package:sosite/screens/sign_in.dart';
import 'package:sosite/screens/wallet.dart';
import 'package:sosite/utils/locale_provider.dart';
import 'package:sosite/utils/themes.dart';
import 'package:sosite/verify.dart';
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
    return ChangeNotifierProvider(
      create: (BuildContext context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        return FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                switch (snapshot.data!.getString(Constants.localeKey)) {
                  case 'en':
                    if (provider.locale != const Locale('en')) {
                      provider.setLocale(const Locale('en'));
                    }
                    break;
                  case 'fr':
                    if (provider.locale != const Locale('fr')) {
                      provider.setLocale(const Locale('fr'));
                    }
                    break;
                }
              });
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'SOSITE',
                locale: provider.locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('fr'),
                ],
                navigatorKey: _navigatorKey,
                theme: Themes.appThemeData(),
                routes: {
                  SignInScreen.routeName: (context) => const SignInScreen(),
                  VerifyAccount.routeName: (context) => const VerifyAccount(),
                  CreateAccountScreen.routeName: (context) => const CreateAccountScreen(),
                  CreateAccountDisabledScreen.routeName: (context) => const CreateAccountDisabledScreen(),
                  CreateAccountAssistantScreen.routeName: (context) => const CreateAccountAssistantScreen(),
                  VerifyRole.routeName: (context) => const VerifyRole(),
                  HomeScreen.routeName: (context) => const HomeScreen(),
                  EditAccountScreen.routeName: (context) => const EditAccountScreen(),
                  WalletScreen.routeName: (context) => const WalletScreen(),
                  HistoryScreen.routeName: (context) => const HistoryScreen(),
                  SettingsScreen.routeName: (context) => const SettingsScreen(),
                  GetHelpInfoScreen.routeName: (context) => const GetHelpInfoScreen(),
                },
                home: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle(
                    statusBarColor: Theme.of(context).scaffoldBackgroundColor,
                    systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
                    systemNavigationBarDividerColor: null,
                    systemNavigationBarIconBrightness: Brightness.dark,
                    statusBarIconBrightness: Brightness.dark,
                    statusBarBrightness: Brightness.light,
                  ),
                  child: FutureBuilder(
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
                            _navigatorKey.currentState!
                                .pushNamedAndRemoveUntil(SignInScreen.routeName, (Route<dynamic> route) => false);
                          } else {
                            _navigatorKey.currentState!
                                .pushNamedAndRemoveUntil(VerifyAccount.routeName, (Route<dynamic> route) => false);
                          }
                        });
                      }

                      /// TODO: Loading Screen
                      return const Scaffold();
                    },
                  ),
                ),
              );
            } else {
              return Container(color: Colors.grey[50]);
            }
          },
        );
      },
    );
  }
}
