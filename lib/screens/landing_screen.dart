import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../firebase_services.dart';
import '../models/vendor_model.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'registration_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  static const id = "landing-screen";

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: _services.vendor.doc(_services.user?.uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.data!.exists) {
            return const RegistrationScreen();
          }
          Vendor vendor =
              Vendor.fromJson(snapshot.data!.data() as Map<String, dynamic>);
          if (vendor.approved == true) {
            return const HomeScreen();
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: vendor.logo!,
                        placeholder: (context, url) => Container(
                          height: 100,
                          width: 100,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    vendor.businessName!,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Your Application is sent to InstaMaart\n Admin will contact you soon",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  OutlinedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const LoginScreen()));
                        });
                      },
                      child: const Text("Sign Out"))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
