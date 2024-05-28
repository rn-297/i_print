import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/helper/print_decoration.dart';
import 'package:i_print/helper/print_images.dart';
import 'package:i_print/helper/router.dart';
import 'package:i_print/helper/text_styles.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class PrintPage extends StatelessWidget {
  const PrintPage({super.key});

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
                        AppConstants.print,
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
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getRowItems(PrintImages.photo,
                            AppConstants.photoPrinting, PrintColors.mainColor),
                        SizedBox(
                          width: 12.w,
                        ),
                        getRowItems(PrintImages.graphicEdit,
                            AppConstants.graphicEditing, PrintColors.mainColor),
                      ],
                    ),
                    /*SizedBox(
                      height: 24.h,
                    ),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: PrintDecoration.mainDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.aiToolbox,
                            style: PrintTextStyles.subHeaderStyle,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                getAiToolboxItem(
                                    PrintImages.graffiti,
                                    AppConstants.graffitiPractice,
                                    PrintColors.mainColor),
                                SizedBox(
                                  width: 8.w,
                                ),
                                getAiToolboxItem(
                                    PrintImages.cartoonish,
                                    AppConstants.cartoonishPortraits,
                                    PrintColors.mainColor),
                                SizedBox(
                                  width: 8.w,
                                ),
                                getAiToolboxItem(PrintImages.lineArt,
                                    AppConstants.lineArt, PrintColors.mainColor)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                getAiToolboxItem(
                                    PrintImages.variousScene,
                                    AppConstants.variousScenes,
                                    PrintColors.mainColor),
                                SizedBox(
                                  width: 8.w,
                                ),
                                getAiToolboxItem(
                                    PrintImages.aiPainting,
                                    AppConstants.aiPainting,
                                    PrintColors.mainColor),
                                SizedBox(
                                  width: 8.w,
                                ),
                                getAiToolboxItem(
                                    PrintImages.creativePainting,
                                    AppConstants.creativePainting,
                                    PrintColors.mainColor)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),*/
                    SizedBox(
                      height: 24.h,
                    ),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: PrintDecoration.mainDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.toolbox,
                            style: PrintTextStyles.subHeaderStyle,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                getToolboxItem(
                                    PrintImages.textExtraction,
                                    AppConstants.textExtraction,
                                    PrintColors.mainColor),
                                SizedBox(
                                  width: 8.w,
                                ),
                                getToolboxItem(
                                    PrintImages.documentPrint,
                                    AppConstants.documentPrint,
                                    PrintColors.mainColor),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                getToolboxItem(
                                    PrintImages.webPage,
                                    AppConstants.printWebPages,
                                    PrintColors.mainColor),
                                SizedBox(
                                  width: 8.w,
                                ),
                                getToolboxItem(
                                    PrintImages.banner,
                                    AppConstants.bannerPrint,
                                    PrintColors.mainColor),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
          }),
    );
  }

  Expanded getRowItems(String image, String title, Color background) {
    return Expanded(
      child: InkWell(
        onTap: () {
          RouteHelper.goToNextPage(title);
        },
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: PrintDecoration.mainDecoration,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: PrintDecoration.itemDecoration,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  image,
                  height: Get.width / 2 - 30,
                  width: Get.width / 2 - 30,
                ),
                Text(
                  title,
                  style: PrintTextStyles.subHeaderStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded getToolboxItem(String image, String title, Color background) {
    return Expanded(
      child: Container(
        decoration: PrintDecoration.greyTransparentDecoration,
        child: InkWell(
          onTap: () {
            RouteHelper.goToNextPage(title);
          },
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: PrintDecoration.greyTransparentDecoration,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  image,
                  height: Get.width / 4 - 30,
                  width: Get.width / 4 - 30,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  title,
                  style: PrintTextStyles.subHeaderStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded getAiToolboxItem(String image, String title, Color background) {
    return Expanded(
      child: InkWell(
        onTap: () {
          RouteHelper.goToNextPage(title);
        },
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: PrintDecoration.itemDecoration,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: SvgPicture.asset(
                  image,
                  height: Get.width / 3 - 20,
                  width: Get.width / 3 - 20,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: PrintDecoration.transparentDecoration,
                  child: Center(
                    child: Text(
                      title,
                      style: PrintTextStyles.subHeaderStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
