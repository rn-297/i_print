import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../helper/print_color.dart';
import '../../helper/print_constants.dart';
import '../../helper/print_decoration.dart';
import '../../helper/print_images.dart';
import '../../helper/text_styles.dart';
import '../common/common_pages.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

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
                  color: PrintColors.mainColor1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.my,
                        style: PrintTextStyles.headerStyle,
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
                    CommonPages.getTemplateItem(AppConstants.myDevice, PrintImages.selectedPrint),
                    SizedBox(height: 8.h,),
                    CommonPages.getTemplateItem(AppConstants.printRecord, PrintImages.record),
                    SizedBox(height: 8.h,),
                    CommonPages.getTemplateItem(AppConstants.aboutUs, PrintImages.aboutUs),
                  ],
                ));
          }),
    );
  }
}
