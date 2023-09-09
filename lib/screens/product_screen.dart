import 'package:flutter/material.dart';
import '../widgets/products/published.dart';
import '../widgets/products/unpublished.dart';
import 'add_product_screen.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  static const String id = "product-screen";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            Material(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        child: const Row(
                          children: [
                            Text("Products"),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.black45,
                              maxRadius: 8,
                              child: FittedBox(
                                child: Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Text(
                                    "20",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    TextButton.icon(
                      // color: Theme.of(context).primaryColor,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Add New",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AddProductScreen.id);
                      },
                    )
                  ],
                ),
              ),
            ),
            TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black54,
              tabs: const [
                Tab(
                  text: "PUBLISH",
                ),
                Tab(
                  text: "UNPUBLISH",
                ),
              ],
            ),
            Expanded(
              child: Container(
                child: const TabBarView(children: [
                  PublishedProducts(),
                  UnPublishedProducts(),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}












/*import 'package:flutter/material.dart';
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
}*/
