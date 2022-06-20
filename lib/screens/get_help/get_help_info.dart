/// Created by Amin BADH on 15 Jun, 2022 *

import 'package:flutter/material.dart';
import 'package:sosite/screens/get_help/get_help_assistants.dart';
import 'package:sosite/utils/constants.dart';
import 'package:sosite/utils/Data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GetHelpInfoScreen extends StatefulWidget {
  const GetHelpInfoScreen({Key? key}) : super(key: key);
  static const routeName = '/get_help/info';

  @override
  State<GetHelpInfoScreen> createState() => _GetHelpInfoScreenState();
}

class _GetHelpInfoScreenState extends State<GetHelpInfoScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocal = AppLocalizations.of(context)!;

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
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                    children: [
                      Text(appLocal.provideInfoBelow, style: Theme.of(context).textTheme.bodyText1),
                      const SizedBox(height: 24),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        controller: _descriptionController,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: Constants.inputDecoration(
                          appLocal.describeHelp,
                          "",
                          context,
                        ),
                        validator: (val) => val!.trim().isEmpty ? appLocal.validDescription : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 56,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                              DataSingleton.helpInfo = {
                                'description': _descriptionController.text,
                              };
                              Navigator.of(context).pushNamed(AssistantsScreen.routeName);
                            }
                          },
                          child: Text(
                            appLocal.next,
                            style: theme.textTheme.bodyText2?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
