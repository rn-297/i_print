import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

import '../../helper/print_images.dart';

class BannerPrintPage extends StatelessWidget {
  const BannerPrintPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => StickerViewController());
    return GetBuilder<StickerViewController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Banner Print"),
          actions: [
            InkWell(
              onTap: () async {
                controller.bannerSaveImage(context);
              },
              child: SvgPicture.asset(
                PrintImages.selectedPrint,
                height: 25.h,
                width: 25.h,
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            controller.isHorizontal = true;
                            controller.update();
                          },
                          child: Image.asset(
                            "assets/images/text_horizonatl.png",
                            height: 20.h,
                          ))),
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            controller.isHorizontal = false;
                            controller.update();
                          },
                          child: Image.asset(
                            "assets/images/text_vertical.png",
                            height: 20.h,
                          ))),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      controller.setBannerTextSize(10);
                    },
                    child: Center(
                      child: Text(
                        "T+",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.sp),
                      ),
                    ),
                  )),
                  Expanded(
                      child: InkWell(
                    onTap: () {
                      controller.setBannerTextSize(-10);
                    },
                    child: Center(
                      child: Text(
                        "T-",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.sp),
                      ),
                    ),
                  )),
                ],
              ),
              TextField(
                controller: controller.bannerTextController,
                maxLength: 20,
                decoration: InputDecoration(
                  hintText: "Please Input Content",
                ),
                onChanged: (va) {
                  controller.update();
                },
              ),
              controller.isHorizontal
                  ? Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: PrintColors.background.withOpacity(.5)),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        controller.bannerTextController.text,
                        style: TextStyle(
                            fontSize: controller.horizontalTextSize,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  )
                  : Expanded(
                      child: Center(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: PrintColors.background.withOpacity(.5)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: controller.bannerTextController.text
                                  .split('')
                                  .map((char) {
                                return Text(
                                  char,
                                  style: TextStyle(
                                      fontSize: controller.verticalTextSize,
                                      fontWeight: FontWeight.bold),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
    });
  }
}
