/// Created by Amin BADH on 15 Jun, 2022

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sosite/data/constants.dart';
import 'package:sosite/screens/create_account.dart';
import 'package:sosite/verify.dart';
import 'package:sosite/widgets/create_account_text.dart';

class CreateAccountDisabledScreen extends StatefulWidget {
  const CreateAccountDisabledScreen({Key? key}) : super(key: key);
  static const routeName = '/create_account_disabled';

  @override
  State<CreateAccountDisabledScreen> createState() => _CreateAccountDisabledScreenState();
}

class _CreateAccountDisabledScreenState extends State<CreateAccountDisabledScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _disabilityDescriptionController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _idNumController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  static const sep = 24.0;

  DateTime selectedDate = DateTime(DateTime.now().year);
  bool hasChanged = false;
  String _currentGenderValue = 'Male';
  String _currentDisabilityValue = 'Vision Impairment';
  bool _agree = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocal = AppLocalizations.of(context)!;
    // just to remove the error
    /// TODO delete.
    appLocal.getCode;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CreateAccountTopWidget(),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _firstNameController,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: Constants.inputDecoration(
                              "First Name",
                              "Emmy",
                              context,
                            ),
                            validator: (val) => val!.trim().isEmpty ? "Please enter your first name" : null,
                          ),
                          const SizedBox(height: sep),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _lastNameController,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: Constants.inputDecoration(
                              "Last Name",
                              "Freeman",
                              context,
                            ),
                            validator: (val) => val!.trim().isEmpty ? "Please enter your full name" : null,
                          ),
                          const SizedBox(height: sep),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: Constants.inputDecoration(
                              "Email Address",
                              "emmy@examlpe.com",
                              context,
                            ),
                            validator: (val) => val!.trim().isEmpty || !EmailValidator.validate(val)
                                ? "Please enter a valid email"
                                : null,
                          ),
                          const SizedBox(height: sep),
                          TextFormField(
                            keyboardType: TextInputType.none,
                            controller: _birthDateController,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: Constants.inputDecoration(
                              "Birth Date",
                              "",
                              context,
                            ),
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(DateTime.now().year));
                              if (picked != null && picked != selectedDate) {
                                setState(() {
                                  selectedDate = picked;
                                  hasChanged = true;
                                });
                                _birthDateController.text = "${selectedDate.toLocal()}".split(' ')[0];
                              }
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            validator: (val) => val!.trim().isEmpty ? "Please enter your birth date" : null,
                          ),
                          const SizedBox(height: sep),
                          TextFormField(
                            keyboardType: TextInputType.none,
                            controller: _countryController,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: Constants.inputDecoration(
                              "Country",
                              "",
                              context,
                            ),
                            onTap: () async {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: false,
                                onSelect: (Country country) {
                                  _countryController.text = country.displayNameNoCountryCode;
                                },
                              );
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            validator: (val) => val!.trim().isEmpty ? "Please select your country" : null,
                          ),
                          const SizedBox(height: sep),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _idNumController,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: Constants.inputDecoration(
                              "ID Number",
                              "xxxxxxxxx",
                              context,
                            ),
                            validator: (val) => val!.trim().isEmpty ? "Please enter a valid ID number" : null,
                          ),
                          const SizedBox(height: sep),
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: Constants.inputDecoration("Gender", "", context),
                                isEmpty: _currentGenderValue == '',
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _currentGenderValue,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _currentGenderValue = newValue ?? 'Male';
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: ["Male", "Female", "Other"].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: Theme.of(context).textTheme.bodyText1,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: sep),
                          FormField<String>(
                            builder: (FormFieldState<String> state) {
                              return InputDecorator(
                                decoration: Constants.inputDecoration("Disability", "", context),
                                isEmpty: _currentDisabilityValue == '',
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _currentDisabilityValue,
                                    isDense: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _currentDisabilityValue = newValue ?? 'Vision Impairment';
                                        state.didChange(newValue);
                                      });
                                    },
                                    items: [
                                      "Vision Impairment",
                                      "Deaf or hard of hearing",
                                      "Mental health conditions",
                                      "Intellectual disability",
                                      "Acquired brain injury",
                                      "Autism spectrum disorder",
                                      "Physical disability",
                                      "Other",
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: Theme.of(context).textTheme.bodyText1,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          ),
                          _currentDisabilityValue == "Other"
                              ? Column(
                                  children: [
                                    const SizedBox(height: sep),
                                    TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: 5,
                                      controller: _disabilityDescriptionController,
                                      style: Theme.of(context).textTheme.bodyText1,
                                      decoration: Constants.inputDecoration(
                                        "Describe your disability",
                                        "",
                                        context,
                                      ),
                                      validator: (val) => val!.trim().isEmpty ? "Please enter a description" : null,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          const SizedBox(height: 12),
                          CheckboxListTile(
                            title: RichText(
                              text: TextSpan(
                                text: "I agree to the ",
                                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                children: [
                                  TextSpan(
                                    text: "privacy policy",

                                    /// TODO
                                    recognizer: TapGestureRecognizer()..onTap = () {},
                                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.3,
                                        ),
                                  ),
                                  TextSpan(
                                    text: ".",
                                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.3,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            value: _agree,
                            onChanged: (newValue) {
                              setState(() {
                                _agree = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                          ),
                          const SizedBox(height: 16),
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
                              onPressed: !_agree || _isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        final auth = FirebaseAuth.instance;
                                        WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        setState(() => _isLoading = true);
                                        FirebaseFirestore.instance.collection('users').doc(auth.currentUser?.uid).set({
                                          'firstName': _firstNameController.text,
                                          'lastName': _lastNameController.text,
                                          'phoneNum': auth.currentUser?.phoneNumber,
                                          'email': _emailController.text,
                                          'birthDate': selectedDate,
                                          'country': _countryController.text,
                                          'idNumber': _idNumController.text,
                                          'gender': _currentGenderValue,
                                          'disability': _currentDisabilityValue,
                                          'disabilityInfo': _disabilityDescriptionController.text,
                                          'role': "Disabled",
                                        }).then(
                                          (value) {
                                            Navigator.of(context).pushNamedAndRemoveUntil(
                                                VerifyRole.routeName, (Route<dynamic> route) => false);
                                          },
                                          onError: (e) {
                                            setState(() => _isLoading = false);
                                            Constants.showSnackBar(context, e.message);
                                            if (kDebugMode) {
                                              print(e.toString());
                                            }
                                          },
                                        );
                                      }
                                    },
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3.0,
                                      ),
                                    )
                                  : Text(
                                      "Create Account",
                                      style: theme.textTheme.bodyText2?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: sep),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
