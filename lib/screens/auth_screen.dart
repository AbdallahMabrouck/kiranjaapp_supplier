import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiranjaapp_supplier/screens/landing_screen.dart';
import 'package:kiranjaapp_supplier/screens/login_screen.dart';

import 'home_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  static const String id = "auth-page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          // if the user has already signed in, we use it as initial data
          // initialData: FirebaseAuth.instance.currentUser,
          builder: (context, snapshot) {
            // user is logged in
            if (snapshot.hasData) {
              return const LandingScreen();
            }

            // user not logged in
            else {
              return const LoginScreen();
            }
          }),
    );
  }
}
