import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_images.dart';
import 'package:i_print/views/common/common_pages.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../../helper/print_color.dart';
import '../../../helper/print_constants.dart';
import '../../../helper/print_decoration.dart';
import '../../../helper/text_styles.dart';

class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: ListView.builder(
          itemCount: 1,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return StickyHeader(
                header: Container(
                  color: PrintColors.mainColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.materials,
                        style: PrintTextStyles.headerStyle,
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        decoration: PrintDecoration.subDecoration,
                        child: Center(
                          child: Text(
                            AppConstants.connecting,
                            style: PrintTextStyles.subHeaderStyle,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                    ],
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonPages.getTemplateItem(AppConstants.stickyNote, PrintImages.notes),
                    SizedBox(height: 8.h,),
                    CommonPages.getTemplateItem(AppConstants.toDoList, PrintImages.toDoList),
                    SizedBox(height: 8.h,),
                    CommonPages.getTemplateItem(AppConstants.label, PrintImages.label),
                  ],
                ));
          }),
    );
  }


}
