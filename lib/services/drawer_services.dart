import 'package:flutter/material.dart';

import '../screens/banner_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/product_screen.dart';

class DrawerServices {
  Widget drawerScreen(title) {
    if (title == "Dashboard") {
      return const MainScreen();
    }
    if (title == "Product") {
      return const ProductScreen();
    }

    if (title == "Banner") {
      return const BannerScreen();
    }
    return const MainScreen();
  }
}
