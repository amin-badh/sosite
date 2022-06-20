/// Created by Amin BADH on 19 Jun, 2022 *

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sosite/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequestDetailsDisabledScreen extends StatelessWidget {
  const RequestDetailsDisabledScreen({Key? key, required this.requestDoc}) : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> requestDoc;

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc(requestDoc.get('to')).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
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
                          appLocal.requestInfo,
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
                        Opacity(
                          opacity: 0.5,
                          child: Text(
                            appLocal.assistantUpper,
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                  letterSpacing: 2,
                                ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              height: 46,
                              width: 46,
                              color: Colors.amber,
                            ),
                          ),
                          title: Text(
                            snapshot.data?.get('firstName') + " " + snapshot.data?.get("lastName"),
                            style: Theme.of(context).textTheme.headline5?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Opacity(
                          opacity: 0.5,
                          child: Text(
                            appLocal.descriptionUpper,
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                  letterSpacing: 2,
                                ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(requestDoc.get('info'), style: Theme.of(context).textTheme.bodyText1),
                        const SizedBox(height: 32),
                        Opacity(
                          opacity: 0.5,
                          child: Text(
                            appLocal.locationUpper,
                            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                  letterSpacing: 2,
                                ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                DocumentSnapshot<Map<String, dynamic>> locationDoc = await FirebaseFirestore.instance
                                    .collection('locations')
                                    .doc(requestDoc.get('to'))
                                    .get();
                                GeoPoint point = locationDoc.get('location')['geopoint'];
                                Uri googleUri = Uri.parse(
                                  'https://www.google.com/maps/search/?api=1&query=${point.latitude},${point.longitude}',
                                );
                                if (await canLaunchUrl(googleUri)) {
                                  await launchUrl(googleUri);
                                } else {
                                  throw 'Could not open the map.';
                                }
                              },
                              child: Opacity(
                                opacity: 0.8,
                                child: Text(
                                  appLocal.openMapsUpper,
                                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                        letterSpacing: 2,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      appLocal.payment,
                                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                            fontSize: 18,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    "\$${NumberFormat("#,##0.00", "en_US").format(requestDoc.get('tip'))} + \$2/h",
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 46,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red[700]!,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(requestDoc.get('to'))
                                            .collection('wallet')
                                            .doc('data')
                                            .get()
                                            .then((valueTo) {
                                          double balance = double.parse(valueTo.get('balance').toString());
                                          DateTime activeDate = requestDoc.get('activeDate').toDate();
                                          double fee = (DateTime.now().difference(activeDate).inSeconds / 3600) * 2;
                                          fee = double.parse(fee.toStringAsFixed(2));
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(requestDoc.get('from'))
                                              .collection('wallet')
                                              .doc('data')
                                              .get()
                                              .then((value) {
                                            FirebaseFirestore.instance
                                                .doc(value.reference.path)
                                                .update({'balance': value.get('balance') - fee}).then((value) {
                                              FirebaseFirestore.instance
                                                  .doc(valueTo.reference.path)
                                                  .update({'balance': balance + fee + requestDoc.get('tip')}).then(
                                                      (value) {
                                                FirebaseFirestore.instance
                                                    .doc(requestDoc.reference.path)
                                                    .update({'state': "canceled"}).then(
                                                  (value) => Navigator.of(context).pop(),
                                                  onError: (e) {
                                                    if (kDebugMode) {
                                                      print(e.toString());
                                                    }
                                                    Constants.showSnackBar(context, e.message);
                                                  },
                                                );
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
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.close,
                                            color: Colors.grey[50],
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            appLocal.cancel,
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
                                  SizedBox(
                                    height: 46,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green[700]!,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                      onPressed: () {
                                        FirebaseFirestore.instance.doc(requestDoc.reference.path).get().then((value) {
                                          String state = value.get('state');
                                          if (state == 'completeAssistant') {
                                            /// TODO: negative balance
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(requestDoc.get('to'))
                                                .collection('wallet')
                                                .doc('data')
                                                .get()
                                                .then((valueTo) {
                                              double balance = double.parse(valueTo.get('balance').toString());
                                              DateTime activeDate = requestDoc.get('activeDate').toDate();
                                              double fee = (DateTime.now().difference(activeDate).inSeconds / 3600) * 2;
                                              fee = double.parse(fee.toStringAsFixed(2));
                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(requestDoc.get('from'))
                                                  .collection('wallet')
                                                  .doc('data')
                                                  .get()
                                                  .then((value) {
                                                FirebaseFirestore.instance
                                                    .doc(value.reference.path)
                                                    .update({'balance': value.get('balance') - fee}).then((value) {
                                                  FirebaseFirestore.instance
                                                      .doc(valueTo.reference.path)
                                                      .update({'balance': balance + fee + requestDoc.get('tip')}).then(
                                                          (value) {
                                                    FirebaseFirestore.instance
                                                        .doc(requestDoc.reference.path)
                                                        .update({'state': "completed"}).then(
                                                      (value) => Navigator.of(context).pop(),
                                                      onError: (e) {
                                                        if (kDebugMode) {
                                                          print(e.toString());
                                                        }
                                                        Constants.showSnackBar(context, e.message);
                                                      },
                                                    );
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
                                          } else if (state == "active") {
                                            FirebaseFirestore.instance.doc(value.reference.path).update({
                                              'state': 'completeDisabled',
                                            }).then((value) => Navigator.of(context).pop(), onError: (e) {
                                              if (kDebugMode) {
                                                print(e.toString());
                                              }
                                              Constants.showSnackBar(context, e.message);
                                            });
                                          }
                                        }, onError: (e) {
                                          if (kDebugMode) {
                                            print(e.toString());
                                          }
                                          Constants.showSnackBar(context, e.message);
                                        });
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.check,
                                            color: Colors.grey[50],
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            appLocal.complete,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
