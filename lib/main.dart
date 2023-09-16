import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kiranjaapp_supplier/provider/auth_provider.dart';
import 'package:kiranjaapp_supplier/provider/order_provider.dart';
import 'package:kiranjaapp_supplier/provider/product_provider.dart';
import 'package:kiranjaapp_supplier/screens/add_edit_coupon.dart';
import 'package:kiranjaapp_supplier/screens/add_product_screen.dart';
import 'package:kiranjaapp_supplier/screens/home_screen.dart';
import 'package:kiranjaapp_supplier/screens/login_screen.dart';
import 'package:kiranjaapp_supplier/screens/register_screen.dart';
import 'package:kiranjaapp_supplier/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    Provider(create: (_) => AuthProvider()),
    Provider(create: (_) => ProductProvider()),
    Provider(create: (_) => OrderProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        AddProductScreen.id: (context) => const AddProductScreen(),
        // AddEditCoupon.id :(context) => const AddEditCoupon(document:   )
      },
    );
  }
}
