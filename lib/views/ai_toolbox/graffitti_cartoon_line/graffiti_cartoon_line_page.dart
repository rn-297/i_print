import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/graffiti_cartoon_line_controller.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/views/ai_toolbox/generated_image_preview_page.dart';

import '../../../helper/print_color.dart';

class GraffitiCartoonLinePage extends StatelessWidget {
  const GraffitiCartoonLinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GraffitiCartoonLineController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(controller.currentPage),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(controller.currentPageText),
              Expanded(
                  child: controller.currentPage == AppConstants.lineArt
                      ? Center(child: Text("Select Image"))
                      : Center(child: Text("In Progress"))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      controller.pickImage(context);
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 5.h),
                        decoration: BoxDecoration(
                            color: PrintColors.mainColor,
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Text("Gallery")),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 5.h),
                        decoration: BoxDecoration(
                            color: PrintColors.mainColor,
                            borderRadius: BorderRadius.circular(8.r)),
                        child: Text("Camera")),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
