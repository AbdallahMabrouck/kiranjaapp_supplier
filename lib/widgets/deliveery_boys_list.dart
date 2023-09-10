import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';

import '../services/firebase_services.dart';
import '../services/order_services.dart';

class DeliveryBoysList extends StatefulWidget {
  final DocumentSnapshot document;
  const DeliveryBoysList({super.key, required this.document});

  @override
  State<DeliveryBoysList> createState() => _DeliveryBoysListState();
}

class _DeliveryBoysListState extends State<DeliveryBoysList> {
  final FirebaseServices _services = FirebaseServices();
  final OrderServices _orderServices = OrderServices();

  GeoPoint? _shopLocation;

  @override
  void initState() {
    _services.getShopDetails().then((value) {
      if (value.exists) {
        final data = value.data() as Map<String, dynamic>?;
        if (data != null) {
          final location = data["location"] as GeoPoint?;
          setState(() {
            _shopLocation = location;
          });
        }
      } else {
        print("No data");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text(
                "Select Delivery Boy",
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: const IconThemeData(
                // To make back button white
                color: Colors.white,
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _services.boys
                    .where("accVerified", isEqualTo: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      final data = document.data() as Map<String, dynamic>?;

                      if (data == null) {
                        return Container();
                      }

                      final location = data["location"] as GeoPoint?;
                      double distanceInMeters = _shopLocation == null
                          ? 0.0
                          : Geolocator.distanceBetween(
                                _shopLocation!.latitude,
                                _shopLocation!.longitude,
                                location?.latitude ?? 0.0,
                                location?.longitude ?? 0.0,
                              ) /
                              1000;

                      if (distanceInMeters > 10) {
                        return Container();
                        // It will show only nearest delivery boys that are within a 10 Km radius.
                      }

                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              EasyLoading.show(status: "Assigning Boys");
                              _services
                                  .selectBoys(
                                orderId: widget.document.id,
                                phone: data["mobile"] as String?,
                                name: data["name"] as String?,
                                location: location,
                                image: data["imageUrl"] as String?,
                              )
                                  .then((value) {
                                EasyLoading.showSuccess(
                                    "Assigned Delivery Boy");
                                Navigator.pop(context);
                              });
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(
                                  data["imageUrl"] as String? ?? ""),
                            ),
                            title: Text(data["name"] as String? ?? ""),
                            subtitle: Text(
                                "${distanceInMeters.toStringAsFixed(0)} Km"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    _orderServices.launchMap(location!,
                                        data["name"] as String? ?? "");
                                  },
                                  icon: Icon(Icons.map,
                                      color: Theme.of(context).primaryColor),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _orderServices.launchCall(
                                        "tel: ${data["mobile"] as String?}");
                                  },
                                  icon: Icon(Icons.phone,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 2, color: Colors.grey),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}









/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';

import '../services/firebase_services.dart';
import '../services/order_services.dart';


class DeliveryBoysList extends StatefulWidget {
  final DocumentSnapshot document;
  const DeliveryBoysList({super.key, required this.document});

  @override
  State<DeliveryBoysList> createState() => _DeliveryBoysListState();
}

class _DeliveryBoysListState extends State<DeliveryBoysList> {
    final FirebaseServices _services = FirebaseServices();
    final OrderServices _orderServices = OrderServices();

    GeoPoint _shopLocation;

    @override
  void initState() {
    _services.getShopDetails().then((value){
      if(value != null){
        if(mounted){
          setState(() {
          _shopLocation = value.data()["location"];
        });
        }
      } else {
        print("No data");
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text("Select Delivery Boy", 
              style: TextStyle(color: Colors.white),),
              iconTheme: const IconThemeData(
                // To make back button white
                color: Colors.white
              ),
            ), 
           Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _services.boys
              .where("accVerified", isEqualTo: true)
              .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasError){
                  return const Text("Something went wrong");
                }
        
                if(!snapshot.hasData){
                  return const Center(child: CircularProgressIndicator());
                }
        
               return ListView(
                shrinkWrap: true,
                children: snapshot.data.docs.map((DocumentSnapshot document){
                    GeoPoint location = document.data()["location"];
                     double distanceInMeters = _shopLocation == null ? 0.0 : Geolocator.distanceBetween(
                      _shopLocation.latitude, _shopLocation.longitude,
                       location.latitude, location.longitude
                     )/1000;
                if(distanceInMeters > 10){
                  return Container();
                  // it will show only nearest delivery boys thats within 10 Km radius
                }
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          EasyLoading.show(status: "Assigning Boys");
                          _services.selectBoys(
                            orderId: widget.document.id, 
                            phone: document.data()["mobile"], 
                            name: document.data()["name"], 
                            location: document.data()["location"], 
                            image: document.data()["imageUrl"]
                          ).then((value){
                           EasyLoading.showSuccess("Assigned Delivery Boy");
                           Navigator.pop(context);
                          });
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.network(document.data()["imageUrl"],),
                        ),
                        title: Text(document.data()["name"]),
                        subtitle: Text("${distanceInMeters.toStringAsFixed(0)} Km"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                GeoPoint location = document.data()["location"];
                              _orderServices.launchMap(location, document.data()["name"]);
                              }, 
                              icon: Icon(Icons.map, color: Theme.of(context).primaryColor,)
                              ),

                               IconButton(
                              onPressed: () {
                               _orderServices.launchCall("tel : ${document.data()["mobile"]}");
                              }, 
                              icon:Icon(Icons.phone, color: Theme.of(context).primaryColor)
                              ),
                          ],
                        ),
                      ),
                      const Divider(height: 2, color: Colors.grey,)
                    ],
                  );
                }).toList(),
               );
             },
           ),
            ),
          ],
        ),
        
      ),
    );
  }
}*/