import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

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
  String email = "";

  // reduce image size
  Future<File?> getImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
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
    LocationData? _locationData;

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

    // Perform reverse geocoding using Google Maps Geocoding API
    const apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
    final response = await http.get(
      Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${_locationData.latitude},${_locationData.longitude}&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final address = data['results'][0]['formatted_address'];
        shopAddress = address;
        placeName = address;
        notifyListeners();
      }
    }
  }

  // register vendor using email
  Future<UserCredential?> registerVendor(String email, String password) async {
    this.email = email;
    notifyListeners();
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        error = "The password provided is too weak";
        notifyListeners();
      } else if (e.code == "email-already-in-use") {
        error = "The account already exists for that email";
        notifyListeners();
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
    return userCredential;
  }

  Future<UserCredential?> loginVendor(String email, String password) async {
    this.email = email;
    notifyListeners();
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      error = e.code;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
    return userCredential;
  }

  // reset password
  Future<void> resetPassword(String email) async {
    this.email = email;
    notifyListeners();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      error = e.code;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  // save vendor data to Firestore
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
    return;
  }
}
