import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firebase_services.dart';
import 'add_edit_coupon.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Coupon Screen"),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: _services.coupons
              .where("sellerId", isEqualTo: _services.user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Something went wrong"));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AddEditCoupon.id);
                        },
                        child: const Text(
                          "Add New Coupon",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text("Title"),
                        ),
                        DataColumn(
                          label: Text("Rate"),
                        ),
                        DataColumn(
                          label: Text("Status"),
                        ),
                        DataColumn(
                          label: Text("Info"),
                        ),
                        DataColumn(
                          label: Text("Expiry"),
                        ),
                      ],
                      rows: _couponList(snapshot.data, context),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  List<DataRow> _couponList(QuerySnapshot? snapshot, context) {
    if (snapshot == null || snapshot.docs.isEmpty) {
      return <DataRow>[];
    }

    return snapshot.docs.map((DocumentSnapshot document) {
      final data = document.data() as Map<String, dynamic>?;

      if (data == null) {
        return const DataRow(cells: []);
      }

      final date = data["Expiry"] as Timestamp?;
      final expiry = date != null
          ? DateFormat.yMMMd().add_jm().format(date.toDate())
          : "N/A";

      return DataRow(
        cells: [
          DataCell(Text(data["title"] as String? ?? "")),
          DataCell(Text(data["discountRate"]?.toString() ?? "")),
          DataCell(Text(data["active"] ? "Active" : "Inactive")),
          DataCell(Text(expiry)),
          DataCell(
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditCoupon(
                      document: document,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.info_outline_rounded),
            ),
          ),
        ],
      );
    }).toList();
  }
}

















/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/firebase_services.dart';
import 'add_edit_coupon.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: _services.coupons
          .where("sellerId", isEqualTo: _services.user!.uid).snapshots(), 
          builder: (context, snapshot){
            if(snapshot.hasError){
              return const Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
            }

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        // color: Theme.of(context).primaryColor
                        onPressed: () {
                          Navigator.pushNamed(context, AddEditCoupon.id);
                        }, 
                        child: const Text("Add New Coupon", 
                        style: TextStyle(color: Colors.white),)
                        ),
                    ),
                  ],
                ),
                FittedBox(
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(label: Text("Title"),),
                      DataColumn(label: Text("Rate"),),
                      DataColumn(label: Text("Status"),),
                      DataColumn(label: Text("Info"),),
                      DataColumn(label: Text("Expiry"),),
                    ], 
                    rows: _couponList(snapshot.data, context)),
                )
              ],
            );
          }
          ),
      ),
    );
  }

  List<DataRow>_couponList(QuerySnapshot snapshot, context){
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document){
      if(document != null){
        var date = document.data()["Expiry"];
        var expiry = DateFormat.yMMd().add_jm().format(date.toDate());
        return DataRow(
          cells: [
            DataCell(Text(document.data()["title"],),),
            DataCell(Text(document.data()["discountRate"].toString(),),),
            DataCell(Text(document.data()["active"] ? "Active" : "Inactive",),),
            DataCell(Text(expiry.toString()),),
            DataCell(IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AddEditCoupon(document: document,),),);
              }, 
              icon: const Icon(Icons.info_outline_rounded)))
          ]
          );
      }
    }, 
    ).toList();
    return newList;
  }
}*/