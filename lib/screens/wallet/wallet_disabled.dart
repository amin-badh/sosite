/// Created by Amin BADH on 16 Jun, 2022

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sosite/utils/constants.dart';
import 'package:sosite/utils/Utils.dart';
import 'package:sosite/widgets/app_drawer.dart';

class WalletDisabledScreen extends StatefulWidget {
  const WalletDisabledScreen({Key? key}) : super(key: key);

  @override
  State<WalletDisabledScreen> createState() => _WalletDisabledScreenState();
}

class _WalletDisabledScreenState extends State<WalletDisabledScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('wallet')
            .doc('data')
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          double? balance;
          try {
            balance = snapshot.data?.get('balance');
          } catch (e) {
            balance = 0;
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
                        tooltip: 'Menu',
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Wallet",
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Divider(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3), height: 1),
                  const SizedBox(height: 12),
                  ListTile(
                    title: Text(
                      "Balance",
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            fontSize: 18,
                          ),
                    ),
                    trailing: snapshot.hasData
                        ? Text(
                            "\$${NumberFormat("#,##0.00", "en_US").format(balance)}",
                            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                  letterSpacing: 0.5,
                                  fontSize: 18,
                                ),
                          )
                        : const SizedBox(),
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3), height: 1),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: NoGlowScrollBehaviour(),
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        children: [
                          Text(
                            "Add Funds",
                            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                  fontSize: 18,
                                ),
                          ),
                          const SizedBox(height: 24),
                          Card(
                            elevation: 6,
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    final TextEditingController giftCardController = TextEditingController();
                                    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

                                    return AlertDialog(
                                      title: const Text("Redeem Gift Card"),
                                      contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                                      content: GestureDetector(
                                        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                                        child: Form(
                                          key: formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(height: 6),
                                              TextFormField(
                                                keyboardType: TextInputType.name,
                                                controller: giftCardController,
                                                style: Theme.of(context).textTheme.bodyText1,
                                                decoration: Constants.inputDecoration(
                                                  "Gift Card Code",
                                                  "XXXXXX",
                                                  context,
                                                ),
                                                validator: (val) =>
                                                    val!.trim().isEmpty ? "Please enter your gift card code" : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("CANCEL"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (formKey.currentState!.validate()) {
                                              FirebaseFirestore.instance
                                                  .collection('gift')
                                                  .where('code', isEqualTo: giftCardController.text)
                                                  .get()
                                                  .then((value) {
                                                if (value.docs.length == 1) {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(FirebaseAuth.instance.currentUser?.uid)
                                                      .collection('wallet')
                                                      .doc('data')
                                                      .set({'balance': balance! + value.docs[0].get('amount')}).then(
                                                    (value) => Navigator.of(context).pop(),
                                                  );
                                                } else {
                                                  Navigator.of(context).pop();
                                                  Constants.showSnackBar(
                                                      _key.currentContext!, "Gift Card Code doesn't exist!");
                                                }
                                              });
                                            }
                                          },
                                          child: const Text("REDEEM"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(
                                    "Gift Card",
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                  leading: const Icon(Icons.card_giftcard),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            drawer: const AppDrawer(selected: 'wallet'),
          );
        });
  }
}
