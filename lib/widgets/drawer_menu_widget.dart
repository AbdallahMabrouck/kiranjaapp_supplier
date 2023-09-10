import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class MenuWidget extends StatefulWidget {
  final Function(String) onItemClick;

  const MenuWidget({super.key, required this.onItemClick});

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  User? user = FirebaseAuth.instance.currentUser;
  var vendorData;
  @override
  void initState() {
    super.initState();
    getVendorData();
  }

  Future<void> getVendorData() async {
    var result = await FirebaseFirestore.instance
        .collection("vendors")
        .doc(user!.uid)
        .get();
    setState(() {
      vendorData = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    _provider
        .getShopName(vendorData != null ? vendorData.data()["shopName"] : "");

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FittedBox(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        // shop image
                        radius: 30,
                        backgroundImage: vendorData != null
                            ? NetworkImage(vendorData.data()?["imageUrl"])
                            : null,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // shop name
                    Text(
                      vendorData != null
                          ? vendorData.data()["shopName"]
                          : "Shop Name",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SliderItem(
              title: 'Dashboard',
              icon: Icons.dashboard,
            ),
            const SliderItem(
              title: 'Product',
              icon: Icons.shopping_bag_outlined,
            ),
            const SliderItem(
              title: 'Banner',
              icon: Icons.photo,
            ),
            const SliderItem(
              title: 'Coupons',
              icon: Icons.card_giftcard_outlined,
            ),
            const SliderItem(
              title: 'Orders',
              icon: Icons.list_alt_outlined,
            ),
            const SliderItem(
              title: 'Reports',
              icon: Icons.stacked_bar_chart_outlined,
            ),
            const SliderItem(
              title: 'Setting',
              icon: Icons.settings,
            ),
            const SliderItem(
              title: 'Logout',
              icon: Icons.exit_to_app,
            ),
          ]),
    );
  }
}

class SliderItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function(String)? onTap;
  const SliderItem(
      {super.key, required this.title, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.black54,
                  size: 18,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        onTap!.call(title);
      },
    );
  }
}



/*Widget sliderItem(String title, IconData icons, Function(String)? onTap) => InkWell(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Icon(
                  icons,
                  color: Colors.black54,
                  size: 18,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        // Assuming 'onItemClick' is a function passed to the widget
        widget.onItemClick(title);
      },
    );*/