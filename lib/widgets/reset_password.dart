import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../screens/login_screen.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  static const String id = "reset-password";

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextControler = TextEditingController();
  String email = "";
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "images/forgot.png",
                  height: 250,
                ),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                  text: const TextSpan(text: "", children: [
                    TextSpan(
                        text: "Forgot Password?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    TextSpan(
                        text:
                            "Dont worry, provide us with your registered Email, we will send you an Email to reset your password",
                        style: TextStyle(color: Colors.red, fontSize: 3))
                  ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailTextControler,
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
                      enabledBorder: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.zero,
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor, width: 2)),
                      focusColor: Theme.of(context).primaryColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          // color: Theme.of(context).primaryColor
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              _authData.resetPassword(email);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Check your Email ${_emailTextControler.text} for reset Link")));
                            }
                            Navigator.pushReplacementNamed(
                                context, LoginScreen.id);
                          },
                          child: _loading
                              ? const LinearProgressIndicator()
                              : const Text(
                                  "Reset Password",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
