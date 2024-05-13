import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/router.dart';

import '../api_service/api_service.dart';

class AICreationController extends GetxController {
  TextEditingController aiPaintController = TextEditingController();
  bool isProcessing = false;
  String generatedImage = "";
  String imageBase64 = "";
  Uint8List? memoryImage;
  bool withImage=false;

  void getData() async {
    isProcessing = true;
    update();
    Get.toNamed(RouteHelper.aiImagePreviewPage);
    Map<String, dynamic> requestBody = {
      "version":
          "39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b",
      "input": {
        // "image": "https://example.com/login_page.png",
        "width": 768,
        "height": 768,
        "prompt": aiPaintController.text,
        "refine": "expert_ensemble_refiner",
        "scheduler": "K_EULER",
        "lora_scale": 0.6,
        "num_outputs": 1,
        "guidance_scale": 7.5,
        "apply_watermark": false,
        "high_noise_frac": 0.8,
        "negative_prompt": "",
        "prompt_strength": 0.8,
        "num_inference_steps": 25
      }
    };
    var id = await ApiClient.postHeaderData(
        "https://api.replicate.com/v1/predictions", requestBody);
    var string = await ApiClient.getHeaderData(
        "https://api.replicate.com/v1/predictions/${json.decode(id)["id"]}"); ////
    print(string);
    generatedImage = string;
    isProcessing = false;
    update();
  }

  void getDataImage() async {
    isProcessing = true;
    withImage=true;
    update();
    Get.toNamed(RouteHelper.aiImagePreviewPage);
    Map<String, dynamic> requestBody = {
      "version":
          "39ed52f2a78e934b3ba6e2a89f5b1c712de7dfea535525255b1aa35c5565e08b",
      "input": {
        "image": imageBase64,
        "width": 768,
        "height": 768,
        "prompt": aiPaintController.text,
        "refine": "expert_ensemble_refiner",
        "scheduler": "K_EULER",
        "lora_scale": 0.6,
        "num_outputs": 1,
        "guidance_scale": 7.5,
        "apply_watermark": false,
        "high_noise_frac": 0.8,
        "negative_prompt": "",
        "prompt_strength": 0.8,
        "num_inference_steps": 25
      }
    };
    var id = await ApiClient.postHeaderData(
        "https://api.replicate.com/v1/predictions", requestBody);
    var string = await ApiClient.getHeaderData(
        "https://api.replicate.com/v1/predictions/${json.decode(id)["id"]}"); ////
    print(string);
    generatedImage = string;
    isProcessing = false;
    update();
  }

  setBase64(Uint8List uint8list) {
    memoryImage = uint8list;
    String img64 = base64.encode(uint8list);
    imageBase64 = "data:image/jpeg;base64,$img64";
    // aiPaintController.text= "road";
    // getDataImage();
    Get.toNamed(RouteHelper.creativePaintingPage);
    print(img64);
  }
}
