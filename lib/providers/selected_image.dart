import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:image/image.dart' as img;
import 'package:image_downloader_web/image_downloader_web.dart';

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

  Uint8List generateCompositeImage(Uint8List selectedImage) {
    final int targetWidth = 1280;
    final int targetHeight = 720;

    img.Image background = img.Image(width: targetWidth, height: targetHeight);
    img.fill(background, color: img.ColorRgb8(255, 255, 255));

    img.Image overlayImage = img.decodeImage(selectedImage)!;

    int x = (targetWidth - overlayImage.width) ~/ 2;
    int y = (targetHeight - overlayImage.height) ~/ 2;

    img.compositeImage(background, overlayImage, dstX: x, dstY: y);

    Uint8List resultBytes = Uint8List.fromList(img.encodePng(background));

    return resultBytes;
  }

  Future<void> downloadImage() async {
    final uint8List = generateCompositeImage(bytesFromPicker!);
    await WebImageDownloader.downloadImageFromUInt8List(uInt8List: uint8List);
  }
}
