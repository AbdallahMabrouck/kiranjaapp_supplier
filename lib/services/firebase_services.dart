import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kiranjaapp_supplier/provider/product_provider.dart';

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference vendor =
      FirebaseFirestore.instance.collection("Vendor");
  final CollectionReference category =
      FirebaseFirestore.instance.collection("category");
  final CollectionReference mainCat =
      FirebaseFirestore.instance.collection("mainCategories");
  final CollectionReference subCat =
      FirebaseFirestore.instance.collection("subCategories");
  final CollectionReference product =
      FirebaseFirestore.instance.collection("product");
  final CollectionReference products =
      FirebaseFirestore.instance.collection("products");
  final CollectionReference vendorbanner =
      FirebaseFirestore.instance.collection('vendorbanner');

  CollectionReference boys = FirebaseFirestore.instance.collection('boys');
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String> uploadImage(XFile? file, String? reference) async {
    File _file = File(file!.path);
    firebase_storage.Reference ref =
        firebase_storage.FirebaseStorage.instance.ref(reference);

    await ref.putFile(_file);
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<List> uploadFiles(
      {List<XFile>? images, String? ref, ProductProvider? provider}) async {
    var imageUrls = await Future.wait(
      images!.map(
        (_image) => uploadFile(image: File(_image.path), reference: ref),
      ),
    );

    return imageUrls;
  }

  Future uploadFile({File? image, String? reference}) async {
    firebase_storage.Reference storageReference = storage
        .ref()
        .child("$reference/${DateTime.now().microsecondsSinceEpoch}");
    firebase_storage.UploadTask uploadTask = storageReference.putFile(image!);
    await uploadTask;
    return storageReference.getDownloadURL();
  }

  Future<void> addVendor({Map<String, dynamic>? data}) {
    // call the user's collectionReference to add a new user
    return vendor.doc(user!.uid).set(data).then((value) => print(
        "User added")) /*.catchError((error) => print("Failed to add user : $error"))*/;
  }

  Future<void> saveToDb({Map<String, dynamic>? data, BuildContext? context}) {
    // call the user's collectionReference to add a new user
    return products
        .add(data)
        .then((value) => scaffold(context, "Product saved"));
  }

  Future<void> publishProduct({id}) {
    return products.doc(id).update({
      "published": true,
    });
  }

  Future<void> unPublishProduct({id}) {
    return products.doc(id).update({
      "published": false,
    });
  }

  Future<void> deleteProduct({required String id}) {
    return products.doc(id).delete();
  }

  Future<void> saveBanner(url) {
    return vendorbanner.add({
      "imageUrl": url,
      "sellerUid": user!.uid,
    });
  }

  Future<void> deleteBanner({required String id}) {
    return vendorbanner.doc(id).delete();
  }

  Future<DocumentSnapshot> getShopDetails() async {
    DocumentSnapshot doc = await vendors.doc(user!.uid).get();
    return doc;
  }

  Future<DocumentSnapshot> getCustomerDetails(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }

  Future<void> selectBoys({orderId, location, name, image, phone}) {
    var result = orders.doc(orderId).update({
      "deliveryBoy": {
        "location": location,
        "name": name,
        "image": image,
        "phone": phone
      }
    });

    return result;
  }

  String formattedDate(date) {
    var outputFormat = DateFormat("dd/MM/yyy hr:min aa");
    var outputDate = outputFormat.format(date);
    return outputDate;
  }

  String formattedNumber(number) {
    var f = NumberFormat("#, ##, ###");
    String formattedNumber = f.format(number);
    return formattedNumber;
  }

  Widget formField(
      {String? label,
      TextInputType? inputType,
      void Function(String)? onChanged,
      int? maxLine,
      int? minLine}) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(label: Text(label!)),
      validator: (value) {
        if (value!.isEmpty) {
          return label;
        }
        return null;
      },
      onChanged: onChanged,
      minLines: minLine,
      maxLines: maxLine,
    );
  }

  scaffold(context, message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
          label: "Ok",
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
          }),
    ));
  }
}
