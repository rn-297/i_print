/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:i_print/controller/ai_creation_controller.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api_key.dart';

class ApiKeyController extends GetxController {
  late Box<ApiKeyModel> apiKeyBox;

  TextEditingController stabilityApiKeyController = TextEditingController();

  loadBox() {
    apiKeyBox = Hive.box<ApiKeyModel>('api_key');
  }

  void addOrUpdateApiKey() {
    String id = stabilityApiKeyController.text.trim();
    loadBox();
    final apiKey = ApiKeyModel(id);
    // Check if the id already exists
    final index =
        apiKeyBox.values.toList().indexWhere((element) => element.id == id);
    if (index != -1) {
      // Update the existing apiKey
      apiKeyBox.putAt(index, apiKey);
    } else {
      // Add a new apiKey
      apiKeyBox.add(apiKey);
    }
    stabilityApiKeyController.clear();
    FocusManager.instance.primaryFocus?.unfocus();
    update();
  }

  setApiKey(String apiKey) {
    AICreationController aiCreationController = Get.put(AICreationController());
    print(aiCreationController.currentPage);
    aiCreationController.apiKey = apiKey;
    if (aiCreationController.currentPage == AppConstants.aiPainting) {
      aiCreationController.getData();
    } else if (aiCreationController.currentPage ==
        AppConstants.creativePainting) {
      aiCreationController.getDataImage();
    } else if (aiCreationController.currentPage ==
        AppConstants.cartoonishPortraits) {
      Get.back();
      aiCreationController.getImageFiltered();
    }
  }

  void deleteApiKey(int index) {
    loadBox();
    apiKeyBox.deleteAt(index);
    update();
  }

  List<String> getAllIds() {
    loadBox();
    return apiKeyBox.values.map((apiKey) => apiKey.id).toList();
  }

  Future<void> launchMyUrl() async {
    Uri _url = Uri.parse("https://platform.stability.ai/account/credits");
    try {
      launchUrl(_url);
    } catch (e) {
      print(e);
    }
  }
}
*/
