import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_print/helper/print_color.dart';

class PrintDecoration {
  static BoxDecoration mainDecoration = BoxDecoration(
    color: PrintColors.background,
    borderRadius: BorderRadius.circular(8.r),
  );
  static BoxDecoration subDecoration = BoxDecoration(
    color: PrintColors.background,
    borderRadius: BorderRadius.circular(4.r),
  );
  static BoxDecoration itemDecoration = BoxDecoration(
    color: PrintColors.mainColor,
    borderRadius: BorderRadius.circular(4.r),
  );
  static BoxDecoration transparentDecoration = BoxDecoration(
    color: PrintColors.background.withOpacity(.5),
    borderRadius: BorderRadius.circular(4.r),
  );
  static BoxDecoration greyTransparentDecoration = BoxDecoration(
    color: PrintColors.grey.withOpacity(.1),
    borderRadius: BorderRadius.circular(4.r),
  );
}
