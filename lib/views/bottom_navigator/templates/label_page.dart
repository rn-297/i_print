import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/material_controller.dart';

class LabelPage extends StatelessWidget {
  const LabelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaterialController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Label Print"),
          ),
          body: Padding(
            padding: EdgeInsets.all(24.h),
            child: ListView.builder(
                itemCount: controller.labelList.length,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      child: InkWell(
                          onTap: (){
                            controller.setSelectedLabel(index,context);
                          },
                          child: Image.asset(controller.labelList[index][0])));
                }),
          ));
    });
  }
}
