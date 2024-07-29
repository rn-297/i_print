import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:pdfx/pdfx.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart' as path_provider;

class PdfFileAction {
  // static Future<List<Uint8List>> convertWordDocToImage(String docPath) async {
  //   print(docPath);
  //
  //   return ;
  // }

  static Future<List<Uint8List>> convertPdfImagesToUint8List(
      String path) async {
    try {
      List<Uint8List> images = [];

      PdfDocument document = await PdfDocument.openFile(path);

      for (int i = 1; i <= document.pagesCount; i++) {
        PdfPage page = await document.getPage(i);
        double aspectRatio = page.height / page.width;
        PdfPageImage? pageImage = await page.render(
            width: page.width,
            height: page.height,
            forPrint: true,
            backgroundColor: "#FFFFFF");

        // String targetPath = await getPath("jpg");
        // print(targetPath);
        Iterable<int> data = pageImage?.bytes ?? [];
        // await saveImageFile(List<int>.from(data), "fileName", targetPath);

        // var bytes = pageImage?.bytes;
        Directory appDocDir =
            await path_provider.getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;
        img.Image? originalImage =
            img.decodePng(Uint8List.fromList(List<int>.from(data)));
        final grayscaleImage = img.grayscale(originalImage!);
        final grayBytes = Uint8List.fromList(img.encodePng(grayscaleImage));
        String filePath = '$appDocPath/bitmap.jpg';

        // Check if the file exists and delete it if it does
        File file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          print('Existing file deleted.');
        }

        await file.writeAsBytes(grayBytes);

        String targetPath = '$appDocPath/compress_bitmap.jpg';
        if (await File(targetPath).exists()) {
          await File(targetPath).delete();
          print('Existing file deleted.');
        }
        int targetHeight = (384 * aspectRatio).round();
        await FlutterImageCompress.compressAndGetFile(filePath, targetPath,
            quality: 100, minWidth: 384, minHeight: targetHeight);
        images.add(File(targetPath).readAsBytesSync());
        await page.close();
      }

      return images;
    } catch (e) {
      // print("e  $e");
      return [];
    }
  }
}
