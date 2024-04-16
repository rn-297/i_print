import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'sticker_view_controller.dart';

class StickerViewEditOptions extends StatelessWidget {
  const StickerViewEditOptions({super.key});

  @override
  Widget build(BuildContext context) {
    StickerViewController stickerViewController =
        Get.put(new StickerViewController());
    return SizedBox(
      height: 48,
      child: ListView.separated(
        itemCount: stickerViewController.getEditOptionCount(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              stickerViewController.setSelectedOption(index);
              stickerViewController.setStickerId();
              onOptionClick(context,stickerViewController);
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
          return Divider();
        },
      ),
    );
  }

  void onOptionClick(BuildContext context,StickerViewController stickerViewController) {
    stickerViewController.showTextEditBottomSheet(context);
  }
}
