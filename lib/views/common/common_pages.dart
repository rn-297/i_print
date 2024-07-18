import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/router.dart';

import '../../helper/print_decoration.dart';

class CommonPages {
  static Widget getTemplateItem(String label, String image) {
    return Container(
      padding: EdgeInsets.all(8.h),
      decoration: PrintDecoration.mainDecoration,
      child: InkWell(
        onTap: () {
          RouteHelper.goToNextPage(label);
        },
        child: Container(
          decoration: PrintDecoration.itemDecoration,
          padding: EdgeInsets.all(16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 3,
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.normal))),
              Expanded(
                  child: SvgPicture.asset(
                image,
                height: Get.width / 4 - 20,
                width: Get.width / 4 - 20,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
