/// Created by Amin BADH on 15 Jun, 2022

import 'package:flutter/material.dart';
import 'package:sosite/utils/Utils.dart';
import 'package:sosite/widgets/app_drawer.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);
  static const routeName = '/history';

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
                const SizedBox(width: 16),
                Text(
                  "History",
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Divider(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3), height: 1),
            Expanded(
              child: Center(
                child: Text(
                  "Feature Under Development",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(selected: 'history'),
    );
  }
}
