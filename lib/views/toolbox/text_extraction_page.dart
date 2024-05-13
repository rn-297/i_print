import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

class TextExtractionPage extends StatelessWidget {
  const TextExtractionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StickerViewController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(title: Text(AppConstants.textExtraction),),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: controller.extractingText
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(

                          controller: controller.extractedTextController,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: controller.extractedTextFontWeight,
                            fontStyle: controller.extractedTextFontStyle,
                            decoration: controller.extractedTextTextDecoration,
                          ),

                          textAlign: controller.extractedTextTextAlign,
                        ),
                    ),
                  ),
            ),
            SizedBox(
              height: 48,
              child: ListView.separated(
                itemCount: controller.getStyleListCount(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      controller.onExtractedTextStyleItemClick(index);
                    },
                    child: SizedBox(
                        height: 30,
                        width: MediaQuery.of(context).size.width / 6 - 3,
                        child: Container(
                          height: 25.0,
                          width: 25.0,
                          margin: EdgeInsets.all(4.0),
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: controller.getSelectedColor(index)),
                          child: SvgPicture.asset(
                            controller.getStyleListItem(index),
                            color: Colors.black,
                          ),
                        )),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
