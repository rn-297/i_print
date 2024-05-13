import 'dart:io';

import 'package:get/get.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:image_picker/image_picker.dart';

class GraffitiCartoonLineController extends GetxController
    implements GetxService {
  String currentPage = "";

  String currentPageText = "";
  File selectedImage = File("path");

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
      selectedImage = File(photo.path);
      update();
    }
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (photo != null) {
      selectedImage = File(photo.path);
      update();
    }
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
}
