/// Created by Amin BADH on 15 Jun, 2022

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sosite/data/constants.dart';
import 'package:sosite/utils/Data.dart';

class EditAccountDisabledScreen extends StatelessWidget {
  const EditAccountDisabledScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: db.collection('users').doc(auth.currentUser!.uid).snapshots(),
        builder: (context2, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            DataSingleton.userDoc = snapshot.data;
          }
          return SafeArea(
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
                        "Edit Account",
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Are you sure?"),
                                contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                                content: Text(
                                  "Your account and funds will be deleted permanently.",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text("NO"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      FirebaseAuth.instance.currentUser?.delete().then((value) => null, onError: (e) {
                                        Constants.showSnackBar(context2, e.message);
                                        if (kDebugMode) {
                                          print(e.toString());
                                        }
                                      });
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.red[800],
                                      primary: Colors.grey[50],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text("YES"),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                ],
                              );
                            });
                      },
                      tooltip: "Delete Account",
                      splashRadius: 24,
                      icon: const Icon(Icons.delete_outline),
                    ),
                    const SizedBox(width: 16),
                  ],
                ),
                const SizedBox(height: 6),
                Divider(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3), height: 1),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              height: 100,
                              width: 100,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "First Name",
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                        subtitle: Text(
                          DataSingleton.userDoc!.get('firstName'),
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                color: Colors.grey[900]?.withOpacity(0.7),
                                fontSize: 14,
                              ),
                        ),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final TextEditingController firstNameController = TextEditingController(
                                text: DataSingleton.userDoc!.get('firstName'),
                              );
                              final GlobalKey<FormState> formKey = GlobalKey<FormState>();

                              return AlertDialog(
                                title: const Text("Change First Name"),
                                contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                                content: GestureDetector(
                                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 4),
                                        TextFormField(
                                          keyboardType: TextInputType.name,
                                          controller: firstNameController,
                                          style: Theme.of(context).textTheme.bodyText1,
                                          decoration: Constants.inputDecoration(
                                            "First Name",
                                            "Emmy",
                                            context,
                                          ),
                                          validator: (val) =>
                                              val!.trim().isEmpty ? "Please enter your first name" : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("CANCEL"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        db.collection('/users').doc(auth.currentUser!.uid).update({
                                          'firstName': firstNameController.text,
                                        }).then((value) => Navigator.of(context).pop());
                                      }
                                    },
                                    child: const Text("APPLY"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Last Name",
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                        subtitle: Text(
                          DataSingleton.userDoc!.get('lastName'),
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                color: Colors.grey[900]?.withOpacity(0.7),
                                fontSize: 14,
                              ),
                        ),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final TextEditingController lastNameController = TextEditingController(
                                text: DataSingleton.userDoc!.get('lastName'),
                              );
                              final GlobalKey<FormState> formKey = GlobalKey<FormState>();

                              return AlertDialog(
                                title: const Text("Change Last Name"),
                                contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                                content: GestureDetector(
                                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 4),
                                        TextFormField(
                                          keyboardType: TextInputType.name,
                                          controller: lastNameController,
                                          style: Theme.of(context).textTheme.bodyText1,
                                          decoration: Constants.inputDecoration(
                                            "Last Name",
                                            "Freeman",
                                            context,
                                          ),
                                          validator: (val) =>
                                              val!.trim().isEmpty ? "Please enter your last name" : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("CANCEL"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        db.collection('/users').doc(auth.currentUser!.uid).update({
                                          'lastName': lastNameController.text,
                                        }).then((value) => Navigator.of(context).pop());
                                      }
                                    },
                                    child: const Text("APPLY"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Phone Number",
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                        subtitle: Text(
                          DataSingleton.userDoc!.get('phoneNum'),
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                color: Colors.grey[900]?.withOpacity(0.7),
                                fontSize: 14,
                              ),
                        ),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          Constants.showSnackBar(context2, "Work in progress");
                        },
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Email Address",
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                        subtitle: Text(
                          DataSingleton.userDoc!.get('email'),
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                color: Colors.grey[900]?.withOpacity(0.7),
                                fontSize: 14,
                              ),
                        ),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final TextEditingController lastNameController = TextEditingController(
                                text: DataSingleton.userDoc!.get('email'),
                              );
                              final GlobalKey<FormState> formKey = GlobalKey<FormState>();

                              return AlertDialog(
                                title: const Text("Change Email Address"),
                                contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                                content: GestureDetector(
                                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 4),
                                        TextFormField(
                                          keyboardType: TextInputType.name,
                                          controller: lastNameController,
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
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("CANCEL"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        db.collection('/users').doc(auth.currentUser!.uid).update({
                                          'email': lastNameController.text,
                                        }).then((value) => Navigator.of(context).pop());
                                      }
                                    },
                                    child: const Text("APPLY"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Birth Date",
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                        subtitle: Text(
                          "${DataSingleton.userDoc!.get('birthDate').toDate().toLocal()}".split(' ')[0],
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                color: Colors.grey[900]?.withOpacity(0.7),
                                fontSize: 14,
                              ),
                        ),
                        trailing: const Icon(Icons.edit),
                        onTap: () async {
                          DateTime selectedDate = DataSingleton.userDoc!.get('birthDate').toDate();
                          final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(1950),
                              lastDate: DateTime(DateTime.now().year));
                          if (picked != null && picked != selectedDate) {
                            db.collection('/users').doc(auth.currentUser!.uid).update({
                              'birthDate': picked,
                            }).onError((error, stackTrace) {
                              if (kDebugMode) {
                                print(error.toString());
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Country",
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                        subtitle: Text(
                          DataSingleton.userDoc!.get('country'),
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                color: Colors.grey[900]?.withOpacity(0.7),
                                fontSize: 14,
                              ),
                        ),
                        trailing: const Icon(Icons.edit),
                        onTap: () async {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: false,
                            onSelect: (Country country) {
                              db.collection('/users').doc(auth.currentUser!.uid).update({
                                'country': country.displayNameNoCountryCode,
                              }).onError((error, stackTrace) {
                                if (kDebugMode) {
                                  print(error.toString());
                                }
                              });
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "ID Number",
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                        subtitle: Text(
                          DataSingleton.userDoc!.get('idNumber'),
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                color: Colors.grey[900]?.withOpacity(0.7),
                                fontSize: 14,
                              ),
                        ),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final TextEditingController idNumberController = TextEditingController(
                                text: DataSingleton.userDoc!.get('idNumber'),
                              );
                              final GlobalKey<FormState> formKey = GlobalKey<FormState>();

                              return AlertDialog(
                                title: const Text("Change ID Number"),
                                contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                                content: GestureDetector(
                                  onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                                  child: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 4),
                                        TextFormField(
                                          keyboardType: TextInputType.name,
                                          controller: idNumberController,
                                          style: Theme.of(context).textTheme.bodyText1,
                                          decoration: Constants.inputDecoration(
                                            "ID Number",
                                            "XXXXXXXXX",
                                            context,
                                          ),
                                          validator: (val) =>
                                              val!.trim().isEmpty ? "Please enter a valid ID number" : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("CANCEL"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        db.collection('/users').doc(auth.currentUser!.uid).update({
                                          'idNumber': idNumberController.text,
                                        }).then((value) => Navigator.of(context).pop(), onError: (e) {
                                          if (kDebugMode) {
                                            print(e.toString());
                                          }
                                        });
                                      }
                                    },
                                    child: const Text("APPLY"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Gender",
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                        subtitle: Text(
                          DataSingleton.userDoc!.get('gender'),
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                color: Colors.grey[900]?.withOpacity(0.7),
                                fontSize: 14,
                              ),
                        ),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                String? selectedRadio = DataSingleton.userDoc!.get('gender');
                                return AlertDialog(
                                  title: const Text('Select Gender'),
                                  contentPadding: EdgeInsets.zero,
                                  content: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      final languages = [
                                        'Male',
                                        'Female',
                                        'Other',
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
                                                    languages[index],
                                                    style: Theme.of(context).textTheme.bodyText2,
                                                  ),
                                                  leading: Radio<String>(
                                                    value: languages[index],
                                                    groupValue: selectedRadio,
                                                    onChanged: (String? val) {
                                                      setState(() => selectedRadio = val);
                                                    },
                                                  ),
                                                  onTap: () {
                                                    setState(() => selectedRadio = languages[index]);
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
                                      onPressed: () async {
                                        db.collection('/users').doc(auth.currentUser!.uid).update({
                                          'gender': selectedRadio,
                                        }).then((value) => Navigator.of(context).pop(), onError: (e) {
                                          if (kDebugMode) {
                                            print(e.toString());
                                          }
                                        });
                                      },
                                      child: const Text('APPLY'),
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                      const SizedBox(height: 24),
                      ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Disability",
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                        subtitle: Text(
                          DataSingleton.userDoc!.get('disability'),
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                color: Colors.grey[900]?.withOpacity(0.7),
                                fontSize: 14,
                              ),
                        ),
                        trailing: const Icon(Icons.edit),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                String? selectedRadio = DataSingleton.userDoc!.get('disability');
                                final GlobalKey<FormState> formKey = GlobalKey<FormState>();
                                final TextEditingController descriptionController = TextEditingController(
                                  text: DataSingleton.userDoc!.get('disabilityInfo'),
                                );

                                return AlertDialog(
                                  title: const Text('Select Disability'),
                                  contentPadding: EdgeInsets.zero,
                                  content: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      final languages = [
                                        "Vision Impairment",
                                        "Deaf or hard of hearing",
                                        "Mental health conditions",
                                        "Intellectual disability",
                                        "Acquired brain injury",
                                        "Autism spectrum disorder",
                                        "Physical disability",
                                        "Other",
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
                                            height: MediaQuery.of(context).size.height * 0.15,
                                            child: ListView.builder(
                                              itemCount: languages.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                return ListTile(
                                                  title: Text(
                                                    languages[index],
                                                    style: Theme.of(context).textTheme.bodyText2,
                                                  ),
                                                  leading: Radio<String>(
                                                    value: languages[index],
                                                    groupValue: selectedRadio,
                                                    onChanged: (String? val) {
                                                      setState(() => selectedRadio = val);
                                                    },
                                                  ),
                                                  onTap: () {
                                                    setState(() => selectedRadio = languages[index]);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          Divider(
                                            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                                            height: 1,
                                          ),
                                          Builder(builder: (context) {
                                            if (selectedRadio == "Other") {
                                              return Column(
                                                children: [
                                                  const SizedBox(height: 12),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                                    child: Form(
                                                      key: formKey,
                                                      child: TextFormField(
                                                        keyboardType: TextInputType.multiline,
                                                        maxLines: 3,
                                                        controller: descriptionController,
                                                        style: Theme.of(context).textTheme.bodyText1,
                                                        decoration: Constants.inputDecoration(
                                                          "Disability Description ",
                                                          DataSingleton.userDoc?.get('disabilityInfo') ?? '',
                                                          context,
                                                        ),
                                                        validator: (val) =>
                                                            val!.trim().isEmpty ? "Please enter a description" : null,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Divider(
                                                    color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
                                                    height: 1,
                                                  ),
                                                ],
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          })
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
                                      onPressed: () async {
                                        if (selectedRadio == 'Other' && formKey.currentState!.validate()) {
                                          db.collection('/users').doc(auth.currentUser!.uid).update({
                                            'disability': selectedRadio,
                                            'disabilityInfo': descriptionController.text,
                                          }).then((value) => Navigator.of(context).pop(), onError: (e) {
                                            if (kDebugMode) {
                                              print(e.toString());
                                            }
                                          });
                                        }
                                        if (selectedRadio != 'Other') {
                                          db.collection('/users').doc(auth.currentUser!.uid).update({
                                            'disability': selectedRadio,
                                            'disabilityInfo': '',
                                          }).then((value) => Navigator.of(context).pop(), onError: (e) {
                                            if (kDebugMode) {
                                              print(e.toString());
                                            }
                                          });
                                        }
                                      },
                                      child: const Text('APPLY'),
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                      Builder(
                        builder: (context) {
                          if (DataSingleton.userDoc?.get('disabilityInfo') != null &&
                              DataSingleton.userDoc?.get('disabilityInfo') != '') {
                            return Column(
                              children: [
                                const SizedBox(height: 24),
                                ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Disability Description",
                                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                    ],
                                  ),
                                  subtitle: Text(
                                    DataSingleton.userDoc!.get('disabilityInfo'),
                                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                          color: Colors.grey[900]?.withOpacity(0.7),
                                          fontSize: 14,
                                        ),
                                  ),
                                  trailing: const Icon(Icons.edit),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        final TextEditingController idNumberController = TextEditingController(
                                          text: DataSingleton.userDoc!.get('disabilityInfo'),
                                        );
                                        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

                                        return AlertDialog(
                                          title: const Text("Change Disability Description"),
                                          contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
                                          content: GestureDetector(
                                            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                                            child: Form(
                                              key: formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const SizedBox(height: 4),
                                                  TextFormField(
                                                    keyboardType: TextInputType.name,
                                                    controller: idNumberController,
                                                    style: Theme.of(context).textTheme.bodyText1,
                                                    decoration: Constants.inputDecoration(
                                                      "Disability Description",
                                                      DataSingleton.userDoc?.get('disabilityInfo') ?? '',
                                                      context,
                                                    ),
                                                    validator: (val) =>
                                                    val!.trim().isEmpty ? "Please enter a description" : null,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("CANCEL"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (formKey.currentState!.validate()) {
                                                  db.collection('/users').doc(auth.currentUser!.uid).update({
                                                    'disabilityInfo': idNumberController.text,
                                                  }).then((value) => Navigator.of(context).pop(), onError: (e) {
                                                    if (kDebugMode) {
                                                      print(e.toString());
                                                    }
                                                  });
                                                }
                                              },
                                              child: const Text("APPLY"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
