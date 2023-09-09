import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Form(
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
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Enter Mobile Number";
                }
                return null;
              },
              decoration: InputDecoration(
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
                            content:
                                Text("Could not find location ..Try again"),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Processing Data ...")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Shop profile picture needs to be added ...")),
                      );
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
