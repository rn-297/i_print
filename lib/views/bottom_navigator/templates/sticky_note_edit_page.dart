import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../helper/print_color.dart';
import '../../../helper/print_images.dart';
import '../../../print_features/sticker_view/sticker_view.dart';
import '../../../print_features/sticker_view/sticker_view_controller.dart';

class StickyNoteEditPage extends StatelessWidget {
  const StickyNoteEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    StickerViewController stickerViewController =
    Get.put(StickerViewController());
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Sticky Notes"),actions: [
        InkWell(
          onTap: () {
            stickerViewController.selectedAssetId.value = "0";

            stickerViewController.saveAsUint8List(ImageQuality.high);
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
      ],),

      body: const Center(child: StickerView()),
    );
  }
}
