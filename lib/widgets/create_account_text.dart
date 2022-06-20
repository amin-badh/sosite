/// Created by Amin BADH on 15 Jun, 2022 *

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateAccountTopWidget extends StatelessWidget {
  const CreateAccountTopWidget({Key? key, this.des}) : super(key: key);
  final String? des;

  @override
  Widget build(BuildContext context) {
    final appLocal = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          appLocal.createAccount,
          style: Theme.of(context).textTheme.headline5?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 28,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2, 4, 0, 0),
          child: Opacity(
            opacity: 0.7,
            child: Text(
              des ?? appLocal.enterAccountDetails,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      ],
    );
  }
}
