/// Created by Amin BADH on 15 Jun, 2022 *

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosite/screens/get_help/get_help_info.dart';
import 'package:sosite/screens/request_details.dart';
import 'package:sosite/utils/constants.dart';
import 'package:sosite/screens/history.dart';
import 'package:sosite/screens/wallet.dart';
import 'package:sosite/utils/Data.dart';
import 'package:sosite/utils/Utils.dart';
import 'package:sosite/widgets/app_drawer.dart';
import 'package:sosite/widgets/gradient_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeDisabledScreen extends StatefulWidget {
  const HomeDisabledScreen({Key? key}) : super(key: key);

  @override
  State<HomeDisabledScreen> createState() => _HomeDisabledScreenState();
}

class _HomeDisabledScreenState extends State<HomeDisabledScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .where('from', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .where('state', whereIn: ["waiting", "active", "completeAssistant", "completeDisabled"]).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          Constants.showSnackBar(context, snapshot.error.toString());
          if (kDebugMode) {
            print(snapshot.error.toString());
          }
        }

        return Scaffold(
          key: _key,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () => _key.currentState!.openDrawer(),
                      icon: const Icon(Icons.menu, size: 32),
                      splashRadius: 28,
                      tooltip: appLocal.menu,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: NoGlowScrollBehaviour(),
                    child: ListView(
                      children: [
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 36),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GradientText(
                                "${appLocal.hey} ${DataSingleton.userDoc?.get('firstName')}!",
                                gradient: LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                  ],
                                ),
                                style: Theme.of(context).textTheme.headline5?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                    ),
                              ),
                              const SizedBox(height: 46),
                              Card(
                                color: Colors.grey[100],
                                child: Builder(
                                  builder: (context) {
                                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                                      String? state;

                                      try {
                                        state = snapshot.data?.docs[0].get("state");
                                      } catch (e) {
                                        state = null;
                                      }

                                      if ((state ?? '') == 'waiting') {
                                        return SizedBox(
                                          height: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(24, 12, 18, 0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Opacity(
                                                      opacity: 0.9,
                                                      child: Text(
                                                        appLocal.waitingForApproval,
                                                        style: Theme.of(context).textTheme.headline6?.copyWith(
                                                              fontWeight: FontWeight.w600,
                                                              letterSpacing: 1,
                                                              fontSize: 16,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: ClipRect(
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment: const Alignment(0, 1),
                                                          child: SizedBox(
                                                            child: Image.asset('assets/images/clock-money.png'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      } else if ((state ?? '') == 'active' || (state ?? '') == 'completeAssistant') {
                                        return InkWell(
                                          customBorder: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => RequestDetailsScreen(
                                                requestDoc: snapshot.data!.docs[0],
                                              ),
                                            ),
                                          ),
                                          child: SizedBox(
                                            height: 200,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(24, 12, 18, 0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Opacity(
                                                        opacity: 0.9,
                                                        child: Text(
                                                          appLocal.ongoingRequest,
                                                          style: Theme.of(context).textTheme.headline6?.copyWith(
                                                                fontWeight: FontWeight.w600,
                                                                letterSpacing: 1,
                                                                fontSize: 16,
                                                              ),
                                                        ),
                                                      ),
                                                      Container(
                                                        height: 24,
                                                        width: 24,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[800],
                                                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                        ),
                                                        child: Align(
                                                          alignment: const Alignment(0.2, 0),
                                                          child: Icon(
                                                            Icons.arrow_forward_ios,
                                                            color: Colors.grey[50],
                                                            size: 16,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Expanded(
                                                    flex: 1,
                                                    child: ClipRect(
                                                      child: Stack(
                                                        children: [
                                                          Align(
                                                            alignment: const Alignment(0, 1),
                                                            child: SizedBox(
                                                              height: 130,
                                                              child: Image.asset(
                                                                'assets/images/helping-disabled-woman.png',
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return SizedBox(
                                          height: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(24, 12, 18, 0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Opacity(
                                                      opacity: 0.9,
                                                      child: Text(
                                                        appLocal.waitingForAssistant,
                                                        style: Theme.of(context).textTheme.headline6?.copyWith(
                                                              fontWeight: FontWeight.w600,
                                                              letterSpacing: 1,
                                                              fontSize: 16,
                                                            ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 24,
                                                      width: 24,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[800],
                                                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                      ),
                                                      child: Align(
                                                        alignment: const Alignment(0.2, 0),
                                                        child: Icon(
                                                          Icons.arrow_forward_ios,
                                                          color: Colors.grey[50],
                                                          size: 16,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: ClipRect(
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment: const Alignment(0, 1),
                                                          child: SizedBox(
                                                            child: Image.asset('assets/images/clock-money.png'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      return InkWell(
                                        customBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        onTap: () => Navigator.of(context).pushNamed(GetHelpInfoScreen.routeName),
                                        child: SizedBox(
                                          height: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(24, 12, 18, 0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Opacity(
                                                      opacity: 0.9,
                                                      child: Text(
                                                        appLocal.getHelp,
                                                        style: Theme.of(context).textTheme.headline6?.copyWith(
                                                              fontWeight: FontWeight.w600,
                                                              letterSpacing: 1,
                                                            ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 24,
                                                      width: 24,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[800],
                                                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                                                      ),
                                                      child: Align(
                                                        alignment: const Alignment(0.2, 0),
                                                        child: Icon(
                                                          Icons.arrow_forward_ios,
                                                          color: Colors.grey[50],
                                                          size: 16,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: ClipRect(
                                                    child: Stack(
                                                      children: [
                                                        Align(
                                                          alignment: const Alignment(-1, 3),
                                                          child: SizedBox(
                                                            height: 150,
                                                            child: Image.asset('assets/images/boy-waiving-hand.png'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: 46),
                              InkWell(
                                customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                onTap: () => Navigator.pushNamed(context, WalletScreen.routeName),
                                child: ListTile(
                                  title: Text(
                                    appLocal.wallet,
                                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                  ),
                                  iconColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                                  leading: const Icon(Icons.wallet),
                                ),
                              ),
                              const SizedBox(height: 12),
                              InkWell(
                                customBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                onTap: () => Navigator.pushNamed(context, HistoryScreen.routeName),
                                child: ListTile(
                                  title: Text(
                                    appLocal.history,
                                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 1,
                                        ),
                                  ),
                                  iconColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                                  leading: const Icon(Icons.history),
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          drawer: AppDrawer(
            selected: 'home',
            rebuild: () => setState(() {}),
          ),
          floatingActionButton: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
              if (snapshot.hasData) {
                bool emb = snapshot.data!.getBool(Constants.embKey) ?? true;
                return emb
                    ? Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context).colorScheme.copyWith(secondary: Colors.red[900]),
                        ),
                        child: FloatingActionButton.extended(
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                          onPressed: () {
                            Constants.showSnackBar(context, appLocal.featureUnderDev);
                          },
                          label: Text(
                            appLocal.callEmergency,
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                  color: Theme.of(context).colorScheme.background,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                          ),
                        ),
                      )
                    : const SizedBox();
              } else {
                return const SizedBox();
              }
            },
          ),
        );
      },
    );
  }
}
