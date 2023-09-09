import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../firebase_services.dart';
import '../provider/product_provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseServices _services = FirebaseServices();
    final _provider = Provider.of<ProductProvider>(context);

    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Category",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _services.category.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong ...");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return Expanded(
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic>? data =
                        document.data() as Map<String, dynamic>?;

                    if (data != null) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data["image"]),
                        ),
                        title: Text(data["name"]),
                        onTap: () {
                          _provider.selectedCategory;
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      return const ListTile(
                        title: Text("Error: No data"),
                      );
                    }
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SubCategoryList extends StatelessWidget {
  const SubCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseServices _services = FirebaseServices();
    final _provider = Provider.of<ProductProvider>(context);

    return Dialog(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Sub Category",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          FutureBuilder<DocumentSnapshot>(
            future: _services.category.doc(_provider.selectedCategory).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong ...");
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic>? data =
                    snapshot.data?.data() as Map<String, dynamic>?;

                if (data != null) {
                  List<dynamic>? subCatList = data["subCat"];
                  return Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Row(
                              children: [
                                const Text("Main Category: "),
                                FittedBox(
                                  child: Text(
                                    _provider.selectedCategory!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 3,
                        ),
                        Container(
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  List<dynamic>? subCatList =
                                      data["subCat"] as List<dynamic>?;
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      child: Text("${index + 1}"),
                                    ),
                                    title:
                                        Text(subCatList?[index]["name"] ?? ""),
                                    onTap: () {
                                      _provider.selectedSubCategory;
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                                itemCount: subCatList?.length ?? 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text("No Category selected");
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
