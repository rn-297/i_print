import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppConstants.graphicEditing),
          actions: [
            InkWell(
              onTap: () {
                stickerViewController.selectedAssetId.value = "0";

                stickerViewController.saveAsUint8List(ImageQuality.high);
              },
              child: SvgPicture.asset(
                PrintImages.selectedPrint,
                height: 25.h,
                width: 25.h,
              ),
            )
          ],
        ),
        bottomNavigationBar: StickerViewEditOptions(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: SingleChildScrollView(child: StickerView())),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }
}
