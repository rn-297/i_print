import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/ai_creation_controller.dart';

import '../../../helper/print_color.dart';

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
                  onTap: (){
                    controller.getDataImage();
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                      decoration: BoxDecoration(
                          color: PrintColors.mainColor,
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Text("Generate Image")),
                ))),
        body: Column(
          children: [
            Expanded(child: Image.memory(controller.memoryImage!)),
            Expanded(
                flex: 2,
                child: Center(
                  child: TextField(
                    controller: controller.aiPaintController,
                    maxLines: 10,
                    decoration: InputDecoration(
                        disabledBorder: OutlineInputBorder(),
                        hintText: "Enter description and style"),
                  ),
                )),
          ],
        ),
      );
    });
  }
}
