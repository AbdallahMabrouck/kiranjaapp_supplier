import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart';

class AuthProvider extends ChangeNotifier {
  File? image;
  bool isPicAvail = false;
  String pickerError = "";
  String error = "";

  // shop data
  double? shopLatitude;
  double? shopLongitude;
  String? shopAddress;
  String? placeName;
  String? email;

  Future<File?> getImage() async {
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
    return image;
  }

  Future<void> getCurrentAddress() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    shopLatitude = _locationData.latitude;
    shopLongitude = _locationData.longitude;
    notifyListeners();

    final coordinates = Coordinates(shopLatitude!, shopLongitude!);
    var _addresses = await placemarkFromCoordinates(
        coordinates.latitude, coordinates.longitude);
    var shopAddress = _addresses.first;
    this.shopAddress = shopAddress.street;
    placeName = shopAddress.name;
    notifyListeners();
  }

  Future<UserCredential?> registerVendor(String email, String password) async {
    this.email = email;
    notifyListeners();
    UserCredential? userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      // Handle exceptions
    } catch (e) {
      // Handle other exceptions
    }
    return userCredential;
  }

  Future<UserCredential?> loginVendor(String email, String password) async {
    this.email = email;
    notifyListeners();
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      // Handle exceptions
    } catch (e) {
      // Handle other exceptions
    }
    return userCredential;
  }

  Future<void> resetPassword(String email) async {
    this.email = email;
    notifyListeners();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException {
      // Handle exceptions
    } catch (e) {
      // Handle other exceptions
    }
  }

  Future<void> saveVendorDataToDb({
    required String url,
    required String shopName,
    required String mobile,
    required String dialog,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors =
        FirebaseFirestore.instance.collection("vendors").doc(user!.uid);
    await _vendors.set({
      "uid": user.uid,
      "shopName": shopName,
      "mobile": mobile,
      "email": email,
      "dialog": dialog,
      "address": "${placeName ?? ''} : ${shopAddress ?? ''}",
      "location": GeoPoint(shopLatitude ?? 0, shopLongitude ?? 0),
      "shopOpen": true,
      "rating": 0.00,
      "totalRating": 0,
      "isTopPicked": true,
      "imageUrl": url,
      "accVerified": true,
    });
  }
}








/*import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  Map<String, dynamic>? productData = {"approved": false};
  final List<XFile>? imageFiles = [];

  getFormData(
      {String? productName,
      int? regularPrice,
      int? salesPrice,
      String? taxStatus,
      double? taxPercentage,
      String? category,
      String? mainCategory,
      String? subCategory,
      String? description,
      DateTime? scheduleDate,
      String? sku,
      bool? manageInventory,
      int? stockOnHand,
      int? reOrderLevel,
      bool? chargeShipping,
      int? shippingCharge,
      String? brand,
      List? sizeList,
      String? otherDetails,
      String? unit,
      List? imageUrls,
      Map? seller}) {
    if (seller != null) {
      productData!["seller"] = seller;
    }
    if (productName != null) {
      productData!["productName"] = productName;
    }
    if (regularPrice != null) {
      productData!["regularPrice"] = regularPrice;
    }
    if (salesPrice != null) {
      productData!["salesPrice"] = salesPrice;
    }
    if (taxStatus != null) {
      productData!["taxStatus"] = taxStatus;
    }
    if (taxPercentage != null) {
      productData!["taxValue"] = taxPercentage;
    }
    if (category != null) {
      productData!["category"] = category;
    }
    if (mainCategory != null) {
      productData!["mainCategory"] = mainCategory;
    }
    if (subCategory != null) {
      productData!["subCategory"] = subCategory;
    }
    if (description != null) {
      productData!["description"] = description;
    }
    if (scheduleDate != null) {
      productData!["scheduleDate"] = scheduleDate;
    }
    if (sku != null) {
      productData!["sku"] = sku;
    }
    if (manageInventory != null) {
      productData!["manageInventory"] = manageInventory;
    }
    if (stockOnHand != null) {
      productData!["stockOnHand"] = stockOnHand;
    }
    if (reOrderLevel != null) {
      productData!["reOrderLevel"] = reOrderLevel;
    }
    if (chargeShipping != null) {
      productData!["chargeShipping"] = chargeShipping;
    }
    if (shippingCharge != null) {
      productData!["shippingCharge"] = shippingCharge;
    }
    if (brand != null) {
      productData!["brand"] = brand;
    }
    if (sizeList != null) {
      productData!["size"] = sizeList;
    }
    if (otherDetails != null) {
      productData!["otherDetails"] = otherDetails;
    }
    if (unit != null) {
      productData!["unit"] = unit;
    }
    if (imageUrls != null) {
      productData!["imageUrls"] = imageUrls;
    }

    notifyListeners();
  }

  getImageFile(image) {
    imageFiles!.add(image);
    notifyListeners();
  }

  clearProductData() {
    productData!.clear();
    imageFiles!.clear();
    productData!["approved"] = false;
    notifyListeners();
  }
}*/
