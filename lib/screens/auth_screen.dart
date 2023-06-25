import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiranjaapp_supplier/screens/landing_screen.dart';
import 'package:kiranjaapp_supplier/screens/login_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return const LandingScreen();
          }

          // user is NOT logged in
          else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
