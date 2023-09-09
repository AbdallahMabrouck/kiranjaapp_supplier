import 'package:flutter/cupertino.dart';

class OrderProvider with ChangeNotifier {
  String status = ''; // Initialize with an empty string

  filterOrder(status) {
    this.status = status;
    notifyListeners();
  }
}
