import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/helper/print_images.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_edit_options.dart';

import '../../print_features/sticker_view/sticker_view.dart';

class GraphicEditingPage extends StatelessWidget {
  const GraphicEditingPage({super.key});

  @override
  Widget build(BuildContext context) {
    StickerViewController stickerViewController =
        Get.put(StickerViewController());
    stickerViewController.stickerViewHeight.value=(Get.size.height*0.4);
    print(stickerViewController.stickerViewHeight);
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppConstants.graphicEditing),
          actions: [
            InkWell(
              onTap: () {
                stickerViewController.selectedAssetId.value = "0";

                stickerViewController.saveAsUint8List(ImageQuality.medium);
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
        bottomNavigationBar: const StickerViewEditOptions(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: SingleChildScrollView(child: StickerView())),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }
}
