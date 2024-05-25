import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/ai_creation_controller.dart';

import '../../../helper/print_color.dart';
import '../../../helper/print_constants.dart';

class CreativePaintingPage extends StatelessWidget {
  const CreativePaintingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AICreationController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Creative Painting"),
        ),
        bottomNavigationBar: Container(
            height: 48.h,
            child: Center(
                child: InkWell(
              onTap: () {
                controller.getApiKey(context);

                controller.currentPage=AppConstants.creativePainting;
              },
              child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                  decoration: BoxDecoration(
                      color: PrintColors.mainColor,
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Text("Generate Image")),
            ))),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.memory(controller.memoryImage!,height: 150,width: 150,),
                Center(
                  child: TextField(
                    controller: controller.aiPaintController,
                    maxLines: 8,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: PrintColors.grey, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: PrintColors.grey, width: 1),
                        ),
                        hintText: "Enter description and style"),
                  ),
                ),
                SizedBox(height: 8.h,),
                Text("Style",textAlign: TextAlign.start,),
                SizedBox(height: 8.h,),
                GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    childAspectRatio: 3 / 1,
                    children: List.generate(
                      controller.stylesList.length,
                      (index) {
                        return InkWell(
                          onTap: () {
                            controller.selectedStyle =
                                controller.stylesList[index];
                            controller.update();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: controller.stylesList[index] ==
                                        controller.selectedStyle
                                    ? Colors.blue
                                    : PrintColors.mainColor,
                                borderRadius: BorderRadius.circular(4.r)),
                            margin: EdgeInsets.all(2),
                            padding: EdgeInsets.all(2),
                            child: Center(
                              child: Text(
                                controller.stylesList[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    ))
              ],
            ),
          ),
        ),
      );
    });
  }
}
