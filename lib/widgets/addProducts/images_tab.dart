import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../provider/product_provider.dart';

class ImagesTab extends StatefulWidget {
  const ImagesTab({super.key});

  @override
  State<ImagesTab> createState() => _ImagesTabState();
}

class _ImagesTabState extends State<ImagesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final ImagePicker _picker = ImagePicker();

  Future<List<XFile>?> _pickImage() async {
    final List<XFile> images = await _picker.pickMultiImage();
    return images;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<ProductProvider>(builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TextButton(
              onPressed: () {
                _pickImage().then((value) {
                  var list = value!.forEach((image) {
                    setState(() {
                      provider.getImageFile(image);
                    });
                  });
                });
              },
              child: const Text("Add product image"),
            ),
            Center(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: provider.imageFiles!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onLongPress: () {
                          setState(() {
                            provider.imageFiles!.removeAt(index);
                          });
                        },
                        child: provider.imageFiles == null
                            ? const Center(
                                child: Text("No images selected"),
                              )
                            : Image.file(
                                File(provider.imageFiles![index].path))),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
