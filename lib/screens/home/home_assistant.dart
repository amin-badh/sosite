/// Created by Amin BADH on 15 Jun, 2022 *

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:sosite/screens/history.dart';
import 'package:sosite/screens/request_details.dart';
import 'package:sosite/screens/request_info.dart';
import 'package:sosite/screens/wallet.dart';
import 'package:sosite/utils/data.dart';
import 'package:sosite/utils/utils.dart';
import 'package:sosite/widgets/app_drawer.dart';
import 'package:sosite/widgets/gradient_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeAssistantScreen extends StatefulWidget {
  const HomeAssistantScreen({Key? key}) : super(key: key);

  @override
  State<HomeAssistantScreen> createState() => _HomeAssistantScreenState();
}

class _HomeAssistantScreenState extends State<HomeAssistantScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  StreamSubscription<LocationData>? subscription;
  Geoflutterfire geo = Geoflutterfire();

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .where('to', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .where('state', whereIn: ["active", "waiting", "completeDisabled", "completeAssistant"]).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
                                      Builder(builder: (context) {
                                        bool? active;
                                        String? state;

                                        try {
                                          active = userSnapshot.data?.get("active");
                                        } catch (e) {
                                          active = false;
                                        }

                                        try {
                                          state = snapshot.data?.docs[0].get("state");
                                        } catch (e) {
                                          state = null;
                                        }

                                        if (active ?? false) {
                                          if ((state ?? '') == "waiting") {
                                            //Request Found!
                                            return Card(
                                              color: Colors.grey[100],
                                              child: InkWell(
                                                customBorder: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          RequestInfoScreen(requestDoc: snapshot.data!.docs[0]),
                                                    ),
                                                  );
                                                },
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
                                                                appLocal.requestFound,
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
                                                                borderRadius:
                                                                    const BorderRadius.all(Radius.circular(20)),
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
                                              ),
                                            );
                                          } else {
                                            //Waiting for requests
                                            return Card(
                                              color: Colors.grey[100],
                                              child: InkWell(
                                                customBorder: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                onTap: () {
                                                  try {
                                                    FirebaseFirestore.instance
                                                        .doc(userSnapshot.data!.reference.path)
                                                        .update({
                                                      'active': false,
                                                    }).then((value) {
                                                      FirebaseFirestore.instance
                                                          .collection('locations')
                                                          .doc(FirebaseAuth.instance.currentUser!.uid)
                                                          .delete();
                                                      subscription?.cancel();
                                                    });
                                                  } catch (e) {
                                                    if (kDebugMode) {
                                                      print(e.toString());
                                                    }
                                                  }
                                                },
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
                                                                appLocal.waitingForRequests,
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
                                                                borderRadius:
                                                                    const BorderRadius.all(Radius.circular(20)),
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
                                                ),
                                              ),
                                            );
                                          }
                                        } else {
                                          if ((state ?? '') == "active" || (state ?? '') == "completeDisabled") {
                                            //Ongoing Request!
                                            return Card(
                                              color: Colors.grey[100],
                                              child: InkWell(
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
                                                                borderRadius:
                                                                    const BorderRadius.all(Radius.circular(20)),
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
                                              ),
                                            );
                                          } else if ((state ?? '') == "completeAssistant") {
                                            return Card(
                                              color: Colors.grey[50],
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
                                                              appLocal.waitingForClient,
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
                                              ),
                                            );
                                          } else {
                                            //Start Helping
                                            return Card(
                                              color: Colors.grey[100],
                                              child: InkWell(
                                                customBorder: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                onTap: () async {
                                                  Location location = Location();

                                                  bool serviceEnabled;
                                                  PermissionStatus permissionGranted;

                                                  serviceEnabled = await location.serviceEnabled();
                                                  if (!serviceEnabled) {
                                                    serviceEnabled = await location.requestService();
                                                    if (!serviceEnabled) {
                                                      return;
                                                    }
                                                  }

                                                  permissionGranted = await location.hasPermission();
                                                  if (permissionGranted == PermissionStatus.denied) {
                                                    permissionGranted = await location.requestPermission();
                                                    if (permissionGranted != PermissionStatus.granted) {
                                                      return;
                                                    }
                                                  }

                                                  try {
                                                    FirebaseFirestore.instance
                                                        .doc(userSnapshot.data!.reference.path)
                                                        .update({
                                                      'active': true,
                                                    }).then((value) {
                                                      GeoFirePoint? oldLoc;
                                                      subscription = location.onLocationChanged.listen((locationData) {
                                                        GeoFirePoint locD = geo.point(
                                                          latitude: locationData.latitude!,
                                                          longitude: locationData.longitude!,
                                                        );

                                                        if ((oldLoc == null ||
                                                                (locD.distance(
                                                                        lat: oldLoc?.data['geopoint'].latitude!,
                                                                        lng: oldLoc?.data['geopoint'].longitude!) >
                                                                    10)) &&
                                                            locationData.latitude != null &&
                                                            locationData.longitude != null) {
                                                          FirebaseFirestore.instance
                                                              .collection('locations')
                                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                                              .set({'location': locD.data}).then((value) {
                                                            oldLoc = locD;
                                                          });
                                                        }
                                                      });
                                                    });
                                                  } catch (e) {
                                                    if (kDebugMode) {
                                                      print(e.toString());
                                                    }
                                                  }
                                                },
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
                                                                appLocal.startHelping,
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
                                                                borderRadius:
                                                                    const BorderRadius.all(Radius.circular(20)),
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
                                                                    child: Image.asset(
                                                                        'assets/images/boy-waiving-hand.png'),
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
                                              ),
                                            );
                                          }
                                        }
                                      }),
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
                                        onTap: () {
                                          Navigator.pushNamed(context, HistoryScreen.routeName);
                                        },
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
                );
              });
        });
  }
}
