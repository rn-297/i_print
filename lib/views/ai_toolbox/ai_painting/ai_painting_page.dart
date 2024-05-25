import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/api_service/api_service.dart';
import 'package:i_print/controller/ai_creation_controller.dart';
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/helper/print_constants.dart';

class AiPaintingPage extends StatelessWidget {
  const AiPaintingPage({super.key});

  @override
  build(BuildContext context) {
    AICreationController aiCreationController = Get.put(AICreationController());

    return GetBuilder<AICreationController>(
      builder: (aiCreationController) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Creation by AI"),
          ),
          bottomNavigationBar: Container(
              height: 48.h,
              child: Center(
                  child: InkWell(
                onTap: () {
                  aiCreationController.getApiKey(context);
                  aiCreationController.currentPage=AppConstants.aiPainting;
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    decoration: BoxDecoration(
                        color: PrintColors.mainColor,
                        borderRadius: BorderRadius.circular(8.r)),
                    child: Text("Generate Image")),
              ))),
          body: Padding(
            padding: EdgeInsets.all(8.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(AppConstants.aiPaintingText),
                  SizedBox(
                    height: 16.h,
                  ),
                  TextField(
                    controller: aiCreationController.aiPaintController,
                    maxLines: 10,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: PrintColors.grey, width: 1),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: PrintColors.grey, width: 1),
                        ),
                        hintText: "Enter description and style"),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      childAspectRatio: 3 / 1,
                      children: List.generate(
                        aiCreationController.stylesList.length,
                        (index) {
                          return InkWell(
                            onTap: (){
                              aiCreationController.selectedStyle=aiCreationController.stylesList[index];
                              aiCreationController.update();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: aiCreationController.stylesList[index] ==
                                          aiCreationController.selectedStyle
                                      ? Colors.blue
                                      : PrintColors.mainColor,
                                  borderRadius: BorderRadius.circular(4.r)),
                              margin: EdgeInsets.all(2),
                              padding: EdgeInsets.all(2),
                              child: Center(
                                child: Text(
                                  aiCreationController.stylesList[index],
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
      }
    );
  }
}
