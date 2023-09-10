/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/firebase_services.dart';
import '../../provider/product_provider.dart';

class GeneralTab extends StatefulWidget {
  const GeneralTab({super.key});

  @override
  State<GeneralTab> createState() => _GeneralTabState();
}

class _GeneralTabState extends State<GeneralTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final FirebaseServices _services = FirebaseServices();
  final List<String> _categories = [];
  String? selectedCategory;
  String? taxStatus;
  String? taxAmount;
  bool _salesPrice = false;

  Widget _categoryDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      hint: const Text(
        "Select category",
        style: TextStyle(fontSize: 16),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue!;
          provider.getFormData(
            category: newValue,
          );
        });
      },
      items: _categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value!.isEmpty) {
          return "Select category";
        }
        return null;
      },
    );
  }

  Widget _taxStatusDropDown(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      value: taxStatus,
      hint: const Text(
        "Tax Status",
        style: TextStyle(fontSize: 16),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          taxStatus = newValue!;
          provider.getFormData(
            taxStatus: newValue,
          );
        });
      },
      items: ["Taxable", "Non Taxable"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value!.isEmpty) {
          return "Select tax status";
        }
        return null;
      },
    );
  }

  Widget _taxAmount(ProductProvider provider) {
    return DropdownButtonFormField<String>(
      value: taxAmount,
      hint: const Text(
        "Tax amount",
        style: TextStyle(fontSize: 16),
      ),
      icon: const Icon(Icons.arrow_drop_down),
      elevation: 16,
      onChanged: (String? newValue) {
        setState(() {
          taxAmount = newValue!;
          provider.getFormData(
              taxPercentage: taxAmount == "VAT-18% " ? 18 : 30);
        });
      },
      items: ["VAT-18%", "Corporate - 30%"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value!.isEmpty) {
          return "Select tax amount";
        }
        return null;
      },
    );
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  getCategories() {
    _services.categories.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          _categories.add(element["catName"]);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              // PRODUCT NAME
              _services.formField(
                label: "Enter product name",
                inputType: TextInputType.name,
                onChanged: (value) {
                  // save in provider
                  provider.getFormData(
                    productName: value,
                  );
                },
              ),

              _services.formField(
                  label: "Enter desecription",
                  inputType: TextInputType.multiline,
                  minLine: 2,
                  maxLine: 10,
                  onChanged: (value) {
                    provider.getFormData(description: value);
                  }),
              const SizedBox(
                height: 30,
              ),
              _categoryDropDown(provider),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      provider.productData!["mainCategory"] ??
                          "Select main Category",
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    if (selectedCategory != null)
                      InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return MainCategoryList(
                                      selectedCategory: selectedCategory!,
                                      provider: provider);
                                }).whenComplete(() {
                              setState(() {});
                            });
                          },
                          child: const Icon(Icons.arrow_drop_down))
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      provider.productData!["subCategory"] ??
                          "Select sub Category",
                      style:
                          TextStyle(fontSize: 16, color: Colors.grey.shade700),
                    ),
                    if (provider.productData!["mainCategory"] != null)
                      InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SubCategoryList(
                                      selectedMainCategory: provider
                                          .productData!["mainCategory"]!,
                                      provider: provider);
                                }).whenComplete(() {
                              setState(() {});
                            });
                          },
                          child: const Icon(Icons.arrow_drop_down))
                  ],
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              const SizedBox(
                height: 30,
              ),
              _services.formField(
                label: "Regular Price (\$)",
                inputType: TextInputType.number,
                onChanged: (value) {
                  // save in provider
                  provider.getFormData(
                    regularPrice: int.parse(value),
                  );
                },
              ),
              _services.formField(
                label: "Sales Price (\$)",
                inputType: TextInputType.number,
                onChanged: (value) {
                  // save in provider
                  if (int.parse(value) >
                      provider.productData!["regularPrice"]) {
                    _services.scaffold(context,
                        "Sales price should be less than regular price");
                    return;
                  }
                  setState(
                    () {
                      provider.getFormData(
                        salesPrice: int.parse(value),
                      );
                      _salesPrice = true;
                    },
                  );
                },
              ),
              if (_salesPrice)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        ).then(
                          (value) {
                            setState(() {
                              provider.getFormData(scheduleDate: value);
                            });
                          },
                        );
                      },
                      child: const Text(
                        "Schedule",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    if (provider.productData!["scheduleDate"] != null)
                      Text(
                        _services.formattedDate(
                          provider.productData!["scheduleDate"],
                        ),
                      ),
                  ],
                ),
              const SizedBox(
                height: 30,
              ),
              _taxStatusDropDown(provider),
              if (taxStatus == "Taxable") _taxAmount(provider),
            ],
          ),
        );
      },
    );
  }
}

class MainCategoryList extends StatelessWidget {
  final String selectedCategory;
  final ProductProvider? provider;
  const MainCategoryList(
      {super.key, required this.selectedCategory, required this.provider});

  @override
  Widget build(BuildContext context) {
    FirebaseServices _service = FirebaseServices();
    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
          future: _service.mainCat
              .where("category", isEqualTo: selectedCategory)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.size == 0) {
              return const Center(
                child: Text("No Main Categories"),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      provider!.getFormData(
                          mainCategory: snapshot.data!.docs[index]
                              ["mainCategory"]);
                      Navigator.pop(context);
                    },
                    title: Text(
                      snapshot.data!.docs[index]["mainCategory"],
                    ),
                  );
                });
          }),
    );
  }
}

class SubCategoryList extends StatelessWidget {
  final String selectedMainCategory;
  final ProductProvider? provider;
  const SubCategoryList(
      {super.key, required this.provider, required this.selectedMainCategory});

  @override
  Widget build(BuildContext context) {
    FirebaseServices _service = FirebaseServices();
    return Dialog(
      child: FutureBuilder<QuerySnapshot>(
          future: _service.subCat
              .where("mainCategory", isEqualTo: selectedMainCategory)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.size == 0) {
              return const Center(
                child: Text("No Sub Categories"),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      provider!.getFormData(
                          subCategory: snapshot.data!.docs[index]
                              ["subCatName"]);
                      Navigator.pop(context);
                    },
                    title: Text(
                      snapshot.data!.docs[index]["subCatName"],
                    ),
                  );
                });
          }),
    );
  }
}*/
