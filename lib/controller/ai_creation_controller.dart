/*
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as Http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/graffiti_cartoon_line_controller.dart';
import 'package:i_print/helper/router.dart';
import 'package:i_print/print_features/bottom_sheet/stability_ai_api.dart';

import '../api_service/api_service.dart';

class AICreationController extends GetxController {
  TextEditingController aiPaintController = TextEditingController();
  String apiKey = '';
  bool isProcessing = false;
  String currentPage="";
  late Uint8List generatedImage;
  String imageBase64 = "";
  String selectedStyle = "anime";
  String initImageFile = "";
  Uint8List? memoryImage;
  bool withImage = false;
  List<String> stylesList = [
    "3d-model",
    "analog-film",
    "anime",
    "cinematic",
    "comic-book",
    "digital-art",
    "enhance",
    "fantasy-art",
    "isometric",
    "line-art",
    "low-poly",
    "modeling-compound",
    "neon-punk",
    "origami",
    "photographic",
    "pixel-art",
    "tile-texture"
  ];

  getApiKey(BuildContext context) {
    StabilityAIApi.showAPIKeyBottomSheet(context);
  }

  void getData() async {
    isProcessing = true;
    update();
    Get.toNamed(RouteHelper.aiImagePreviewPage);
    Map<String, dynamic> requestBody = {
      "text_prompts": [
        {"text": aiPaintController.text}
      ],
      "cfg_scale": 7,
      "height": 1024,
      "width": 1024,
      "samples": 1,
      "steps": 30,
      "style_preset": selectedStyle
    };
    final response = await ApiClient.postHeaderData(
        "https://api.stability.ai/v1/generation/stable-diffusion-v1-6/text-to-image",
        requestBody,
        apiKey);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJSON = jsonDecode(response.body);

      if (responseJSON.containsKey('artifacts')) {
        List<dynamic> artifacts = responseJSON['artifacts'];
        for (int i = 0; i < artifacts.length; i++) {
          var image = artifacts[i];
          String base64String = image['base64'];

          generatedImage = base64Decode(base64String);
        }
        print('Images generated and saved successfully.');
      } else {
        throw Exception('No artifacts found in response.');
      }
    }

    isProcessing = false;
    update();
  }

  void getDataImage() async {
    isProcessing = true;
    withImage = true;
    update();
    Get.toNamed(RouteHelper.aiImagePreviewPage);
    Uri url=Uri.parse("https://api.stability.ai/v1/generation/stable-diffusion-v1-6/image-to-image");
    final Http.MultipartRequest request = Http.MultipartRequest('POST', url
    )

      ..fields['init_image_mode'] = 'IMAGE_STRENGTH'
      ..fields['image_strength'] = '1'
      ..fields['text_prompts[0][text]'] = "crayon drawing of ${aiPaintController.text} "
      ..fields['cfg_scale'] = '7'
      ..fields['samples'] = '1'
      ..fields['sampler'] = 'K_DPM_2_ANCESTRAL'
      ..fields['clip_guidance_preset'] = 'FAST_BLUE'
      ..fields['steps'] = '30'
      ..fields['style_preset'] = selectedStyle
      ..files.add(await Http.MultipartFile.fromPath(
        'init_image',
        initImageFile,

      ));

    final response = await ApiClient.postHeaderMultipartData( request, apiKey);
    ////

    final String responseBody = await response.stream.bytesToString();
    final Map<String, dynamic> responseJSON = jsonDecode(responseBody);

    if (responseJSON.containsKey('artifacts')) {
      List<dynamic> artifacts = responseJSON['artifacts'];
      print(artifacts.length);
      for (int i = 0; i < artifacts.length; i++) {
        var image = artifacts[i];
        String base64String = image['base64'];
        generatedImage = base64Decode(base64String);
      }
      print('Images generated and saved successfully.');
    } else {
      print('No artifacts found in response.${responseJSON['message']}');
    }

    isProcessing = false;
    update();
  }

  */
/*void getDataImage() async {
    isProcessing = true;
    withImage = true;
    update();
    Get.toNamed(RouteHelper.aiImagePreviewPage);
    Uri url=Uri.parse("https://api.stability.ai/v2beta/stable-image/generate/sd3");
    final Http.MultipartRequest request = Http.MultipartRequest('POST', url
    )

      ..fields['strength'] = '0.65'
      ..fields['prompt'] = "Colorful scenery of ${aiPaintController.text} "
      ..fields['model'] = 'sd3-turbo'
      ..fields['mode'] = 'image-to-image'
      ..fields['strength'] = '0.8'
      ..fields['style_preset'] = selectedStyle

      // ..fields['aspect_ratio'] = '16:9'
      ..files.add(await Http.MultipartFile.fromPath(
        'image',
        initImageFile,

      ));

    final response = await ApiClient.postHeaderMultipartData( request, apiKey);
    ////



    if (response.statusCode == 200) {
      final String responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> responseJSON = jsonDecode(responseBody);

      if (responseJSON.containsKey('image')) {
        ResponseModel apiResponse = ResponseModel.fromJson(responseJSON);

          generatedImage = base64Decode(apiResponse.image!);

        print('Image generated and saved successfully.');
      } else {

        print('No image found in response.');
      }
    } else {
      final String responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> responseJSON = jsonDecode(responseBody);
      print('Failed to load image: ${response.statusCode} ${responseJSON["errors"]}');
    }


    isProcessing = false;
    update();
  }*//*


 */
