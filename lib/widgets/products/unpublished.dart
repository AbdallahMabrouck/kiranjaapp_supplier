import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../firebase_services.dart';
import '../../screens/edit_view_product.dart';

class UnPublishedProducts extends StatelessWidget {
  const UnPublishedProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    return Container(
      child: StreamBuilder(
        stream:
            _services.products.where("published", isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong ...");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: FittedBox(
              child: DataTable(
                showBottomBorder: true,
                headingRowColor:
                    MaterialStateProperty.all(Colors.grey.shade200),
                columns: const <DataColumn>[
                  DataColumn(
                    label: Text("Product"),
                  ),
                  DataColumn(
                    label: Text("Image"),
                  ),
                  DataColumn(
                    label: Text("Info"),
                  ),
                  DataColumn(
                    label: Text("Actions"),
                  ),
                ],
                rows: _productDetails(snapshot.data!, context),
              ),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _productDetails(QuerySnapshot snapshot, BuildContext context) {
    return snapshot.docs.map((DocumentSnapshot document) {
      var data = document.data() as Map<String, dynamic>;
      return DataRow(
        cells: [
          DataCell(
            Container(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    const Text(
                      "Name",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Expanded(
                      child: Text(
                        data["productName"],
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    const Text(
                      "SKU",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text(
                      data["sku"],
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          DataCell(
            Container(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Row(
                  children: [
                    Image.network(
                      data["productImage"],
                      width: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
          DataCell(
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditViewProduct(
                      productId: data["productId"],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.info_outline),
            ),
          ),
          DataCell(
            popUpButton(data, context: context),
          ),
        ],
      );
    }).toList();
  }
}

Widget popUpButton(Map<String, dynamic> data, {required BuildContext context}) {
  FirebaseServices _services = FirebaseServices();

  return PopupMenuButton<String>(
    onSelected: (String value) {
      if (value == "publish") {
        _services.publishProduct(id: data["productId"]);
      }

      if (value == "delete") {
        _services.deleteProduct(id: data["productId"]);
      }
    },
    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      const PopupMenuItem<String>(
        value: "publish",
        child: ListTile(
          leading: Icon(Icons.check),
          title: Text("Publish"),
        ),
      ),
      const PopupMenuItem<String>(
        value: "delete",
        child: ListTile(
          leading: Icon(Icons.delete_outlined),
          title: Text("Delete Product"),
        ),
      ),
    ],
  );
}
