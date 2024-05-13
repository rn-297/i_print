import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/ai_creation_controller.dart';

class AIImagePreviewPage extends StatelessWidget {
  const AIImagePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AICreationController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(title: Text("Image Preview"),),
        body: controller.withImage
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: Image.memory(controller.memoryImage!)),
                  Expanded(
                    flex: 2,
                    child: controller.isProcessing
                        ? Center(child: CircularProgressIndicator())
                        : Image.network(controller.generatedImage),
                  )
                ],
              )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: controller.isProcessing
                        ? Center(child: CircularProgressIndicator())
                        : Image.network(controller.generatedImage),
                  )
                ],
              ),
      );
    });
  }
}
