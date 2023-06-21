import 'package:flutter/material.dart';
import 'package:kiranjaapp_supplier/screens/registration_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const id = "login-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const RegistrationScreen()));
            },
            child: const Text("Login Screen")),
      ),
    );
  }
}
