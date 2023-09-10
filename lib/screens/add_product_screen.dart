import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import '../widgets/category_list.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key});

  static const String id = "add-product-screen";

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _collection = [
    "Featured Products",
    "Best Selling",
    "Recently Added"
  ];
  String? dropdownValue;

  final _categoryTextController = TextEditingController();
  final _subCategoryTextController = TextEditingController();
  final _comparedPriceTextController = TextEditingController();
  final _brandTextController = TextEditingController();
  final _lowStockQtyTextController = TextEditingController();
  final _stockTextController = TextEditingController();
  File? _image;
  bool _visible = false;
  bool _track = false;

  String? productName;
  String? description;
  double? price;
  double? comparedPrice;
  String? sku;
  String? weight;
  double? tax;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Add Product"),
          ),
          body: Form(
            key: _formKey,
            child: Column(
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
                            child: const Text("Products / Add"),
                          ),
                        ),
                        ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                            icon: const Icon(Icons.save, color: Colors.white),
                            label: const Text("Save",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (dropdownValue != null) {
                                  if (_subCategoryTextController
                                      .text.isNotEmpty) {
                                    if (_image != null) {
                                      EasyLoading.show(status: "Saving ...");
                                      _provider
                                          .uploadProductImage(
                                              _image!.path, productName!)
                                          .then((url) {
                                        // ignore: unnecessary_null_comparison
                                        if (url != null) {
                                          EasyLoading.dismiss();
                                          _provider.saveProductDataToDb(
                                            context: context,
                                            comparedPrice: comparedPrice != null
                                                ? double.parse(
                                                    _comparedPriceTextController
                                                        .text)
                                                : 0.0,
                                            brand: _brandTextController.text,
                                            collection: dropdownValue!,
                                            description: description!,
                                            lowStockQty: int.parse(
                                                _lowStockQtyTextController
                                                    .text),
                                            price: price!,
                                            sku: sku!,
                                            stockQty: int.tryParse(
                                                    _stockTextController
                                                        .text) ??
                                                0,
                                            tax: tax!,
                                            weight: double.tryParse(
                                                    weight ?? '0') ??
                                                0.0,
                                            productName: productName!,
                                            categoryName: '',
                                          );

                                          setState(() {
                                            _formKey.currentState?.reset();
                                            _comparedPriceTextController
                                                .clear();
                                            dropdownValue = null;
                                            _subCategoryTextController.clear();
                                            _categoryTextController.clear();
                                            _brandTextController.clear();
                                            _track = false;
                                            _image = null;
                                            _visible = false;
                                          });
                                        } else {
                                          // upload failed
                                          _provider.alertDialog(
                                              context: context,
                                              title: "IMAGE UPLOAD",
                                              content:
                                                  "Failed to upload product image");
                                        }
                                      });
                                    } else {
                                      // image not selected
                                      _provider.alertDialog(
                                          context: context,
                                          title: "PRODUCT IMAGE",
                                          content:
                                              "Product image not selected");
                                    }
                                  }
                                } else {
                                  _provider.alertDialog(
                                      context: context,
                                      title: "Sub Category",
                                      content: "Sub Category not selected");
                                }
                              } else {
                                _provider.alertDialog(
                                    context: context,
                                    title: "Main Category",
                                    content: "Main Category not selected");
                              }
                            }),
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
                      text: "GENERAL",
                    ),
                    Tab(
                      text: "INVENTORY",
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: TabBarView(
                        children: [
                          ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter product name";
                                        }
                                        setState(() {
                                          productName = value;
                                        });
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Product Name",
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      keyboardType: TextInputType.multiline,
                                      maxLength: 500,
                                      maxLines: 5,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter description";
                                        }
                                        setState(() {
                                          description = value;
                                        });
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "About Product",
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          _provider
                                              .getProductImage()
                                              .then((image) {
                                            setState(() {
                                              _image = image;
                                            });
                                          });
                                        },
                                        child: SizedBox(
                                          width: 150,
                                          height: 150,
                                          child: Card(
                                            child: Center(
                                              child: _image == null
                                                  ? const Text("Select Image")
                                                  : Image.file(_image!),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter selling price";
                                        }
                                        setState(() {
                                          price = double.parse(value);
                                        });
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Price",
                                        // final selling price
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _comparedPriceTextController,
                                      validator: (value) {
                                        if (price != null &&
                                            double.parse(value!) <= price!) {
                                          return "Compared price should be higher";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Compared Price",
                                        // price before
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Collection",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          DropdownButton<String>(
                                              hint: const Text(
                                                  "Select Collection"),
                                              value: dropdownValue,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down),
                                              items: _collection.map<
                                                  DropdownMenuItem<String>>(
                                                (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value),
                                                  );
                                                },
                                              ).toList(),
                                              onChanged: (value) {
                                                setState(() {
                                                  dropdownValue = value;
                                                });
                                              })
                                        ],
                                      ),
                                    ),
                                    TextFormField(
                                      controller: _brandTextController,
                                      decoration: InputDecoration(
                                        labelText: "Brand",
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter SKU";
                                        }
                                        setState(() {
                                          sku = value;
                                        });
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: "SKU",
                                        // Item code
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 10),
                                      child: Row(
                                        children: [
                                          const Text(
                                            "Category",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: AbsorbPointer(
                                              absorbing: true,
                                              // this blocks users entering category name manually
                                              child: TextFormField(
                                                controller:
                                                    _categoryTextController,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return "Select category name";
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  hintText: "Not selected",
                                                  labelStyle: const TextStyle(
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color:
                                                          Colors.grey.shade300,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const SubCategoryList();
                                                  }).whenComplete(() {
                                                setState(() {
                                                  _subCategoryTextController
                                                          .text =
                                                      _provider
                                                          .selectedSubCategory!;
                                                });
                                              });
                                            },
                                            icon:
                                                const Icon(Icons.edit_outlined),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: _visible,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 20),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Sub Category",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: AbsorbPointer(
                                          absorbing: true,
                                          child: TextFormField(
                                            controller:
                                                _subCategoryTextController,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Select sub Category name";
                                              }
                                              return null;
                                            },
                                            decoration: InputDecoration(
                                              hintText: "Not selected",
                                              labelStyle: const TextStyle(
                                                  color: Colors.grey),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const CategoryList();
                                              }).whenComplete(() {
                                            setState(() {
                                              _categoryTextController.text =
                                                  _provider.selectedCategory!;
                                              _visible = true;
                                            });
                                          });
                                        },
                                        icon: const Icon(Icons.edit_outlined),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Weight";
                                  }
                                  setState(() {
                                    weight = value;
                                  });
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Weight. eg:- kg,gm, etc",
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Tax %";
                                  }
                                  setState(() {
                                    tax = double.parse(value);
                                  });
                                  return null;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Tax % , ",
                                  labelStyle:
                                      const TextStyle(color: Colors.grey),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                SwitchListTile(
                                  title: const Text("Track Inventory"),
                                  activeColor: Theme.of(context).primaryColor,
                                  subtitle: const Text(
                                    "Switch ON to track Inventory",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  value: _track,
                                  onChanged: (selected) {
                                    setState(() {
                                      _track = !_track;
                                    });
                                  },
                                ),
                                Visibility(
                                  visible: _track,
                                  child: SizedBox(
                                    height: 300,
                                    width: double.infinity,
                                    child: Card(
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              controller: _stockTextController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                labelText: "Inventory Quantity",
                                                labelStyle: const TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TextFormField(
                                              // not compulsory
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  _lowStockQtyTextController,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Inventory low stock Quantity",
                                                labelStyle: const TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey.shade300,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
