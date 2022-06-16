/// Created by Amin BADH on 15 Jun, 2022

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosite/data/constants.dart';
import 'package:sosite/screens/history.dart';
import 'package:sosite/screens/wallet.dart';
import 'package:sosite/utils/Data.dart';
import 'package:sosite/utils/Utils.dart';
import 'package:sosite/widgets/app_drawer.dart';
import 'package:sosite/widgets/gradient_text.dart';

class HomeDisabledScreen extends StatefulWidget {
  const HomeDisabledScreen({Key? key}) : super(key: key);

  @override
  State<HomeDisabledScreen> createState() => _HomeDisabledScreenState();
}

class _HomeDisabledScreenState extends State<HomeDisabledScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
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
                            "Hey ${DataSingleton.userDoc?.get('firstName')}!",
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
                            child: InkWell(
                              /// TODO
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onTap: () {},
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
                                              "Get Help",
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
                                "Wallet",
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
                                "History",
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
                      onPressed: () {},
                      label: Text(
                        "Call Emergency",
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
  }
}
