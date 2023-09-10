import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/firebase_services.dart';
import '../provider/product_provider.dart';
import '../widgets/banner_card.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({Key? key}) : super(key: key);

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  final FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  File? _image;
  final _imagePathText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const BannerCard(),
          const Divider(
            thickness: 3,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: const Center(
              child: Text(
                "ADD NEW BANNER",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.grey.shade200,
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.fill,
                            )
                          : Center(
                              child: const Text("No image selected"),
                            ),
                    ),
                  ),
                  TextFormField(
                    controller: _imagePathText,
                    enabled: false,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: _visible ? false : true,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _visible = true;
                              });
                            },
                            child: const Text(
                              "Add New Banner",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _visible,
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    getBannerImage().then((value) {
                                      if (_image != null) {
                                        setState(() {
                                          _imagePathText.text = _image!.path;
                                        });
                                      }
                                    });
                                  },
                                  child: const Text(
                                    "Upload Image",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AbsorbPointer(
                                  absorbing: _image != null ? false : true,
                                  child: TextButton(
                                    onPressed: () {
                                      EasyLoading.show(status: "Saving ...");
                                      uploadBannerImage(_image?.path ?? "",
                                              _provider.shopName!)
                                          .then((url) {
                                        if (url != null) {
                                          // save banner url to firestore
                                          _services.saveBanner(url);
                                          setState(() {
                                            _imagePathText.clear();
                                            _image = null;
                                          });
                                          EasyLoading.dismiss();
                                          _provider.alertDialog(
                                              context: context,
                                              title: "Banner Upload",
                                              content:
                                                  "Banner Image uploaded successfully...");
                                        } else {
                                          _provider.alertDialog(
                                              context: context,
                                              title: "Banner Upload",
                                              content: "Banner Upload failed");
                                        }
                                      });
                                    },
                                    child: const Text(
                                      "Save",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _visible = false;
                                      _imagePathText.clear();
                                      _image = null;
                                    });
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getBannerImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print("No image selected");
    }
  }

  Future<String?> uploadBannerImage(String filePath, String shopName) async {
    File file = File(filePath);
    // need file path to upload, we already have inside provider
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage.ref("vendorBanner/$shopName/$timeStamp").putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == "cancelled"
      print(e.code);
      return null;
    }
    // now after upload file we need the file url path to save in the database
    String downloadURL = await _storage
        .ref("vendorBanner/$shopName/$timeStamp")
        .getDownloadURL();
    return downloadURL;
  }
}










/*import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/firebase_services.dart';
import '../provider/product_provider.dart';
import '../widgets/banner_card.dart';

class BannerScreen extends StatefulWidget {
  const BannerScreen({super.key});

  @override
  State<BannerScreen> createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  FirebaseServices _services = FirebaseServices();
  bool _visible = false;
  File _image;
  var _imagePathText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          const BannerCard(),
          const Divider(
            thickness: 3,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            child: const Center(
              child: Text(
                "ADD NEW BANNER",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.grey.shade200,
                      child: _image != null
                          ? Image.file(
                              _image,
                              fit: BoxFit.fill,
                            )
                          : Center(
                              child: const Text("No image selected"),
                            ),
                    ),
                  ),
                  TextFormField(
                    controller: _imagePathText,
                    enabled: false,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: _visible ? false : true,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _visible = true;
                              });
                            },
                            child: const Text(
                              "Add New Banner",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _visible,
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    getBannerImage().then((value) {
                                      if (_image != null) {
                                        setState(() {
                                          _imagePathText.text = _image.path;
                                        });
                                      }
                                    });
                                  },
                                  child: const Text(
                                    "Upload Image",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AbsorbPointer(
                                  absorbing: _image != null ? false : true,
                                  child: TextButton(
                                    // color: _image!= null ? Theme.of(context).primaryColor : Colors.grey
                                    onPressed: () {
                                      EasyLoading.show(status: "Saving ...");
                                      uploadBannerImage(
                                              _image.path, _provider.shopName)
                                          .then((url) {
                                        if (url != null) {
                                          // save banner url to firestore
                                          _services.saveBanner(url);
                                          setState(() {
                                            _imagePathText.clear();
                                            _image = null;
                                          });
                                          EasyLoading.dismiss();
                                          _provider.alertDialog(
                                              context: context,
                                              title: "Banner Upload",
                                              content:
                                                  "Banner Image uploaded successifully...");
                                        } else {
                                          _provider.alertDialog(
                                              context: context,
                                              title: "Banner Upload",
                                              content: "Banner Upload failed");
                                        }
                                      });
                                    },
                                    child: const Text(
                                      "Save",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _visible = false;
                                      _imagePathText.clear();
                                      _image = null;
                                    });
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<File> getBannerImage() async {
  final picker = ImagePicker();
  final pickedFile =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 20);
  if (pickedFile != null) {
    setStates(() {
      _image = File(pickedFile.path);
    });
  } else {
    print("No image selected");
  }
  return _image;
}

Future<String> uploadBannerImage(filePath, shopName) async {
  File file = File(filePath);
  // need file path to upload, we already have inside provider
  var timeStamp = Timestamp.now().millisecondsSinceEpoch;

  FirebaseStorage _storage = FirebaseStorage.instance;

  try {
    await _storage.ref("vendorBanner/$shopName/$timeStamp").putFile(file);
  } on FirebaseException catch (e) {
    // e.g, e.code == "cancelled"
    print(e.code);
  }
  // now after upload file we need to file url path to save in database
  String downloadURL =
      await _storage.ref("vendorBanner/$shopName/$timeStamp").getDownloadURL();
  return downloadURL;
}
*/