/* void getImageFiltered() async {

    GraffitiCartoonLineController graffitiCartoonLineController=Get.put(GraffitiCartoonLineController());
    String inputPath= graffitiCartoonLineController.selectedPhoto.path;
    graffitiCartoonLineController.isLoading=true;
    update();
    Get.toNamed(RouteHelper.graffitiCartoonLinePreviewPage);
    Uri url=Uri.parse("https://api.stability.ai/v1/generation/stable-diffusion-v1-6/text-to-image");
    final Http.MultipartRequest request = Http.MultipartRequest('POST', url
    )

      ..fields['init_image_mode'] = 'IMAGE_STRENGTH'
      ..fields['image_strength'] = '0.8'
      ..fields['prompt'] = aiPaintController.text
      ..fields['cfg_scale'] = '7'
      ..fields['samples'] = '1'
      ..fields['sampler'] = 'K_DPM_2_ANCESTRAL'
      ..fields['clip_guidance_preset'] = 'FAST_BLUE'
      ..fields['steps'] = '30'
      ..fields['style_preset'] = "3d-model"
      ..files.add(await Http.MultipartFile.fromPath(
        'init_image',
        inputPath,

      ));

    final response = await ApiClient.postHeaderMultipartData1( request, apiKey);
    ////

    final String responseBody = await response.stream.bytesToString();
    final Map<String, dynamic> responseJSON = jsonDecode(responseBody);

    if (responseJSON.containsKey('artifacts')) {
      List<dynamic> artifacts = responseJSON['artifacts'];
      print(artifacts.length);
      for (int i = 0; i < artifacts.length; i++) {
        var image = artifacts[i];
        String base64String = image['base64'];
        print(image['finishReason']);
        graffitiCartoonLineController.previewImage = base64Decode(base64String);
        graffitiCartoonLineController.update();
      }
      print('Images generated and saved successfully.');
    } else {
      print('No artifacts found in response.${responseJSON['message']}');
      print('response ${response.reasonPhrase}');
    }

    graffitiCartoonLineController.isLoading = false;
    update();
  }
*//*


  void getImageFiltered() async {

    GraffitiCartoonLineController graffitiCartoonLineController=Get.put(GraffitiCartoonLineController());
    String inputPath= graffitiCartoonLineController.selectedPhoto.path;
    graffitiCartoonLineController.isLoading=true;
    update();
    Get.toNamed(RouteHelper.graffitiCartoonLinePreviewPage);
    Uri url=Uri.parse("https://api.stability.ai/v1/generation/stable-diffusion-v1-6/image-to-image");
    final Http.MultipartRequest request = Http.MultipartRequest('POST', url
    )

      ..fields['init_image_mode'] = 'IMAGE_STRENGTH'
      ..fields['image_strength'] = '1'
      ..fields['text_prompts[0][text]'] = "crayon drawing of my image"
      ..fields['cfg_scale'] = '7'
      ..fields['samples'] = '1'
      ..fields['sampler'] = 'K_DPM_2_ANCESTRAL'
      ..fields['clip_guidance_preset'] = 'FAST_BLUE'
      ..fields['steps'] = '30'
      ..fields['style_preset'] = selectedStyle
      ..files.add(await Http.MultipartFile.fromPath(
        'init_image',
        inputPath,

      ));

    final response = await ApiClient.postHeaderMultipartData( request, apiKey);
    ////

    final String responseBody = await response.stream.bytesToString();
    final Map<String, dynamic> responseJSON = jsonDecode(responseBody);

    if (responseJSON.containsKey('artifacts')) {
      List<dynamic> artifacts = responseJSON['artifacts'];
      print(artifacts.length);
      for (int i = 0; i < artifacts.length; i++) {
        var image = artifacts[i];
        String base64String = image['base64'];
        graffitiCartoonLineController.previewImage = base64Decode(base64String);
        graffitiCartoonLineController.update();
      }
      print('Images generated and saved successfully.');
    } else {
      print('No artifacts found in response.${responseJSON['message']}');
    }

    graffitiCartoonLineController.isLoading = false;
    update();
  }

  setBase64(Uint8List uint8list) {
    memoryImage = uint8list;
    String img64 = base64.encode(uint8list);
    imageBase64 = "data:image/jpeg;base64,$img64";
    // aiPaintController.text= "road";
    // getDataImage();
    // Get.toNamed(RouteHelper.creativePaintingPage);
    print(img64);
  }
  setInitImageName(String path){
    initImageFile=path;
    Get.toNamed(RouteHelper.creativePaintingPage);
  }
}
*/
