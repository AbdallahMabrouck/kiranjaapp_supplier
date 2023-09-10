import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/order_provider.dart';
import '../services/order_services.dart';
import '../widgets/order_summary_card.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderServices _orderServices = OrderServices();
  User? user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = [
    "All Orders",
    "Ordered",
    "Accepted",
    "Picked Up",
    "On the way",
    "Delivered"
  ];

  @override
  Widget build(BuildContext context) {
    var _orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Column(
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              child: const Center(
                child: Text(
                  "My Orders",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: ChipsChoice<int>.single(
                choiceStyle: const C2ChipStyle(
                  borderRadius: BorderRadius.all(
                    Radius.circular(3),
                  ),
                ),
                value: tag,
                onChanged: (val) {
                  if (val == 0) {
                    setState(() {
                      _orderProvider.status = "";
                    });
                  }
                  setState(() {
                    tag = val;
                    if (val == 0) {
                      _orderProvider.status = options[val];
                    }
                  });
                },
                choiceItems: C2Choice.listFrom<int, String>(
                  source: options,
                  value: (i, v) => i,
                  label: (i, v) => v,
                ),
              ),
            ),
            Container(
              child: StreamBuilder(
                  stream: _orderServices.orders
                      .where("seller.sellerId", isEqualTo: user!.uid)
                      .where("orderStatus",
                          isEqualTo: tag > 0 ? _orderProvider.status : null)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.size == 0) {
                      return Center(
                        child: Text(tag > 0
                            ? "No ${options[tag]} orders"
                            : "No Orders. Continue shopping."),
                      );
                    }

                    return Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: OrderSummaryCard(document: document),
                          );
                        }).toList(),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
