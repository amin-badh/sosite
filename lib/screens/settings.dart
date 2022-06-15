/// Created by Amin BADH on 15 Jun, 2022

import 'package:flutter/material.dart';
import 'package:sosite/widgets/app_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
                  "Settings",
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
              child: ListView(
                children: [
                  const SizedBox(height: 6),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Language",
                          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                    subtitle: Text(getLocal()),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            String? selectedRadio = Localizations.localeOf(context).toString();
                            return AlertDialog(
                              title: const Text('Select a language'),
                              contentPadding: EdgeInsets.zero,
                              content: StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  final languages = [
                                    {'name': "English", 'code': 'en'},
                                    {'name': "French", 'code': 'fr'},
                                  ];

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 18),
                                      Divider(
                                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                                        height: 1,
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: ListView.builder(
                                          itemCount: languages.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return ListTile(
                                              title: Text(
                                                languages[index]['name']!,
                                                style: Theme.of(context).textTheme.bodyText2,
                                              ),
                                              leading: Radio<String>(
                                                value: languages[index]['code']!,
                                                groupValue: selectedRadio,
                                                onChanged: (String? val) {
                                                  setState(() => selectedRadio = val);
                                                },
                                              ),
                                              onTap: () {
                                                setState(() => selectedRadio = languages[index]['code']!);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      Divider(
                                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                                        height: 1,
                                      ),
                                    ],
                                  );
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('APPLY'),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                  Divider(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2)),
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Language",
                          style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                    subtitle: Text(getLocal()),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(selected: 'settings'),
    );
  }

  String getLocal() {
    switch (Localizations.localeOf(context).toString()) {
      case 'en':
        return "English";
      default:
        return "";
    }
  }
}
