import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/helper/print_images.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

class DrawingPage extends StatelessWidget {
  const DrawingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StickerViewController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            title: Text(controller.currentPage == AppConstants.creativePainting
                ? AppConstants.creativePainting
                : "Graffiti"),
          ),
          body: Column(
            children: [
              Expanded(
                child: DrawingBoard(
                    boardPanEnabled: false,
                    boardScaleEnabled: false,
                    controller: controller.drawingController,
                    background: Container(
                      height: 800.h,
                      width: 400.w,
                      color: PrintColors.background,
                    )),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () {
                            controller.setDrawingColor(Colors.black);
                          },
                          child: SizedBox(
                              height: 30,
                              child: SvgPicture.asset(PrintImages.draw))),
                      InkWell(
                          onTap: () {
                            controller.setDrawingColor(Colors.white);
                          },
                          child: SizedBox(
                              height: 30,
                              child: SvgPicture.asset(PrintImages.eraser))),
                      InkWell(
                          onTap: () {
                            controller.undoDrawing();
                          },
                          child: SizedBox(
                              height: 30,
                              child: SvgPicture.asset(PrintImages.undo))),
                      InkWell(
                          onTap: () {
                            controller.redoDrawing();
                          },
                          child: SizedBox(
                              height: 30,
                              child: SvgPicture.asset(PrintImages.redo))),
                      InkWell(
                          onTap: () {
                            controller.saveDrawing();
                          },
                          child: SizedBox(
                              height: 30,
                              child: SvgPicture.asset(PrintImages.done))),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      drawingStroke(controller, 3),
                      drawingStroke(controller, 5),
                      drawingStroke(controller, 10),
                      drawingStroke(controller, 15),
                      drawingStroke(controller, 20),
                    ],
                  ),
                ],
              )
            ],
          ));
    });
  }

  drawingStroke(StickerViewController controller, double stroke) {
    return Expanded(
      child: InkWell(
          onTap: () {
            controller.setWidth(stroke);
          },
          child: Container(
            height: stroke,
            width: stroke,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: controller.drawingWidth == stroke
                    ? Colors.black
                    : PrintColors.grey.withOpacity(0.7)),
          )),
    );
  }
}
