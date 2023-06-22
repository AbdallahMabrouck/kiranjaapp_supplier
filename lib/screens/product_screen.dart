import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/products/published.dart';
import '../widgets/products/unpublished.dart';

class ProductScreen extends StatelessWidget {
  static const String id = "product-screen";
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Product List"),
            elevation: 0,
            bottom: const TabBar(
                indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 6, color: Colors.deepOrange)),
                tabs: [
                  Tab(
                    child: Text("UnPublished"),
                  ),
                  Tab(
                    child: Text("Published"),
                  ),
                ]),
          ),
          drawer: const CustomDrawer(),
          body: const TabBarView(children: [
            UnPublishedProduct(),
            PublishedProduct(),
          ])),
    );
  }
}
