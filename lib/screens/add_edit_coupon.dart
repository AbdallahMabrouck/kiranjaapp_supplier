import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '../services/firebase_services.dart';

class AddEditCoupon extends StatefulWidget {
  static const String id = "add-edit-coupon-screen";
  final DocumentSnapshot? document;

  const AddEditCoupon({Key? key, required this.document}) : super(key: key);

  @override
  State<AddEditCoupon> createState() => _AddEditCouponState();
}

class _AddEditCouponState extends State<AddEditCoupon> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseServices _services = FirebaseServices();
  DateTime _selectedDate = DateTime.now();
  var dateText = TextEditingController();
  var titleText = TextEditingController();
  var detailsText = TextEditingController();
  var discountRateText = TextEditingController();
  bool _active = false;

  Future<void> _selectDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        String formattedText = DateFormat.yMMMd().format(_selectedDate);
        dateText.text = formattedText;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.document != null) {
      setState(() {
        titleText.text = widget.document!['title'];
        discountRateText.text = widget.document!['discountRate'].toString();
        detailsText.text = widget.document!['details'].toString();
        dateText.text =
            DateFormat.yMMMd().format(widget.document!['Expiry'].toDate());
        _active = widget.document!['active'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Add / Edit Coupon",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: titleText,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Coupon title";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: "Coupon Title",
                    labelStyle: TextStyle(color: Colors.grey)),
              ),
              TextFormField(
                controller: discountRateText,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Discount %";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: "Discount %",
                    labelStyle: TextStyle(color: Colors.grey)),
              ),
              TextFormField(
                controller: dateText,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Apply Expiry Date";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: "Expiry Date",
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 210, 100, 100)),
                    suffixIcon: InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: const Icon(Icons.date_range_outlined))),
              ),
              TextFormField(
                controller: detailsText,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Coupon Details";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    labelText: "Coupon Details",
                    labelStyle: TextStyle(color: Colors.grey)),
              ),
              SwitchListTile(
                activeColor: Theme.of(context).primaryColor,
                contentPadding: EdgeInsets.zero,
                title: const Text("Activate Coupon"),
                value: _active,
                onChanged: (bool newValue) {
                  setState(() {
                    _active = newValue;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          EasyLoading.show(status: "Please wait ...");
                          _services
                              .saveCoupon(
                            document: widget.document,
                            title: titleText.text.toUpperCase(),
                            details: detailsText.text,
                            discountRate: int.parse(discountRateText.text),
                            expiry: _selectedDate,
                            active: _active,
                          )
                              .then((value) {
                            setState(() {
                              titleText.clear();
                              discountRateText.clear();
                              detailsText.clear();
                              _active = false;
                            });
                            EasyLoading.showSuccess(
                                "Saved Coupon successfully");
                          });
                        }
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



















/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import '../services/firebase_services.dart';

class AddEditCoupon extends StatefulWidget {
  static const String id = "add-edit-coupon-screen";
  final DocumentSnapshot document;
  const AddEditCoupon({super.key, required this.document});

  @override
  State<AddEditCoupon> createState() => _AddEditCouponState();
}

class _AddEditCouponState extends State<AddEditCoupon> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseServices _services = FirebaseServices();
  DateTime _selectedDate = DateTime.now();
  var dateText = TextEditingController();
  var titleText = TextEditingController();
  var detailsText = TextEditingController();
  var discountRateText = TextEditingController();
  bool _active = false;

  _selectDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime.now(), 
      lastDate: DateTime(2050)
    );
    if(picked != null && != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        String formattedText = DateFormat(yMMMd).format(_selectedDate);
        dateText.text = formattedText;
      });
    }
  }

  @override
  void initState() {
    if(widget.document != null){
      setState(() {
        titleText.text = widget.document.data()["title"];
        discountRateText.text = widget.document.data()["discountRate"].toString();
        detailsText.text = widget.document.data()["details"].toString();
        dateText.text = widget.document.data()["Expiry"].toDate().toString();
        _active = widget.document.data()["active"];
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        title: const Text("Add / Edit Coupon", style: TextStyle(color: Colors.white),),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: titleText,
                validator: (value) {
                  if(value!.isEmpty){
                    return "Enter Coupon title";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero, 
                  labelText: "Coupon Title", 
                  labelStyle: TextStyle(color: Colors.grey)
                ),
              ), 
              TextFormField(
                controller: discountRateText,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if(value!.isEmpty){
                    return "Enter Discount %";
                  }
                  return null;
                },
                 decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero, 
                  labelText: "Discount %", 
                  labelStyle: TextStyle(color: Colors.grey)
                ),
              ),
               TextFormField(
                controller: dateText,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if(value!.isEmpty){
                    return "Apply Expiry Date";
                  }
                  return null;
                },
                 decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero, 
                  labelText: "Expiry Date", 
                  labelStyle: const TextStyle(color: Color.fromARGB(255, 210, 100, 100)), 
                  suffixIcon: InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: const Icon(Icons.date_range_outlined))
                ),
              ),
              TextFormField(
                controller: detailsText,
                validator: (value) {
                  if(value!.isEmpty){
                    return "Enter Coupon Details";
                  }
                  return null;
                },
                 decoration: const InputDecoration(
                  contentPadding: EdgeInsets.zero, 
                  labelText: "Coupon Details", 
                  labelStyle: TextStyle(color: Colors.grey)
                ),
              ),
              SwitchListTile(
                activeColor: Theme.of(context).primaryColor,
                contentPadding: EdgeInsets.zero,
                title: const Text("Activate Coupon"),
                value: _active, 
                onChanged: (bool newValue){
                  setState(() {
                    _active = !_active;
                  });
                }
                ), 
                const SizedBox(height: 20,), 
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        // color: Theme.of(context).primaryColor,
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                            EasyLoading.show(status: "Please wait ...");
                            _services.saveCoupon(
                              document: widget.document,
                              title: titleText.text.toUpperCase(), 
                              details: detailsText.text, 
                              discountRate: int.parse(discountRateText.text), 
                              expiry: _selectedDate,
                              active: _active
                            ).then((value){
                              setState(() {
                                titleText.clear();
                                discountRateText.clear();
                                detailsText.clear();
                                _active = false;
                              });
                              EasyLoading.showSuccess("saved Coupon successifully");
                            });
                          }
                        }, 
                        child: const Text("Submit", 
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                        ),
                    ),
                  ],
                )
            ],
          ),
        )
        )
    );
  }
}*/