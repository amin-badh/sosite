/// Created by Amin BADH on 15 Jun, 2022

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sosite/utils/constants.dart';
import 'package:sosite/utils/Data.dart';

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
                    tooltip: 'Back',
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Get Help",
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
                      Text("Provide the request's info below:", style: Theme.of(context).textTheme.bodyText1),
                      const SizedBox(height: 24),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        controller: _descriptionController,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: Constants.inputDecoration(
                          "Describe the help you need",
                          "",
                          context,
                        ),
                        validator: (val) => val!.trim().isEmpty ? "Please enter a description" : null,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        controller: _descriptionController,
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: Constants.inputDecoration(
                          "Describe the help you need",
                          "",
                          context,
                        ),
                        validator: (val) => val!.trim().isEmpty ? "Please enter a description" : null,
                      ),
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
