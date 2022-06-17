/// Created by Amin BADH on 16 Jun, 2022

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sosite/utils/Utils.dart';
import 'package:sosite/widgets/app_drawer.dart';

class WalletAssistantScreen extends StatefulWidget {
  const WalletAssistantScreen({Key? key}) : super(key: key);

  @override
  State<WalletAssistantScreen> createState() => _WalletAssistantScreenState();
}

class _WalletAssistantScreenState extends State<WalletAssistantScreen> {
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
                          "Withdraw Funds",
                          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: 46),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  'assets/images/coming-soon.png',
                                  width: MediaQuery.of(context).size.width * 0.75,
                                ),
                                Text(
                                  "Feature Under Development",
                                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 10,
                                    letterSpacing: 1,
                                    color: Colors.grey[400]?.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          drawer: const AppDrawer(selected: 'wallet'),
        );
      },
    );
  }
}