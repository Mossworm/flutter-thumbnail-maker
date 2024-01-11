import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

enum PageType { none, pickImage }

class SelectedImage with ChangeNotifier {
  Uint8List? _bytesFromPicker;
  Uint8List? get bytesFromPicker => _bytesFromPicker;

  PageType _pageType = PageType.none;
  PageType get pageType => _pageType;

  Future<void> pickImageFromBytes() async {
    _bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    // _image = Image.memory(_bytesFromPicker!);
    setPageType(PageType.none);
    notifyListeners();
  }

  void setPageType(PageType pageType) {
    _pageType = pageType;
    notifyListeners();
  }

  void setBytesFromPicker(Uint8List bytesFromPicker) {
    _bytesFromPicker = bytesFromPicker;
    // _image = Image.memory(_bytesFromPicker!);
    setPageType(PageType.none);
    notifyListeners();
  }

  Future<void> downloadImage(BuildContext context) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('아직 기능 구현중...'),
      ),
    );
  }
}
