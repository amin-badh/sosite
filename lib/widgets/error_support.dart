/// Created by Amin BADH on 20 Jun, 2022 *

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorSupportScreen extends StatelessWidget {
  const ErrorSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(appLocal.errorContactSupport),
        ),
      ),
    );
  }
}
