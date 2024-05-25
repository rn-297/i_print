import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/helper/router.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

import '../../helper/print_images.dart';

class TextExtractionPage extends StatelessWidget {
  TextExtractionPage({super.key});

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StickerViewController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppConstants.textExtraction),
          actions: [
            InkWell(
              onTap: () async {
                final boundary = _globalKey.currentContext?.findRenderObject();
                if (boundary is RenderRepaintBoundary) {
                  final uiimage = await boundary.toImage();
                  final pngBytes =
                      await uiimage.toByteData(format: ImageByteFormat.png);

                  if (pngBytes != null) {
                    final Uint8List pngBytes1 = pngBytes.buffer.asUint8List();
                    StickerViewController stickerViewController=Get.put(StickerViewController());
                    stickerViewController.setCapturedSS(pngBytes1);
                    Get.toNamed(RouteHelper.printPreviewPage);
                  }

                }
              },
              child: SvgPicture.asset(
                PrintImages.selectedPrint,
                height: 25.h,
                width: 25.h,
              ),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: controller.extractingText
                  ? Center(child: CircularProgressIndicator())
                  : RepaintBoundary(
                      key: _globalKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              decoration:
                                  InputDecoration(border: InputBorder.none),

                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: controller.extractedTextFontWeight,
                                fontStyle: controller.extractedTextFontStyle,
                                decoration:
                                    controller.extractedTextTextDecoration,
                              ),
                              textAlign: controller.extractedTextTextAlign,
                              controller: controller.extractedTextController),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 48,
              child: ListView.separated(
                itemCount: controller.getStyleListCount(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      controller.onExtractedTextStyleItemClick(index);
                    },
                    child: SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width / 6 - 3,
                        child: Container(
                          height: 25.0,
                          width: 25.0,
                          margin: EdgeInsets.all(4.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.getSelectedColor(index)),
                          child: SvgPicture.asset(
                            controller.getStyleListItem(index),
                            color: Colors.black,
                          ),
                        )),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
