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
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _verificationId;
  bool _isLoading = false;
  static const getCode = "CODE";
  static const signIn = "SIGN";
  String state = getCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appLocal = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        if (state == signIn) {
          setState(() => state = getCode);
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
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
                        child: SizedBox(width: 185, child: Image.asset('assets/images/sosite_text.png')),
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
                            state == getCode
                                ? TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: _phoneController,
                                    style: Theme.of(context).textTheme.bodyText1,
                                    decoration: Constants.inputDecoration(
                                      appLocal.phoneNumber,
                                      "+1 555-555-1234",
                                      context,
                                    ),
                                    validator: (val) =>
                                        val!.length < 4 || val[0] != "+" ? appLocal.validPhoneNumber : null,
                                  )
                                : TextFormField(
                                    keyboardType: TextInputType.number,
                                    maxLength: 6,
                                    controller: _codeController,
                                    style: Theme.of(context).textTheme.bodyText1,
                                    decoration: Constants.inputDecoration(
                                      appLocal.code,
                                      "000000",
                                      context,
                                    ),
                                    validator: (val) => val!.length != 6 ? appLocal.validCode : null,
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
                                onPressed: _isLoading
                                    ? null
                                    : () async {
                                        if (_formKey.currentState!.validate()) {
                                          final auth = FirebaseAuth.instance;
                                          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          setState(() => _isLoading = true);
                                          if (state == getCode) {
                                            await auth.verifyPhoneNumber(
                                              phoneNumber: _phoneController.text,
                                              verificationCompleted: (PhoneAuthCredential credential) async {
                                                // ANDROID ONLY!

                                                // Sign the user in (or link) with the auto-generated credential
                                                setState(() => _isLoading = false);
                                                await auth.signInWithCredential(credential);
                                              },
                                              verificationFailed: (FirebaseAuthException e) {
                                                Constants.showSnackBar(context, e.message ?? e.code);
                                                setState(() => _isLoading = false);
                                                if (kDebugMode) {
                                                  print(e.toString());
                                                }
                                              },
                                              codeSent: (String verificationId, int? resendToken) {
                                                setState(() => state = signIn);
                                                setState(() => _isLoading = false);
                                                _verificationId = verificationId;
                                              },
                                              codeAutoRetrievalTimeout: (String verificationId) {
                                                if (kDebugMode) {
                                                  print("Auto-resolution timed out...");
                                                }
                                              },
                                            );
                                          } else {
                                            // Create a PhoneAuthCredential with the code
                                            PhoneAuthCredential credential = PhoneAuthProvider.credential(
                                              verificationId: _verificationId!,
                                              smsCode: _codeController.text,
                                            );

                                            // Sign the user in (or link) with the credential
                                            await auth.signInWithCredential(credential).then(
                                                  (value) => setState(() => _isLoading = false),
                                                  onError: (e) {
                                                    setState(() => _isLoading = false);
                                                    Constants.showSnackBar(context, e.message);
                                                    if (kDebugMode) {
                                                      print(e.toString());
                                                    }
                                                  },
                                                );
                                          }
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
                                        state == getCode ? appLocal.getCode : appLocal.signIn,
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
                                      text: "Privacy Policy",

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
      ),
    );
  }
}
