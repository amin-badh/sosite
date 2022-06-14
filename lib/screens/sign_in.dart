/// Created by Amin BADH on 14 Jun, 2022

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sosite/data/constants.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);
  static const routeName = '/sign_in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  static const getCode = "CODE";
  static const signIn = "SIGN";
  String state = getCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocal = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Align(
                      alignment: const Alignment(0, 0),
                      child: Image.asset('assets/images/sosite_text.png'),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: constraints.maxWidth * 0.1,
                    ),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, constraints.maxHeight * 0.2),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: _phoneController,
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: Constants.inputDecoration(
                              appLocal.phoneNumber,
                              "+216 52 011 602",
                              context,
                            ),
                            validator: (val) => val!.length < 4 || val[0] != "+" ? appLocal.validPhoneNumber : null,
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
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final auth = FirebaseAuth.instance;
                                  WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  setState(() => _isLoading = true);
                                  await auth.verifyPhoneNumber(
                                    phoneNumber: _phoneController.text,
                                    verificationCompleted: (PhoneAuthCredential credential) async {
                                      // ANDROID ONLY!

                                      // Sign the user in (or link) with the auto-generated credential
                                      await auth.signInWithCredential(credential);
                                    },
                                    verificationFailed: (FirebaseAuthException e) {
                                      Constants.showSnackBar(context, e.message ?? e.code);
                                      if (kDebugMode) {
                                        print(e.toString());
                                      }
                                    },
                                    codeSent: (String verificationId, int? resendToken) {
                                      // Good time to update the UI.
                                    },
                                    codeAutoRetrievalTimeout: (String verificationId) {
                                      if (kDebugMode) {
                                        print("Auto-resolution timed out...");
                                      }
                                    },
                                  );
                                }
                              },
                              child: Text(
                                appLocal.signIn,
                                style: theme.textTheme.bodyText2?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Opacity(
                            opacity: 0.6,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: appLocal.support,

                                    /// TODO
                                    recognizer: TapGestureRecognizer()..onTap = () {},
                                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.3,
                                        ),
                                  ),
                                ),
                                Text(
                                  "  |  ",
                                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: appLocal.createAccount,

                                    /// TODO
                                    recognizer: TapGestureRecognizer()..onTap = () {},
                                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.3,
                                        ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
