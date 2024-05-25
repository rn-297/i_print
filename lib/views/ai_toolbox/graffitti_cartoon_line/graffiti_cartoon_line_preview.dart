import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/graffiti_cartoon_line_controller.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

import '../../../helper/print_color.dart';
import '../../../helper/router.dart';

class GraffitiCartoonLinePreviewPage extends StatefulWidget {
  const GraffitiCartoonLinePreviewPage({super.key});

  @override
  State<GraffitiCartoonLinePreviewPage> createState() =>
      _GraffitiCartoonLinePreviewPageState();
}

class _GraffitiCartoonLinePreviewPageState
    extends State<GraffitiCartoonLinePreviewPage> {
  GraffitiCartoonLineController graffitiCartoonLineController =
      Get.put(GraffitiCartoonLineController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (graffitiCartoonLineController.currentPage == AppConstants.lineArt) {
      graffitiCartoonLineController.lineDraw();
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => GraffitiCartoonLineController());

    return GetBuilder<GraffitiCartoonLineController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(controller.currentPage),
        ),
        body: Column(
          children: [
            Expanded(
                child: (controller.currentPage == AppConstants.lineArt ||
                        controller.currentPage ==
                            AppConstants.cartoonishPortraits)
                    ? controller.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : Image.memory(controller.previewImage)
                    : controller.isLoading
                        ? CircularProgressIndicator()
                        : DetectionOverlay(controller.selectedImage1,
                            controller.rectRecognitions)),
            InkWell(
              onTap: () {
                StickerViewController stickerViewController =
                    Get.put(StickerViewController());
                stickerViewController.setCapturedSS(controller.previewImage);
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
            ),
          ],
        ),
      );
    });
  }
}

class DetectionOverlay extends StatelessWidget {
  final Uint8List image;
  final List<dynamic> recognition;

  DetectionOverlay(this.image, this.recognition);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.memory(image),
        CustomPaint(
          painter: RectPainter(recognition),
        ),
      ],
    );
  }
}

class RectPainter extends CustomPainter {
  final List<dynamic> detections;

  RectPainter(this.detections);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (var detection in detections) {
      print(detection["rect"]["x"]);
      final rect = Rect.fromLTWH(
        detection["rect"]["x"] * size.width,
        detection["rect"]["y"] * size.height,
        detection["rect"]["w"] * size.width,
        detection["rect"]["h"] * size.height,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Detection {
  final double x, y, w, h;
  final double confidence;
  final String detectedClass;

  Detection({
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    required this.confidence,
    required this.detectedClass,
  });
}
