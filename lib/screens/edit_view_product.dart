import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import '../services/firebase_services.dart';
import '../widgets/category_list.dart';

class EditViewProduct extends StatefulWidget {
  final String productId;
  const EditViewProduct({Key? key, required this.productId}) : super(key: key);

  @override
  State<EditViewProduct> createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  final FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();

  final List<String> _collection = [
    "Featured Products",
    "Best Selling",
    "Recently Added"
  ];
  String? dropdownValue;

  final _brandText = TextEditingController();
  final _skuText = TextEditingController();
  final _productNameText = TextEditingController();
  final _weightText = TextEditingController();
  final _priceText = TextEditingController();
  final _comparedPriceText = TextEditingController();
  final _descriptionText = TextEditingController();
  final _categoryTextController = TextEditingController();
  final _subCategoryTextController = TextEditingController();
  final _stockTextController = TextEditingController();
  final _lowStockTextController = TextEditingController();
  final _taxTextController = TextEditingController();

  DocumentSnapshot? doc;
  double? discount;
  String? image;
  String? categoryImage;
  File? _image;
  bool _visible = false;
  bool _editing = true;

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  void getProductDetails() async {
    final DocumentSnapshot document =
        await _services.products.doc(widget.productId).get();

    if (document.exists) {
      final data = document.data() as Map<String, dynamic>;
      setState(() {
        doc = document;
        _brandText.text = data["brand"] as String? ?? "";
        _skuText.text = data["sku"] as String? ?? "";
        _productNameText.text = data["productName"] as String? ?? "";
        _weightText.text = data["weight"] as String? ?? "";
        _priceText.text = (data["price"] as double? ?? 0.0).toString();
        _comparedPriceText.text =
            (data["comparedPrice"] as double? ?? 0.0).toString();
        var difference =
            int.parse(_comparedPriceText.text) - double.parse(_priceText.text);
        discount = (difference / int.parse(_comparedPriceText.text) * 100);
        image = data["productImage"] as String? ?? "";
        _descriptionText.text = data["description"] as String? ?? "";
        _categoryTextController.text =
            data["category"]["mainCategory"] as String? ?? "";
        _subCategoryTextController.text =
            data["category"]["subCategory"] as String? ?? "";
        dropdownValue = data["collection"] as String? ?? _collection[0];
        _stockTextController.text = (data["stockQty"] as int? ?? 0).toString();
        _lowStockTextController.text =
            (data["lowStockQty"] as int? ?? 0).toString();
        _taxTextController.text = (data["tax"] as double? ?? 0.0).toString();
        categoryImage = data["categoryImage"] as String? ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
            // to make back button white
            color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _editing = false;
              });
            },
            child: const Text(
              "Edit",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      bottomSheet: SizedBox(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.black87,
                  child: const Center(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: AbsorbPointer(
                absorbing: _editing,
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      EasyLoading.show(status: "Saving ...");
                      if (_image != null) {
                        // first upload new image and save data
                        _provider
                            .uploadProductImage(
                                _image!.path, _productNameText.text)
                            .then((url) {
                          EasyLoading.dismiss();
                          _provider.updateProduct(
                            context: context,
                            productName: _productNameText.text,
                            weight: _weightText.text,
                            tax: double.parse(_taxTextController.text),
                            stockQty: int.parse(_stockTextController.text),
                            sku: _skuText.text,
                            price: double.parse(_priceText.text),
                            lowStockQty:
                                int.parse(_lowStockTextController.text),
                            description: _descriptionText.text,
                            collection: dropdownValue ?? "",
                            brand: _brandText.text,
                            comparedPrice: int.parse(_comparedPriceText.text),
                            productId: widget.productId,
                            image: image ?? "",
                            category: _categoryTextController.text,
                            subCategory: _subCategoryTextController.text,
                            categoryImage: categoryImage ?? "",
                          );
                        });
                      } else {
                        // no need to change image, so just save new data. No need to upload image
                        _provider.updateProduct(
                          context: context,
                          productName: _productNameText.text,
                          weight: _weightText.text,
                          tax: double.parse(_taxTextController.text),
                          stockQty: int.parse(_stockTextController.text),
                          sku: _skuText.text,
                          price: double.parse(_priceText.text),
                          lowStockQty: int.parse(_lowStockTextController.text),
                          description: _descriptionText.text,
                          collection: dropdownValue ?? "",
                          brand: _brandText.text,
                          comparedPrice: int.parse(_comparedPriceText.text),
                          productId: widget.productId,
                          image: image ?? "",
                          category: _categoryTextController.text,
                          subCategory: _subCategoryTextController.text,
                          categoryImage: categoryImage ?? "",
                        );
                        EasyLoading.dismiss();
                      }
                      _provider.resetProvider();
                      //  reset only after saving completed
                    }
                  },
                  child: Container(
                    color: Colors.pinkAccent,
                    child: const Center(
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: doc == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    AbsorbPointer(
                      absorbing: _editing,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 80,
                                height: 30,
                                child: TextFormField(
                                  controller: _brandText,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    hintText: "Brand",
                                    hintStyle:
                                        const TextStyle(color: Colors.grey),
                                    border: const OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(.1),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text("SKU : "),
                                  SizedBox(
                                    width: 50,
                                    child: TextFormField(
                                      controller: _skuText,
                                      style: const TextStyle(fontSize: 12),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                            child: TextFormField(
                              controller: _productNameText,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: TextFormField(
                              controller: _weightText,
                              style: const TextStyle(fontSize: 20),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 80,
                                child: TextFormField(
                                  controller: _priceText,
                                  style: const TextStyle(fontSize: 18),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    prefixText: "\$",
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: TextFormField(
                                  controller: _comparedPriceText,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    prefixText: "\$",
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.red,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    "${discount!.toStringAsFixed(0)}% OFF",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Text(
                            "Inclusive of all taxes",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              _provider.getProductImage().then((image) {
                                setState(() {
                                  _image = image;
                                });
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _image != null
                                  ? Image.file(
                                      _image!,
                                      height: 300,
                                    )
                                  : Image.network(
                                      image ?? "",
                                      height: 300,
                                    ),
                            ),
                          ),
                          const Text(
                            "About this Product",
                            style: TextStyle(fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextFormField(
                              maxLines: null,
                              controller: _descriptionText,
                              keyboardType: TextInputType.multiline,
                              style: const TextStyle(color: Colors.grey),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                              children: [
                                const Text(
                                  "Category",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    // this blocks users entering category name manually
                                    child: TextFormField(
                                      controller: _categoryTextController,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Select category name";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Not selected",
                                        labelStyle:
                                            const TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
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
                                          return const SubCategoryList();
                                        }).whenComplete(() {
                                      setState(() {
                                        _subCategoryTextController.text =
                                            _provider.selectedSubCategory!;
                                      });
                                    });
                                  },
                                  icon: const Icon(Icons.edit_outlined),
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
                        padding: const EdgeInsets.only(top: 10, bottom: 20),
                        child: Row(
                          children: [
                            const Text(
                              "Sub Category",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: AbsorbPointer(
                                absorbing: true,
                                child: TextFormField(
                                  controller: _subCategoryTextController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Select sub Category name";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Not selected",
                                    labelStyle:
                                        const TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: _editing ? false : true,
                              child: IconButton(
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
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          const Text(
                            "Collection",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          DropdownButton<String>(
                            hint: const Text("Select Collection"),
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: _collection.map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Text("Stock : "),
                        Expanded(
                          child: TextFormField(
                            controller: _stockTextController,
                            style: const TextStyle(color: Colors.grey),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Low Stock : "),
                        Expanded(
                          child: TextFormField(
                            controller: _lowStockTextController,
                            style: const TextStyle(color: Colors.grey),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("Tax % : "),
                        Expanded(
                          child: TextFormField(
                            controller: _taxTextController,
                            style: const TextStyle(color: Colors.grey),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}


























/*import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import '../services/firebase_services.dart';
import '../widgets/category_list.dart';

class EditViewProduct extends StatefulWidget {
  final String productId;
  const EditViewProduct({super.key, required this.productId});

  @override
  State<EditViewProduct> createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services = FirebaseServices();
  final _formKey = GlobalKey<FormState>();

  final List<String> _collection = [
    "Featured Products",
    "Best Selling",
    "Recenttly Added"
  ];
  String dropdownValue;

  final _brandText = TextEditingController();
  final _skuText = TextEditingController();
  final _productNameText = TextEditingController();
  final _weightText = TextEditingController();
  final _priceText = TextEditingController();
  final _comparedPriceText = TextEditingController();
  var _descriptionText = TextEditingController();
  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  final _stockTextController = TextEditingController();
  final _lowStockTextController = TextEditingController();
  final _taxTextController = TextEditingController();

  DocumentSnapshot doc;
  double discount;
  String image;
  String categoryImage;
  File _image;
  bool _visible = false;
  bool _editing = true;

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void> getProductDetails() async {
    _services.products
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        setState(() {
          doc = document;
          _brandText.text = document.data()["brand"];
          _skuText.text = document.data()["sku"];
          _productNameText.text = document.data()["productName"];
          _weightText.text = document.data()["weight"];
          _priceText.text = document.data()["price"].toString();
          _comparedPriceText.text = document.data()["comparedPrice"].toString();
          var difference = int.parse(_comparedPriceText.text) -
              double.parse(_priceText.text);
          discount = (difference / int.parse(_comparedPriceText.text) * 100);
          image = document.data()["productImage"];
          _descriptionText = document.data()["description"];
          _categoryTextController = document.data()["category"]["mainCategory"];
          _subCategoryTextController =
              document.data()["category"]["subCategory"];
          dropdownValue = document.data()["collection"];
          _stockTextController.text = document.data()["stockQty"].toString();
          _lowStockTextController.text =
              document.data()["lowStockQty"].toString();
          _taxTextController.text = document.data()["tax"].toString();
          categoryImage = document.data()["categoryImage"];
        });
      }
    });

    @override
    Widget build(BuildContext context) {
      var _provider = Provider.of<ProductProvider>(context);

      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
              // to make back button white
              color: Colors.white),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    _editing = false;
                  });
                },
                child: const Text(
                  "Edit",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        bottomSheet: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.black87,
                  child: const Center(
                      child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  )),
                ),
              )),
              Expanded(
                  child: AbsorbPointer(
                absorbing: _editing,
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      EasyLoading.show(status: "Saving ...");
                      if (_image != null) {
                        // first upload new image and save data
                        _provider
                            .uploadProductImage(
                                _image.path, _productNameText.text)
                            .then((url) {
                          if (url != null) {
                            EasyLoading.dismiss();
                            _provider.updateProduct(
                              context: context,
                              productName: _productNameText.text,
                              weight: _weightText.text,
                              tax: double.parse(_taxTextController.text),
                              stockQty: int.parse(_stockTextController.text),
                              sku: _skuText.text,
                              price: double.parse(_priceText.text),
                              lowStockQty:
                                  int.parse(_lowStockTextController.text),
                              description: _descriptionText.text,
                              collection: dropdownValue,
                              brand: _brandText.text,
                              comparedPrice: int.parse(_comparedPriceText.text),
                              productId: widget.productId,
                              image: image,
                              category: _categoryTextController.text,
                              subCategory: _subCategoryTextController.text,
                              categoryImage: categoryImage,
                            );
                          }
                        });
                      } else {
                        // no need to change image, so just save new data. No need to upload image
                        _provider.updateProduct(
                            context: context,
                            productName: _productNameText.text,
                            weight: _weightText.text,
                            tax: double.parse(_taxTextController.text),
                            stockQty: int.parse(_stockTextController.text),
                            sku: _skuText.text,
                            price: double.parse(_priceText.text),
                            lowStockQty:
                                int.parse(_lowStockTextController.text),
                            description: _descriptionText.text,
                            collection: dropdownValue,
                            brand: _brandText.text,
                            comparedPrice: int.parse(_comparedPriceText.text),
                            productId: widget.productId,
                            image: image,
                            category: _categoryTextController.text,
                            subCategory: _subCategoryTextController.text,
                            categoryImage: categoryImage);
                        EasyLoading.dismiss();
                      }
                      _provider.resetProvider();
                      //  reset only after saving completed
                    }
                  },
                  child: Container(
                    color: Colors.pinkAccent,
                    child: const Center(
                        child: Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              )),
            ],
          ),
        ),
        body: doc == null
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView(
                    children: [
                      AbsorbPointer(
                        absorbing: _editing,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 30,
                                  child: TextFormField(
                                    controller: _brandText,
                                    decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        hintText: "Brand",
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        border: const OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.1)),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("SKU : "),
                                    SizedBox(
                                      width: 50,
                                      child: TextFormField(
                                        controller: _skuText,
                                        style: const TextStyle(fontSize: 12),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                              child: TextFormField(
                                controller: _productNameText,
                                style: const TextStyle(fontSize: 20),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              child: TextFormField(
                                controller: _weightText,
                                style: const TextStyle(fontSize: 20),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 80,
                                  child: TextFormField(
                                    controller: _priceText,
                                    style: const TextStyle(fontSize: 18),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      prefixText: "\$",
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: TextFormField(
                                    controller: _comparedPriceText,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough),
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      prefixText: "\$",
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.red,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Text(
                                      "${discount.toStringAsFixed(0)}% OFF",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              "Inclisive of all taxes",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            InkWell(
                              onTap: () {
                                _provider.getProductImage().then((image) {
                                  setState(() {
                                    _image = image;
                                  });
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _image != null
                                    ? Image.file(
                                        _image,
                                        height: 300,
                                      )
                                    : Image.network(
                                        image,
                                        height: 300,
                                      ),
                              ),
                            ),
                            const Text(
                              "About this Product",
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: TextFormField(
                                maxLines: null,
                                controller: _descriptionText,
                                keyboardType: TextInputType.multiline,
                                style: const TextStyle(color: Colors.grey),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 10),
                              child: Row(
                                children: [
                                  const Text(
                                    "Category",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      // this blocks users entering category name manually
                                      child: TextFormField(
                                        controller: _categoryTextController,
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
                                          enabledBorder: UnderlineInputBorder(
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
                                            return const SubCategoryList();
                                          }).whenComplete(() {
                                        setState(() {
                                          _subCategoryTextController.text =
                                              _provider.selectedSubCategory!;
                                        });
                                      });
                                    },
                                    icon: const Icon(Icons.edit_outlined),
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
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: Row(
                            children: [
                              const Text(
                                "Sub Category",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: AbsorbPointer(
                                  absorbing: true,
                                  child: TextFormField(
                                    controller: _subCategoryTextController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Select sub Category name";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Not selected",
                                      labelStyle:
                                          const TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _editing ? false : true,
                                child: IconButton(
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
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            const Text(
                              "Collection",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            DropdownButton<String>(
                                hint: const Text("Select Collection"),
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_drop_down),
                                items:
                                    _collection.map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  },
                                ).toList(),
                                onChanged: (String value) {
                                  setState(() {
                                    dropdownValue = value;
                                  });
                                })
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Text("Stock : "),
                          Expanded(
                            child: TextFormField(
                              controller: _stockTextController,
                              style: const TextStyle(color: Colors.grey),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Low Stock : "),
                          Expanded(
                            child: TextFormField(
                              controller: _lowStockTextController,
                              style: const TextStyle(color: Colors.grey),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text("Tax % : "),
                          Expanded(
                            child: TextFormField(
                              controller: _taxTextController,
                              style: const TextStyle(color: Colors.grey),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                    ],
                  ),
                ),
              ),
      );
    }
  }
}*/
