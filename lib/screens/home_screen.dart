import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/vendor_provider.dart';
import '../widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  static const String id = "home-screen";
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _vendorData = Provider.of<VendorProvider>(context);
    if (_vendorData.doc == null) {
      _vendorData.getVendorData();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        elevation: 0,
      ),
      drawer: const CustomDrawer(),
      body: const Center(
        child: Text(
          "Dashboard",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
