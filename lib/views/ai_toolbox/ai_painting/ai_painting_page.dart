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
    AICreationController aiCreationController=Get.put(AICreationController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Creation by AI"),
      ),
      bottomNavigationBar: Container(
          height: 48.h,
          child: Center(
              child: InkWell(
                onTap: (){
                  aiCreationController.getData();
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
                  disabledBorder: OutlineInputBorder(),
                  hintText: "Enter description and style"),
            ),
          ],
        ),
      ),
    );
  }


}
