/// Created by Amin BADH on 15 Jun, 2022

import 'package:flutter/material.dart';
import 'package:sosite/utils/Utils.dart';

class EditAccountDisabledScreen extends StatelessWidget {
  const EditAccountDisabledScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  tooltip: 'Back',
                ),
                const SizedBox(width: 16),
                Text(
                  "Edit Account",
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
              child: ScrollConfiguration(
                behavior: NoGlowScrollBehaviour(),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
