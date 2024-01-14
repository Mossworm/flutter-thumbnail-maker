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

  Uint8List? _modifiedBytes;
  Uint8List? get modifiedBytes => _modifiedBytes;

  PageType _pageType = PageType.none;
  PageType get pageType => _pageType;

  img.ColorRgb8 _backgroundColor = img.ColorRgb8(255, 255, 255);
  img.ColorRgb8 get backgroundColor => _backgroundColor;

  void setBackgroundColor(Color color) {
    _backgroundColor = img.ColorRgb8(color.red, color.green, color.blue);
    notifyListeners();
  }

  Future<void> pickImageFromBytes() async {
    _bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    _modifiedBytes = _bytesFromPicker;
    imageResize(300);
    setPageType(PageType.none);
    notifyListeners();
  }

  void setPageType(PageType pageType) {
    _pageType = pageType;
    notifyListeners();
  }

  void setBytesFromPicker(Uint8List bytesFromPicker) {
    _bytesFromPicker = bytesFromPicker;
    _modifiedBytes = _bytesFromPicker;
    imageResize(300);
    setPageType(PageType.none);
    notifyListeners();
  }

  Uint8List generateCompositeImage(Uint8List selectedImage) {
    const int targetWidth = 1280;
    const int targetHeight = 720;

    img.Image background = img.Image(width: targetWidth, height: targetHeight);
    img.fill(background, color: backgroundColor);

    img.Image overlayImage = img.decodeImage(selectedImage)!;

    int x = (targetWidth - overlayImage.width) ~/ 2;
    int y = (targetHeight - overlayImage.height) ~/ 2;

    img.compositeImage(background, overlayImage, dstX: x, dstY: y);

    Uint8List resultBytes = Uint8List.fromList(img.encodePng(background));

    return resultBytes;
  }

  void imageResize(int width) {
    img.Image currentImage = img.decodeImage(bytesFromPicker!)!;
    var modifiedImage = img.copyResize(currentImage, width: width);
    Uint8List resultBytes = Uint8List.fromList(
        img.encodePng(img.copyResize(modifiedImage, width: width)));
    _modifiedBytes = resultBytes;
    notifyListeners();
  }

  Future<void> downloadImage() async {
    final uint8List = generateCompositeImage(modifiedBytes!);
    await WebImageDownloader.downloadImageFromUInt8List(uInt8List: uint8List);
  }
}
