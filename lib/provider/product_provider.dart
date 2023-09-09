


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{
  String selectedCategory;
  String selectedSubCategory;
  String categoryImage;
  File image;
  String pickerError;
  String shopName; 
  String productUrl;

  selectCategory(mainCategory, categoryImage){
    this.selectedCategory = mainCategory;
    this.categoryImage = categoryImage;
    // need to bring image here
    notifyListeners();

  }

  selectSubCategory(selected){
    this.selectedSubCategory = selected;
    notifyListeners();

  }

  getShopName(shopName){
    this.shopName = shopName;
    notifyListeners();
  }

  resetProvider(){
    // remove all the existing data before update next product
  this.selectedCategory = null;
  this.selectedSubCategory = null;
  this.categoryImage = null;
  this.image = null;
  this.productUrl = null;
  notifyListeners();
  }

  // upload product image

  Future<String> uploadProductImage(filePath, productName) async {
    File file = File(filePath); 
    // need file path to upload, we already have inside provider
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage.ref("productImage/$shopName/$productName$timeStamp").putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == "cancelled"
      print (e.code);
    }
    // now after upload file we need to file url path to save in database
    String downloadURL = await _storage.ref("productImage/$shopName$productName$timeStamp").getDownloadURL();
    productUrl == downloadURL;
    notifyListeners();
    return downloadURL;
  }

  Future<File>getProductImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality:20);
    if(pickedFile != null){
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = "No image selected";
      print ("No image selected");
      notifyListeners();
    }
    return this.image;
  }

  alertDialog({context, title, content}){
    showCupertinoDialog(
      context: context, 
      builder: (BuildContext context){
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(child: const Text("OK"), 
            onPressed: () {
              Navigator.pop(context);
            },
            )
          ],
        );
      });
  }

  // save product data to firestore
  Future<void>saveProductDataToDb(
    // need to bring these details from Add Product Screen
   { productName,
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
    }
  ){
    
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    // this will be used as product id
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference _products = FirebaseFirestore.instance.collection("products");
    try {
      _products.doc(timeStamp.toString()).set({
      "seller" : {"shopName" : this.shopName, "sellerUid" :user.uid },
      "productName" : productName,
      "description" : description,
      "price" : price, 
      "comparedPrice" : comparedPrice, 
      "collection" : collection,
      "brand" : brand, 
      "sku" : sku, 
      "category" : {"mainCategory" : selectedCategory, "subCategory" : selectedSubCategory, "categoryImage" : categoryImage},
      "weight" : weight,
      "tax" : tax,
      "stockQty" : stockQty, 
      "lowStockQty" : lowStockQty, 
      "published" : false, 
      "productId" : timeStamp.toString(),
      "productImage" : productUrl,
    }):
    alertDialog(
      context: context,
      title: "SAVE DATA",
      content: "Product Details saved successifully"
    );

    } catch(e) {
      alertDialog(
      context: context,
      title: "SAVE DATA",
      content: e.toString()
    );

    }
    return null;
  }

  Future<void>updateProduct(
    // need to bring these details from Add Product Screen
   { productName,
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

    }
  ){
    
    CollectionReference _products = FirebaseFirestore.instance.collection("products");
    try {
      _products.doc(productId).update({
      "productName" : productName,
      "description" : description,
      "price" : price, 
      "comparedPrice" : comparedPrice, 
      "collection" : collection,
      "brand" : brand, 
      "sku" : sku, 
      "category" : {"mainCategory" : category, "subCategory" : subCategory, "categoryImage" : categoryImage ?? categoryImage},
      "weight" : weight,
      "tax" : tax,
      "stockQty" : stockQty, 
      "lowStockQty" : lowStockQty, 
      "productImage" : productUrl == null ? image : productUrl,
    });
    alertDialog(
      context: context,
      title: "SAVE DATA",
      content: "Product Details saved successifully"
    );

    } catch(e) {
      alertDialog(
      context: context,
      title: "SAVE DATA",
      content: e.toString()
    );

    }
    return null;
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
}
