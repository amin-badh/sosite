/// Created by Amin BADH on 18 Jun, 2022 *

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:sosite/screens/home.dart';
import 'package:sosite/utils/Data.dart';
import 'package:sosite/utils/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AssistantsDetailsScreen extends StatefulWidget {
  const AssistantsDetailsScreen({Key? key, required this.assistantDoc, required this.distance}) : super(key: key);
  final DocumentSnapshot assistantDoc;
  final String distance;

  @override
  State<AssistantsDetailsScreen> createState() => _AssistantsDetailsScreenState();
}

class _AssistantsDetailsScreenState extends State<AssistantsDetailsScreen> {
  final TextEditingController _tipController = TextEditingController(text: "1.00");
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

    double getTip() {
      try {
        double d = double.parse(_tipController.text);
        if ((d <= 100 && d >= 0) || d == 0) {
          return d;
        } else {
          throw Exception();
        }
      } catch (e) {
        return 0.0;
      }
    }

    bool valid = false;

    if (_formKey.currentState == null || _formKey.currentState!.validate()) {
      valid = true;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 12, 0),
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            height: 86,
                            width: 86,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.assistantDoc.get('firstName') + " " + widget.assistantDoc.get("lastName"),
                                style: Theme.of(context).textTheme.headline5?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.distance,
                                style: Theme.of(context).textTheme.headline5?.copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Builder(
                      builder: (context) {
                        int age =
                            DateTime.now().difference(widget.assistantDoc.get('birthDate').toDate()).inHours ~/ 8766;
                        String gender = widget.assistantDoc.get('gender');
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(2, 24, 14, 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.assistantDoc.get('bio')),
                              const SizedBox(height: 8),
                              Text("${appLocal.gender}: $gender"),
                              const SizedBox(height: 8),
                              Text("${appLocal.age}: $age"),
                            ],
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 24, 0),
                      child: Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _tipController,
                              style: Theme.of(context).textTheme.bodyText1,
                              decoration: Constants.inputDecoration(
                                appLocal.tipUSD,
                                "",
                                context,
                              ),
                              onChanged: (_) => setState(() {}),
                              validator: (val) => val!.trim().isNotEmpty &&
                                      ((double.parse(val) >= 0.01 && double.parse(val) <= 100) ||
                                          double.parse(val) == 0)
                                  ? null
                                  : appLocal.validTip,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    appLocal.total,
                                    style: Theme.of(context).textTheme.headline5?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                        ),
                                  ),
                                ),
                                Text(
                                  "\$${NumberFormat("#,##0.00", "en_US").format(getTip())} + \$2/h",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[700]!,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: valid
                                  ? () {
                                      FirebaseFirestore.instance
                                          .collection('requests')
                                          .where('to', isEqualTo: widget.assistantDoc.id)
                                          .where('state', whereIn: [
                                            "active",
                                            "waiting",
                                            "completeDisabled",
                                            "completeAssistant",
                                          ])
                                          .get()
                                          .then((query) {
                                            if (query.docs.isNotEmpty) {
                                              Constants.showSnackBar(context, appLocal.noOneLovesU); // JK
                                            } else {
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                                  .collection('wallet')
                                                  .doc('data')
                                                  .get()
                                                  .then(
                                                (value) {
                                                  double balance;

                                                  try {
                                                    balance = value.get('balance').toDouble();
                                                  } catch (e) {
                                                    balance = 0.0;
                                                  }

                                                  if (balance > double.parse(_tipController.text)) {
                                                    FirebaseFirestore.instance.doc(value.reference.path).update({
                                                      'balance': balance - double.parse(_tipController.text)
                                                    }).then((value) async {
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

                                                      LocationData locationData = await location.getLocation();

                                                      final center = Geoflutterfire().point(
                                                        latitude: locationData.latitude!,
                                                        longitude: locationData.longitude!,
                                                      );

                                                      FirebaseFirestore.instance
                                                          .collection('locations')
                                                          .doc(FirebaseAuth.instance.currentUser!.uid)
                                                          .set({'location': center.data}).then((value) {
                                                        FirebaseFirestore.instance.collection('requests').add({
                                                          'from': FirebaseAuth.instance.currentUser?.uid,
                                                          'to': widget.assistantDoc.id,
                                                          'issueDate': DateTime.now(),
                                                          'info': DataSingleton.helpInfo!['description'],
                                                          'tip': double.parse(_tipController.text),
                                                          'state': 'waiting',
                                                        }).then((value) {
                                                          Navigator.of(context).pushNamedAndRemoveUntil(
                                                              HomeScreen.routeName, (Route<dynamic> route) => false);
                                                        }, onError: (e) {
                                                          if (kDebugMode) {
                                                            print(e.toString());
                                                          }
                                                          Constants.showSnackBar(context, e.message);
                                                        });
                                                      }, onError: (e) {
                                                        if (kDebugMode) {
                                                          print(e.toString());
                                                        }
                                                        Constants.showSnackBar(context, e.message);
                                                      });
                                                    });
                                                  } else {
                                                    Constants.showSnackBar(context, appLocal.fucknGetAJob); // JK
                                                  }
                                                },
                                              );
                                            }
                                          }, onError: (e) {
                                            if (kDebugMode) {
                                              print(e.toString());
                                            }
                                            Constants.showSnackBar(context, e.message);
                                          });
                                    }
                                  : null,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${appLocal.hire} ${widget.assistantDoc.get('firstName')} ${widget.assistantDoc.get("lastName")}",
                                    style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          color: Theme.of(context).colorScheme.onPrimary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
