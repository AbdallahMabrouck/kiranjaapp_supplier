import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:kiranjaapp_supplier/screens/register_screen.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../widgets/reset_password.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String id = "login-screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  Icon icon = const Icon(Icons.email_outlined);
  // initializing with an icon
  bool _visible = false;
  final _emailTextControler = TextEditingController();
  String email = "";
  String password = "";
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "LOGIN",
                            style: TextStyle(
                                fontFamily: "",
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Image.asset(
                            "assets/images/kiranja-logo.png",
                            height: 160,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
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
                                    color: Theme.of(context).primaryColor,
                                    width: 2)),
                            focusColor: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
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
                        obscureText: _visible == false ? true : false,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: _visible
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _visible = !_visible;
                                });
                              },
                            ),
                            enabledBorder: const OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: "Password",
                            prefixIcon: const Icon(Icons.vpn_key_outlined),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 2)),
                            focusColor: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, ResetPassword.id);
                              },
                              child: const Text(
                                'Forgot Password?',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Theme.of(context).primaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _loading = true;
                                    });
                                    _authData
                                        .loginVendor(email, password)
                                        .then((credential) {
                                      if (credential != null) {
                                        setState(() {
                                          _loading = false;
                                        });
                                        Navigator.pushReplacementNamed(
                                            context, HomeScreen.id);
                                      } else {
                                        setState(() {
                                          _loading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content:
                                                    Text(_authData.error)));
                                      }
                                    });
                                  }
                                },
                                child: _loading
                                    ? const LinearProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        backgroundColor: Colors.transparent,
                                      )
                                    : const Text(
                                        "LOGIN",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RegisterScreen.id);
                                },
                                child: RichText(
                                    text: const TextSpan(text: "", children: [
                                  TextSpan(
                                      text: "Don't have an account ?     ",
                                      style: TextStyle(color: Colors.white)),
                                  TextSpan(
                                      text: "REGISTER",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ]))),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
