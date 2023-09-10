import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/deliveery_boys_list.dart';

class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection("orders");

  Future<void> updateOrderStatus(documentId, status) {
    var result = orders.doc(documentId).update({"orderStatus": status});

    return result;
  }

  Color statusColor(document) {
    if (document.data()["orderStatus"] == "Accepted") {
      return Colors.blueGrey.shade400;
    }
    if (document.data()["orderStatus"] == "Rejected") {
      return Colors.red;
    }
    if (document.data()["orderStatus"] == "Picked Up") {
      return Colors.pink.shade900;
    }
    if (document.data()["orderStatus"] == "On the Way") {
      return Colors.purple.shade900;
    }
    if (document.data()["orderStatus"] == "Delivered") {
      return Colors.green;
    }
    return Colors.orange;
  }

  Widget statusContainer(document, context) {
    if (document.data()["deliveryBoy"]["name"].length > 1) {
      return document.data()["deliveryBoy"]["image"] == null
          ? Container()
          : ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.network(
                  document.data()["deliveryBoy"]["image"],
                ),
              ),
              title: Text(document.data()["deliveryBoy"]["name"]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      GeoPoint location =
                          document.data()["deliveryBoy"]["location"];
                      launchMap(
                          location, document.data()["deliveryBoy"]["name"]);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: const Padding(
                          padding:
                              EdgeInsets.only(left: 8, right: 8, bottom: 2),
                          child: Icon(
                            Icons.map,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      launchCall(
                          "tel : ${document.data()["deliveryBoy"]["phone"]}");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: const Padding(
                          padding:
                              EdgeInsets.only(left: 8, right: 8, bottom: 2),
                          child: Icon(
                            Icons.phone_in_talk,
                            color: Colors.white,
                          ),
                        )),
                  ),
                ],
              ),
            );
    }
    if (document.data()["orderStatus"] == "Accepted") {
      return Container(
        color: Colors.grey.shade300,
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    ButtonStyleButton.allOrNull<Color>(Colors.orangeAccent),
              ),
              onPressed: () {
                //  delivery boys list
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DeliveryBoysList(
                        document: document,
                      );
                    });
              },
              child: const Text(
                "Select Delivery Boy",
                style: TextStyle(color: Colors.white),
              )),
        ),
      );
    }

    return Container(
      color: Colors.grey.shade300,
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  // color:Colors.blueGrey
                  onPressed: () {
                    showMyDialog(
                        "Accept Order", "Accepted", document.id, context);
                  },
                  child: const Text(
                    "Accept",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AbsorbPointer(
                absorbing:
                    document.data()["orderStatus"] == "Rejected" ? true : false,
                child: ElevatedButton(
                    // color: document.data()["orderStatus"] == "Rejected" ? Colors.grey : Colors.red
                    onPressed: () {
                      showMyDialog(
                          "Reject Order", "Rejected", document.id, context);
                    },
                    child: const Text(
                      "Reject",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Icon statusIcon(document) {
    if (document.data()["orderStatus"] == "Accepted") {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
      );
    }
    if (document.data()["orderStatus"] == "Picked Up") {
      return Icon(
        Icons.cases,
        color: statusColor(document),
      );
    }
    if (document.data()["orderStatus"] == "On the Way") {
      return Icon(
        Icons.delivery_dining,
        color: statusColor(document),
      );
    }
    if (document.data()["orderStatus"] == "Delivered") {
      return Icon(
        Icons.shopping_bag_outlined,
        color: statusColor(document),
      );
    }
    return Icon(
      Icons.assignment_turned_in_outlined,
      color: statusColor(document),
    );
  }

  showMyDialog(title, status, documentId, context) {
    OrderServices _orderServices = OrderServices();
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: const Text("Are you sure? "),
            actions: [
              ElevatedButton(
                onPressed: () {
                  EasyLoading.show(status: "Updating status");
                  status == "Accepted"
                      ? _orderServices
                          .updateOrderStatus(documentId, status)
                          .then((value) {
                          EasyLoading.showSuccess("Updated successifully");
                        })
                      : _orderServices
                          .updateOrderStatus(documentId, status)
                          .then((value) {
                          EasyLoading.showSuccess("Updated successifully");
                        });
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        });
  }

  void launchCall(number) async => await canLaunchUrl(number)
      ? await launchUrl(number)
      : throw "Could not launch $number";

  void launchMap(GeoPoint location, name) async {
    final availableMaps = await MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude), title: name);
  }
}
