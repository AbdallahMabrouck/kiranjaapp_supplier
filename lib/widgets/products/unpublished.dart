import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiranjaapp_supplier/widgets/products/product_card.dart';

import '../../models/product_model.dart';

class UnPublishedProduct extends StatelessWidget {
  const UnPublishedProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Product>(
      query: productQuery(false),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        }

        if (snapshot.docs.isEmpty) {
          return const Center(
            child: Text("No Unpublished products"),
          );
        }

        return ProductCard(
          snapshot: snapshot,
        );
      },
    );
  }
}
