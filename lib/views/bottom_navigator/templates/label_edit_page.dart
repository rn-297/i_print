import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:i_print/print_features/sticker_view/sticker_view.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

import '../../../helper/print_color.dart';
import '../../../helper/print_images.dart';

class LabelEditPage extends StatelessWidget {
  const LabelEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<StickerViewController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Label Editing"),
            actions: [
              InkWell(
                onTap: () {
                  controller.selectedAssetId.value = "0";

                  controller.saveAsUint8List(ImageQuality.medium);
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  margin: EdgeInsets.only(right: 16.w),
                  decoration: BoxDecoration(
                      color: PrintColors.mainColor.withOpacity(.3),
                      borderRadius: BorderRadius.circular(4.r)),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        PrintImages.selectedPrint,
                        height: 25.h,
                        width: 25.h,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      const Text(
                        "Print",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),

                    ],
                  ),
                ),
              )
            ],
          ),
          body:
          controller.isLabelSticker
              ? const StickerView()
              : RepaintBoundary(
            key: controller.stickGlobalKey1,
            child: Container(
              height: 150.h,
              width: Get.size.width,
              padding: EdgeInsets.all(30.h),
              decoration: BoxDecoration(
                  image: DecorationImage(

                    image: NetworkImage(controller.selectedBorder.value),
                    fit: BoxFit.fill,

                  )),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: controller.labelList,
                ),
              ),
            ),
          )
      );
    });
  }
}
