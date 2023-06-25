import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kiranjaapp_supplier/provider/product_provider.dart';
import 'package:kiranjaapp_supplier/provider/vendor_provider.dart';
import 'package:kiranjaapp_supplier/screens/landing_screen.dart';
import 'package:kiranjaapp_supplier/screens/registration_screen.dart';
import 'package:provider/provider.dart';

import 'screens/add_product_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/product_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(
    MultiProvider(
      providers: [
        Provider<VendorProvider>(
          create: (_) => VendorProvider(),
        ),
        Provider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kiranja - Supplier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: SplashScreen.id,
      builder: EasyLoading.init(),
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        LandingScreen.id: (context) => const LandingScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ProductScreen.id: (context) => const ProductScreen(),
        AddProductScreen.id: (context) => const AddProductScreen(),
      },
    );
  }
}
