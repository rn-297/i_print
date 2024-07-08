import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/print_features/sticker_view/sticker_view.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

class LabelEditPage extends StatelessWidget {
  const LabelEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Label Editing"),
      ),
      body: GetBuilder<StickerViewController>(builder: (controller) {
        return controller.isLabelSticker
            ? StickerView()
            : RepaintBoundary(
                child: Container(
                  height: 150.h,
                  padding: EdgeInsets.all(30.h),
                  decoration: BoxDecoration(
                      image: DecorationImage(

                    image: AssetImage(controller.selectedBorder.value),
                    fit: BoxFit.fill,

                  )),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: controller.labelList,
                    ),
                  ),
                ),
              );
      }),
    );
  }
}
