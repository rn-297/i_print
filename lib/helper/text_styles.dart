import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:i_print/helper/print_color.dart';

class PrintTextStyles {
  static TextStyle headerStyle = TextStyle(
    color: PrintColors.textColor,
    fontWeight: FontWeight.bold,
    fontSize: 20.sp,
  );
  static TextStyle subHeaderStyle = TextStyle(
    color: PrintColors.textColor,
    fontWeight: FontWeight.normal,
    fontSize: 18.sp,
  );
  static TextStyle labelSelected = TextStyle(color: PrintColors.blue);
  static TextStyle labelUnselected = TextStyle(color: PrintColors.grey);
  static TextStyle templateItemText = TextStyle(fontSize: 20.sp, fontWeight: FontWeight.normal);
}
