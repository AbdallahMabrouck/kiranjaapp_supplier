import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiranjaapp_supplier/widgets/products/product_card.dart';
import '../../models/product_model.dart';

class PublishedProduct extends StatelessWidget {
  const PublishedProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Product>(
      query: productQuery(true),
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        }

        if (snapshot.docs.isEmpty) {
          return const Center(
            child: Text("No products published yet"),
          );
        }

        return ProductCard(snapshot: snapshot);
      },
    );
  }
}
