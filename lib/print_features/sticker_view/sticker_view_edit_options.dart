import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/helper/print_constants.dart';

import 'sticker_view_controller.dart';

class StickerViewEditOptions extends StatelessWidget {
  const StickerViewEditOptions({super.key});

  @override
  Widget build(BuildContext context) {
    StickerViewController stickerViewController =
        Get.put(StickerViewController());
    return Container(
      height: 54.h,
      color: PrintColors.mainColor,
      child: ListView.separated(
        itemCount: stickerViewController.getEditOptionCount(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              stickerViewController.setSelectedOption(index);
              stickerViewController.setStickerId();
              onOptionClick(context, stickerViewController);
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    stickerViewController.getItemData(index, "Image"),
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width / 18,
                  ),
                  Text(stickerViewController.getItemData(index, "Text"))
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }

  void onOptionClick(
      BuildContext context, StickerViewController stickerViewController) {
    switch (stickerViewController.getSelectedOption()) {
      case AppConstants.text:
        stickerViewController.stickerTextController.clear();
        stickerViewController.textStickerColor = Colors.black;
        stickerViewController.showTextEditBottomSheet(context);
        break;
      case AppConstants.image:
        stickerViewController.selectImage();
        break;
      case AppConstants.icon:
        stickerViewController.setIconBottomSheet(context);
        break;
      case AppConstants.border:
        stickerViewController.setBorderBottomSheet(context);
        break;
      case AppConstants.qrCode:
        stickerViewController.setQrCodeBottomSheet(context);
        break;
      case AppConstants.graffiti:
        stickerViewController.drawGraffiti();
        break;
    }
  }
}
