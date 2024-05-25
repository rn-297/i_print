import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/router.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

import '../../helper/print_color.dart';

class PrintPreviewPage extends StatelessWidget {
  const PrintPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StickerViewController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Preview"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    child: SingleChildScrollView(child: Image.memory(controller.capturedSS)))),
            InkWell(
              onTap: () {
                Get.toNamed(RouteHelper.printScanningPage);
              },
              child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                      color: PrintColors.mainColor,
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Text("Print")),
            )
          ],
        ),
      );
    });
  }
}
