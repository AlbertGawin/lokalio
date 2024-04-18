import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<String> compressImage({
  required String path,
  bool isThumbnail = false,
}) async {
  final Uint8List bytes = await File(path).readAsBytes();
  final decodedImage = await decodeImageFromList(bytes);

  int minWidth = 0;
  int minHeight = isThumbnail ? 320 : 1280;
  int quality = 90;

  if (decodedImage.width > decodedImage.height) {
    minWidth = isThumbnail ? 320 : 1280;
    minHeight = 0;
    quality = 80;
  }

  final compressedImageBytes = await FlutterImageCompress.compressWithFile(
    path,
    format: CompressFormat.webp,
    quality: quality,
    minWidth: minWidth,
    minHeight: minHeight,
  );
  final webpImage = File('$path.webp');

  if (compressedImageBytes != null) {
    final image = await webpImage.writeAsBytes(compressedImageBytes);
    return image.path;
  }

  return path;
}
