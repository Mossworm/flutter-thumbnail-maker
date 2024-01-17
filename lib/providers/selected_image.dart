import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:image/image.dart' as img;
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:flutter/services.dart' show rootBundle;

enum PageType { none, pickImage, addText }

const int targetWidth = 1280;
const int targetHeight = 720;

class SelectedImage with ChangeNotifier {
  Uint8List? _bytesFromPicker;
  Uint8List? get bytesFromPicker => _bytesFromPicker;

  Uint8List? _modifiedBytes;
  Uint8List? get modifiedBytes => _modifiedBytes;

  String? _addTextString;
  String? get addTextString => _addTextString;

  final img.Image _resultImage =
      img.Image(width: targetWidth, height: targetHeight);
  img.Image get resultImage => _resultImage;

  PageType _pageType = PageType.none;
  PageType get pageType => _pageType;

  img.ColorRgb8 _backgroundColor = img.ColorRgb8(255, 255, 255);
  img.ColorRgb8 get backgroundColor => _backgroundColor;

  img.ColorRgb8 _textColor = img.ColorRgb8(0, 0, 0);
  img.ColorRgb8 get textColor => _textColor;

  void setBackgroundColor(Color color) {
    _backgroundColor = img.ColorRgb8(color.red, color.green, color.blue);
    notifyListeners();
  }

  void setTextColor(Color color) {
    _textColor = img.ColorRgb8(color.red, color.green, color.blue);
    notifyListeners();
  }

  void setAddText(String text) {
    _addTextString = text;
    notifyListeners();
  }

  Future<void> pickImageFromBytes() async {
    _bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
    _modifiedBytes = _bytesFromPicker;
    imageResize(300);
    setPageType(PageType.none);
    notifyListeners();
  }

  Future<void> pickImageFromUrl(String url) async {
    Image.network(url).image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) async {
          final ByteData? byteData =
              await image.image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            _bytesFromPicker = byteData.buffer.asUint8List();
            _modifiedBytes = _bytesFromPicker;
            imageResize(300);
            setPageType(PageType.none);
            notifyListeners();
          }
        },
      ),
    );
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

  void imageResize(int width) {
    img.Image currentImage = img.decodeImage(bytesFromPicker!)!;
    var modifiedImage = img.copyResize(currentImage, width: width);
    Uint8List resultBytes = Uint8List.fromList(
        img.encodePng(img.copyResize(modifiedImage, width: width)));
    _modifiedBytes = resultBytes;
    notifyListeners();
  }

  Future<void> downloadImage() async {
    ByteData fontByteData = await rootBundle.load('assets/font.zip');
    img.BitmapFont font =
        img.BitmapFont.fromZip(fontByteData.buffer.asUint8List());
    img.fill(resultImage, color: backgroundColor);

    img.Image overlayImage = img.decodeImage(modifiedBytes!)!;

    int x = (targetWidth - overlayImage.width) ~/ 2;
    int y = (targetHeight - overlayImage.height) ~/ 2;

    if (addTextString != null && addTextString!.isNotEmpty) {
      img.drawString(resultImage, addTextString!,
          font: font, x: x, y: y + 80, color: textColor);
      x = (targetWidth - overlayImage.width) ~/ 7;
    }

    img.compositeImage(resultImage, overlayImage, dstX: x, dstY: y);

    final uint8List = Uint8List.fromList(img.encodePng(resultImage));
    await WebImageDownloader.downloadImageFromUInt8List(uInt8List: uint8List);

    print('다운완료');
  }
}
