import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_images.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

import '../../../../helper/print_color.dart';

class ImageEditorPage extends StatelessWidget {
  const ImageEditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StickerViewController>(builder: (controller) {
      print(Get.size.width);
      print(controller.memoryImageHeight);
      return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(flex: 3, child: Container()),
              Expanded(
                  child: InkWell(
                      onTap: () {
                        controller.saveImageDrawing();
                      },
                      child: SvgPicture.asset(PrintImages.done))),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: Get.size.width,
                  height: controller.memoryImageHeight,
                  child: DrawingBoard(
                      boardPanEnabled: false,
                      boardScaleEnabled: false,
                      controller: controller.drawingController,
                      panAxis: PanAxis.horizontal,
                      background: Container(
                        width: Get.size.width,
                        height: controller.memoryImageHeight,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: controller.memoryImage.image)),
                      )),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                drawingStroke(controller, 3),
                drawingStroke(controller, 5),
                drawingStroke(controller, 10),
                drawingStroke(controller, 15),
                drawingStroke(controller, 20),
                Expanded(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          controller.drawingController.undo();
                        },
                        child: SvgPicture.asset(PrintImages.undo),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      InkWell(
                        onTap: () {
                          controller.drawingController.redo();
                        },
                        child: SvgPicture.asset(PrintImages.redo),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      );
    });
  }

  drawingStroke(StickerViewController controller, double stroke) {
    print("${controller.drawingWidth} $stroke ${controller.drawingWidth == stroke}");

    return Expanded(
      child: InkWell(
          onTap: () {
            controller.setWidth(stroke);
          },
          child: SizedBox(
            child: Container(
              height: stroke,
              width: stroke,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.drawingWidth == stroke
                      ? Colors.black
                      : PrintColors.grey.withOpacity(0.7)),
            ),
          )),
    );
  }
}
