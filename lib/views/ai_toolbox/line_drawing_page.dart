/*
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';


class LineDrawingPage extends StatefulWidget {
  @override
  _LineDrawingPageState createState() => _LineDrawingPageState();
}

class _LineDrawingPageState extends State<LineDrawingPage> {
  Uint8List? _lineDrawingImage;
  File linesArtImage=new File("");

  @override
  void initState() {
    super.initState();
    _convertImageToLineDrawing();
  }

  Future<void> _convertImageToLineDrawing() async {
    // Load image from assets
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if(image!=null){
      final Uint8List bytes = await image.readAsBytes();

      // Decode image
      img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage == null) return;

      // Convert to grayscale
      // img.Image grayscaleImage = img.grayscale(originalImage);

      // Apply Sobel edge detection
      //  sobelEdgeDetection(File(image.path));
      // _loadAndProcessImage(File(image.path));
    }


    // Convert processed image to Uint8List

  }

//   sobelEdgeDetection(File imageData) async {
//
//     img.Image? ima = im.LoadImageFromPath(imageData.path);
//
// // Apply a treshold and detect contours
//     var contours = ima?.threshold(100).detectContours();
//
//
// // Draw all the contours on the image in red
//     ima?.drawContours(contours!, img.ColorFloat16.rgb(255,0,0), filled: false);
//
// // Sort all the contours by area and find the biggest one
//     contours?.sort( (c,b) => (b.getArea() - c.getArea()).toInt());
//     var biggestcontour = contours?.first;
// // Draw the biggest contour in green and filled
//     ima?.drawContour(biggestcontour!, img.ColorFloat16.rgb(0,255,0),  true);
//
// // Display the widget
//     Image mywidget=ima!.getWidget(BoxFit.contain);
//
//     setState(() {
//       _lineDrawingImage=mywidget.;
//       print("done");
//
//     });
//
//
//   }

//   Future<void> _loadAndProcessImage(File imageData) async {
//     // Load the image from file
//     final imagePath = imageData.path;
//     final imageFile = File(imagePath);
//     final imageBytes = await imageFile.readAsBytes();
//     img.Image? image = img.decodeImage(imageBytes);
//
//     if (image != null) {
//       // Apply threshold and detect contours
//       image = img.copyResize(image, width: image.width, height: image.height);
//       final thresholded = img.threshold(image, 100);
//       final contours = img.findContours(thresholded);
//
//       // Draw all contours in red
//       for (final contour in contours) {
//         img.drawContours(image, contour, img.getColor(255, 0, 0));
//       }
//
//       // Sort contours by area and find the biggest one
//       contours.sort((a, b) => b.area.compareTo(a.area));
//       final biggestContour = contours.first;
//
//       // Draw the biggest contour in green and filled
//       img.fillContour(image, biggestContour, img.getColor(0, 255, 0));
//
//       // Convert the processed image to Uint8List
//       final processedImageBytes = Uint8List.fromList(img.encodeJpg(image));
//
//       // Update state with processed image bytes
//       setState(() {
//         _lineDrawingImage = processedImageBytes;
//       });
//     }
//
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Line Drawing Converter'),
      ),
      body: Center(
        child: _lineDrawingImage!=null
            ? Image.memory(_lineDrawingImage!)
            : CircularProgressIndicator(),
      ),
    );
  }
}
*/
