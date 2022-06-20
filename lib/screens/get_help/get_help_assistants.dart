/// Created by Amin BADH on 17 Jun, 2022 *

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:sosite/screens/get_help/assistant_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssistantsScreen extends StatefulWidget {
  const AssistantsScreen({Key? key}) : super(key: key);
  static const routeName = '/get_help/assistants';

  @override
  State<AssistantsScreen> createState() => _AssistantsScreenState();
}

class _AssistantsScreenState extends State<AssistantsScreen> {
  LocationData? locationData;
  Geoflutterfire geo = Geoflutterfire();

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

    Future<List<Map<String, DocumentSnapshot<Object?>>>> getAssistants() async {
      Location location = Location();

      bool serviceEnabled;
      PermissionStatus permissionGranted;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Error();
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Error();
        }
      }

      locationData = await location.getLocation();

      final center = geo.point(latitude: locationData!.latitude!, longitude: locationData!.longitude!);

      List<DocumentSnapshot> locations = await geo
          .collection(collectionRef: FirebaseFirestore.instance.collection('locations'))
          .within(center: center, radius: 10, field: 'location', strictMode: true)
          .firstWhere((element) => true);

      if (locations.isEmpty) {
        throw Exception(appLocal.noAssistantsArea);
      }

      List<Map<String, DocumentSnapshot>> lll = [];

      for (var e in locations) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(e.id).get();
        try {
          if (userDoc.get('active') == true) {
            lll.add({'userDoc': userDoc, 'location': e});
          }
        } catch (e) {
          if (kDebugMode) {
            print(e.toString());
          }
        }
      }

      if (lll.isEmpty) {
        throw Exception(appLocal.noAssistantsArea);
      } else {
        return lll;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, size: 32),
                  splashRadius: 28,
                  tooltip: appLocal.back,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    appLocal.getHelp,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 24,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Divider(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3), height: 1),
            Expanded(
              child: FutureBuilder(
                future: getAssistants(),
                builder: (context, AsyncSnapshot<List<Map<String, DocumentSnapshot>>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        GeoFirePoint locPoint =
                            geo.point(latitude: locationData!.latitude!, longitude: locationData!.longitude!);
                        final userDoc = snapshot.data![index]['userDoc'];
                        final GeoPoint geoPoint = snapshot.data![index]['location']?.get('location')['geopoint'];
                        final String distance = "${(locPoint.distance(
                              lat: geoPoint.latitude,
                              lng: geoPoint.longitude,
                            ) * 1000).toInt()} m ${appLocal.away}";
                        return Column(
                          children: [
                            ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Container(
                                  height: 36,
                                  width: 36,
                                  color: Colors.amber,
                                ),
                              ),
                              title: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${userDoc?.get('firstName')} ${userDoc?.get('lastName')}",
                                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    distance,
                                    style: Theme.of(context).textTheme.bodyText1?.copyWith(),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                "\$2/h",
                                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => AssistantsDetailsScreen(
                                      assistantDoc: userDoc!,
                                      distance: distance,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    if (kDebugMode) {
                      print(snapshot.error.toString());
                    }
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
