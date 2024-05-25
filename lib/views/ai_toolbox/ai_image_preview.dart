import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/ai_creation_controller.dart';

import '../../helper/print_color.dart';
import '../../helper/router.dart';
import '../../print_features/sticker_view/sticker_view_controller.dart';

class AIImagePreviewPage extends StatelessWidget {
  const AIImagePreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AICreationController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(title: Text("Image Preview"),),

        body: Column(
          children: [
            Expanded(
              child: controller.withImage
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: Image.memory(controller.memoryImage!)),
                        Expanded(
                          flex: 2,
                          child: controller.isProcessing
                              ? Center(child: CircularProgressIndicator())
                              : Image.memory(controller.generatedImage),
                        )
                      ],
                    )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: controller.isProcessing
                              ? Center(child: CircularProgressIndicator())
                              : Image.memory(controller.generatedImage),
                        )
                      ],
                    ),
            ),
            InkWell(
              onTap: () {
                StickerViewController stickerViewController =
                Get.put(StickerViewController());
                stickerViewController.setCapturedSS(controller.generatedImage);
                Get.toNamed(RouteHelper.printPreviewPage);
              },
              child: Container(
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                      color: PrintColors.mainColor,
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Text("Print Preview")),
            )
          ],
        ),
      );
    });
  }
}
