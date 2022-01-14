import 'dart:typed_data';
import 'package:apple_market/src/constants/common_size.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MultiImageSelect extends StatefulWidget {
  const MultiImageSelect({
    Key? key,
  }) : super(key: key);

  @override
  State<MultiImageSelect> createState() => _MultiImageSelectState();
}

class _MultiImageSelectState extends State<MultiImageSelect> {
  final List<Uint8List> _images = [];

  bool _isPickingImages = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size _size = MediaQuery.of(context).size;
        var imgSize = (_size.width / 3) - padding_16 * 2;

        return SizedBox(
          height: _size.width / 3,
          // width: _size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(padding_16),
                child: InkWell(
                  onTap: () async {
                    _isPickingImages = true;
                    setState(() {});

                    final ImagePicker _picker = ImagePicker();
                    // Pick multiple images
                    final List<XFile>? images = await _picker.pickMultiImage(imageQuality: 10);
                    if (images != null && images.isNotEmpty) {
                      // images[0].readAsBytes(), 데이터 타입 확인용
                      _images.clear();
                      for (var xFile in images) {
                        _images.add(await xFile.readAsBytes());
                      }
                    }
                    _isPickingImages = false;
                    setState(() {});
                  },
                  child: Container(
                    width: imgSize,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(padding_16),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: _isPickingImages
                        ? const Padding(
                            padding: EdgeInsets.all(padding_16 * 2),
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_alt_rounded, color: Colors.grey),
                              Text('0/10', style: Theme.of(context).textTheme.subtitle2),
                            ],
                          ),
                  ),
                ),
              ),
              ...List.generate(
                _images.length,
                (index) => Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          right: padding_16, top: padding_16, bottom: padding_16),
                      // future 타입을 변환해야 함.
                      child: ExtendedImage.memory(
                        _images[index],
                        width: imgSize,
                        height: imgSize,
                        fit: BoxFit.cover,
                        loadStateChanged: (state) {
                          switch (state.extendedImageLoadState) {
                            case LoadState.loading:
                              return Container(
                                  width: imgSize,
                                  height: imgSize,
                                  padding: const EdgeInsets.all(padding_16 * 2),
                                  child: const CircularProgressIndicator());
                            case LoadState.completed:
                              return null;
                            case LoadState.failed:
                              return const Icon(Icons.cancel);
                          }
                        },
                        borderRadius: BorderRadius.circular(padding_16),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      width: 40,
                      height: 40,
                      child: IconButton(
                        padding: const EdgeInsets.all(8),
                        onPressed: () {
                          _images.removeAt(index);
                          setState(() {});
                        },
                        icon: const Icon(Icons.remove_circle),
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
