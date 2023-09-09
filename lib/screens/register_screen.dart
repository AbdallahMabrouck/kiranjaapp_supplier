import 'package:flutter/material.dart';
import '../widgets/image_picker.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static const String id = "register-screen";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const ShopPicCard(),
                  const RegisterForm(),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, LoginScreen.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: const TextSpan(text: "", children: [
                              TextSpan(
                                  text: "Already have an account ? ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: "Login",
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ]),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
