import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelectImageNotifier extends ChangeNotifier{
  final List<Uint8List> _images = [];

  Future setNewImages(List<XFile>? newImages) async {
    if(newImages != null && newImages.isNotEmpty){
      // images[0].readAsBytes(), 데이터 타입 확인용
      _images.clear();
      for (var xFile in newImages) {
        _images.add(await xFile.readAsBytes());
      }
      notifyListeners();
    }
  }

  void removeImage(int index){
    if(_images.length >= index) {
      _images.removeAt(index);
      notifyListeners();
    }
  }

  List<Uint8List> get images => _images;
}