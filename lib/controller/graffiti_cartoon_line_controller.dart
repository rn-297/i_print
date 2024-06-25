/*
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/ai_creation_controller.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/helper/print_images.dart';
import 'package:i_print/helper/router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
// import 'package:tflite/tflite.dart';

class GraffitiCartoonLineController extends GetxController
    implements GetxService {
  String currentPage = "";
  FlutterVision vision = FlutterVision();
  String currentPageText = "";
  File selectedImage = File("path");
  int selectedImageHeight = 0;
  int selectedImageWidth = 0;
  late Uint8List selectedImage1;
  late List<Map<String, dynamic>> yoloResults;
  bool isLoading = true;
  XFile selectedPhoto = XFile("");
  late Uint8List previewImage;
  late List<dynamic>rectRecognitions;

  setCurrentPage(String page) {
    currentPage = page;
    setCurrentPageText(page);
  }

  void clickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (photo != null) {
      if (currentPage == AppConstants.lineArt) {
        Get.toNamed(RouteHelper.graffitiCartoonLinePreviewPage);
        lineDraw();
      }
      if (currentPage == AppConstants.graffitiPractice) {
        loadVision();
      }
      if (currentPage == PrintImages.cartoonish) {}
    }
  }

  void pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (photo != null) {
      if (currentPage == AppConstants.lineArt) {
        isLoading=true;
        selectedPhoto = photo;
        Get.toNamed(RouteHelper.graffitiCartoonLinePreviewPage);
      }
      if (currentPage == AppConstants.graffitiPractice) {
        isLoading=true;
        selectedPhoto = photo;
        Get.toNamed(RouteHelper.graffitiCartoonLinePreviewPage);
        loadVision();
      }
      if (currentPage == AppConstants.cartoonishPortraits) {
        isLoading=true;
        selectedPhoto = photo;

          cartoonImage(context);

      }
    }
  }

  Future<bool> lineDraw() async {
    // Uint8List bytes = await selectedPhoto.readAsBytes();
    // final originalImage = img.decodeImage(bytes);
    // final grayscaleImage = img.grayscale(originalImage!);
    //
    // final lineArtImage1 = img.sobel(grayscaleImage);
    // final quantizeImage = img.edgeGlow(lineArtImage1);
    // final invertedImage = img.invert(quantizeImage);
    //
    // previewImage = img.encodePng(invertedImage);
    // isLoading = false;
    // update();
    return true;
  }

  loadVision() async {
    // Tflite.close();

    // String? res = await Tflite.loadModel(
    //   model: "assets/models/yolov2_tiny.tflite",
    //   labels: "assets/models/yolov2_tiny.txt",
    //   // useGpuDelegate: true,
    // );
    // print(res);
    Uint8List bytes = await selectedPhoto.readAsBytes();
    selectedImage1=bytes;

    // var recognitions = await Tflite.detectObjectOnImage(
    //   path: selectedPhoto.path,
    //   model: "YOLO",
    //   threshold: 0.3,
    //   imageMean: 0.0,
    //   imageStd: 255.0,
    //   numResultsPerClass: 10,
    // );
    // print(recognitions);
    // rectRecognitions=recognitions!;
    isLoading=false;
    update();

  }

  setCurrentPageText(String page) {
    switch (page) {
      case AppConstants.graffitiPractice:
        currentPageText =
            "Select an image and I will automatically generate an outline for you for easy copying and doodling";
        break;
      case AppConstants.cartoonishPortraits:
        currentPageText =
            "Upload a portrait and I'll automatically convert you into cartoon style";
        break;
      case AppConstants.lineArt:
        currentPageText =
            "Upload an image and I will automatically convert it into line drawing for you!";
        break;
    }
  }

  Future<bool> cartoonImage(BuildContext context) async {
    */
/*print("cartoon");
    Uint8List bytes = await selectedPhoto.readAsBytes();
    final originalImage = img.decodeImage(bytes);

    final lineArtImage1 = img.sobel(originalImage!);
    final quantizeImage = img.quantize(lineArtImage1);

    previewImage = img.encodePng(quantizeImage);
    isLoading = false;*//*

    AICreationController controller=Get.put(AICreationController());
    controller.currentPage=AppConstants.cartoonishPortraits;
    controller.getApiKey(context);


    // update();
    return true;
  }



}
*/
