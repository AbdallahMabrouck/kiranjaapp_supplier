import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class ShopPicCard extends StatefulWidget {
  const ShopPicCard({Key? key});

  @override
  State<ShopPicCard> createState() => _ShopPicCardState();
}

class _ShopPicCardState extends State<ShopPicCard> {
  File? _image;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          _authData.getImage().then((image) {
            if (image != null) {
              setState(() {
                _image = image;
              });
              _authData.isPicAvail = true;
            }
          });
        },
        child: SizedBox(
          height: 150,
          width: 150,
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _image == null
                  ? const Center(
                      child: Text(
                        "Add Shop Image",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : Image.file(_image!, fit: BoxFit.fill),
            ),
          ),
        ),
      ),
    );
  }
}
