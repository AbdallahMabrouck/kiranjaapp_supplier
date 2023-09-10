import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  String? selectedCategory;
  String? selectedSubCategory;
  String? categoryImage;
  File? image;
  String pickerError = "";
  String? shopName;
  String? productUrl;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  selectCategory(mainCategory, categoryImage) {
    selectedCategory = mainCategory;
    categoryImage = categoryImage;
    notifyListeners();
  }

  selectSubCategory(selected) {
    selectedSubCategory = selected;
    notifyListeners();
  }

  getShopName(shopName) {
    this.shopName = shopName;
    notifyListeners();
  }

  resetProvider() {
    // remove all existing data before updating next products
    selectedCategory = null;
    selectedSubCategory = null;
    categoryImage = null;
    image = null;
    productUrl = null;
    notifyListeners();
  }

  // upload product image

  Future<String> uploadProductImage(filePath, productName) async {
    File file = File(filePath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage
          .ref("productImage/$shopName/$productName$timeStamp")
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }

    // after uploading, we need file url path to save to database

    String downloadURL = await _storage
        .ref("productImage/$shopName$productName$timeStamp")
        .getDownloadURL();
    productUrl = downloadURL;
    notifyListeners();
    return downloadURL;
  }

  Future<File> getProductImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    } else {
      pickerError = "No image selected";
      print("No image selected");
      notifyListeners();
    }
    return image!;
  }

  void alertDialog({context, title, content}) {
    showDialog(
      context: _scaffoldKey.currentContext!,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  // save product data to firestore

  Future<void> saveProductDataToDb(
      {required String productName,
      required String description,
      required double price,
      required double comparedPrice,
      required String collection,
      required String brand,
      required String sku,
      required String categoryName,
      required double weight,
      required double tax,
      required int stockQty,
      required int lowStockQty,
      required context}) async {
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    // this will be used as product id
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference _products =
        FirebaseFirestore.instance.collection("products");

    try {
      await _products.doc(timeStamp.toString()).set({
        "seller": {"shopName": shopName, "sellerUid": user!.uid},
        "productName": productName,
        "description": description,
        "price": price,
        "comparedPrice": comparedPrice,
        "collection": collection,
        "brand": brand,
        "sku": sku,
        "category": {
          "mainCategory": selectedCategory,
          "subCategory": selectedSubCategory,
          "categoryImage": categoryImage,
        },
        "weight": weight,
        "tax": tax,
        "stockQty": stockQty,
        "lowStockQty": lowStockQty,
        "published": false,
        "productId": timeStamp.toString(),
        "productImage": productUrl,
      });

      alertDialog(
        context: context,
        title: "SAVE DATA",
        content: "Product Details saved successfully",
      );
    } catch (e) {
      alertDialog(
        context: context,
        title: "SAVE DATA",
        content: e.toString(),
      );
    }
  }

  Future<void>? updateProduct(
      // need to bring these details from Add Product Screen
      {
    productName,
    description,
    price,
    comparedPrice,
    collection,
    brand,
    sku,
    categoryName,
    weight,
    tax,
    stockQty,
    lowStockQty,
    context,
    productId,
    image,
    category,
    subCategory,
    categoryImage,
  }) {
    CollectionReference _products =
        FirebaseFirestore.instance.collection("products");
    try {
      _products.doc(productId).update({
        "productName": productName,
        "description": description,
        "price": price,
        "comparedPrice": comparedPrice,
        "collection": collection,
        "brand": brand,
        "sku": sku,
        "category": {
          "mainCategory": category,
          "subCategory": subCategory,
          "categoryImage": categoryImage ?? categoryImage
        },
        "weight": weight,
        "tax": tax,
        "stockQty": stockQty,
        "lowStockQty": lowStockQty,
        "productImage": productUrl ?? image,
      });
      alertDialog(
          context: context,
          title: "SAVE DATA",
          content: "Product Details saved successifully");
    } catch (e) {
      alertDialog(context: context, title: "SAVE DATA", content: e.toString());
    }
    return null;
  }
}
