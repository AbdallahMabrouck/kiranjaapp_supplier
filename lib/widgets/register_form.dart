import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kiranjaapp_supplier/screens/home_screen.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextControler = TextEditingController();
  final _passwordTextControler = TextEditingController();
  final _cPasswordTextControler = TextEditingController();
  final _addressTextControler = TextEditingController();
  final _nameTextControler = TextEditingController();
  final _dialogTextControler = TextEditingController();
  String email;
  String password;
  String shopName;
  String mobile;
  bool _isLoading = false;

  Future<String> uploadFile(filePath) async {
    File file = File(filePath);

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage
          .ref("uploads/shopProfilePic/${_nameTextControler.text}")
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g e.code == "cancelled"
      print(e.code);
    }

    String downloadURL = await _storage
        .ref("uploads/shopProfilePic/${_nameTextControler.text}")
        .getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    scaffoldMessage(message) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    return _isLoading
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        : Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Shop Name";
                      }
                      setState(() {
                        _nameTextControler.text = value;
                      });
                      setState(() {
                        shopName = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.add_business),
                        labelText: "Business Name",
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor),
                        ),
                        focusColor: Theme.of(context).primaryColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    maxLength: 9,
                    // depending on the country
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Mobile Number";
                      }
                      setState(() {
                        mobile = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixText: "+255",
                        prefixIcon: const Icon(Icons.phone_android),
                        labelText: "Mobile Number",
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor),
                        ),
                        focusColor: Theme.of(context).primaryColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: _emailTextControler,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Email";
                      }
                      final bool _isValid =
                          EmailValidator.validate(_emailTextControler.text);
                      if (!_isValid) {
                        return "Invalid Email format";
                      }
                      setState(() {
                        email = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        labelText: "Email",
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor),
                        ),
                        focusColor: Theme.of(context).primaryColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Password";
                      }
                      if (value.length < 6) {
                        return "Minimum 6 characters";
                      }
                      setState(() {
                        password = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.vpn_key_outlined),
                        labelText: "Password",
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor),
                        ),
                        focusColor: Theme.of(context).primaryColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Confirm Password";
                      }
                      if (value.length < 6) {
                        return "Minimum 6 characters";
                      }
                      if (_passwordTextControler.text !=
                          _cPasswordTextControler.text) {
                        return "Password does not match";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.add_business),
                        labelText: "Confirm Password",
                        contentPadding: EdgeInsets.zero,
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor),
                        ),
                        focusColor: Theme.of(context).primaryColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    controller: _addressTextControler,
                    maxLines: 6,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Press Navigation Button";
                      }
                      if (_authData.shopLatitude == null) {
                        return "Please Press Navigation Button";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.contact_mail_outlined),
                      labelText: "Business Location",
                      suffixIcon: IconButton(
                        onPressed: () async {
                          _addressTextControler.text =
                              "Locating ...  \n Please wait ...";
                          _authData.getCurrentAddress();

                          Future.delayed(const Duration(seconds: 5), () {
                            if (_authData.placeName != null &&
                                _authData.shopAddress != null) {
                              setState(() {
                                _addressTextControler.text =
                                    "${_authData.placeName} \n ${_authData.shopAddress}";
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Could not find location ..Try again"),
                                ),
                              );
                            }
                          });
                        },
                        icon: const Icon(Icons.location_searching),
                      ),
                      enabledBorder: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    onChanged: (value) {
                      _dialogTextControler.text = value;
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.comment),
                        labelText: "Shop Dialog",
                        contentPadding: EdgeInsets.zero,
                        suffixIcon: IconButton(
                            onPressed: () {
                              _addressTextControler.text =
                                  "Locating ...  \n Please wait ...";
                            },
                            icon: const Icon(Icons.location_searching)),
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor),
                        ),
                        focusColor: Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        ),
                        onPressed: () {
                          // first will validate profile picture
                          if (_authData.isPicAvail == true) {
                            // then will validate forms
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              _authData
                                  .registerVendor(email, password)
                                  .then((credential) {
                                if (credential!.user!.uid != null) {
                                  // user is registered
                                  // will upload profile pic to firestore
                                  uploadFile(_authData.image!.path).then((url) {
                                    if (url != null) {
                                      // save vendor details to database
                                      _authData.saveVendorDataToDb(
                                          url: url,
                                          mobile: mobile,
                                          shopName: shopName,
                                          dialog: _dialogTextControler.text);

                                      setState(() {
                                        _isLoading = false;
                                      });
                                      // after all processes, will navigate to home screen
                                      Navigator.pushReplacementNamed(
                                          context, HomeScreen.id);
                                    } else {
                                      scaffoldMessage(
                                          "Failed to upload Profile Pic");
                                    }
                                  });
                                } else {
                                  // register failed
                                  scaffoldMessage(_authData.error);
                                }
                              });
                            }
                          } else {
                            scaffoldMessage(
                                "Shop profile pic need to be added");
                          }
                        },
                        child: const Text("Register",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
