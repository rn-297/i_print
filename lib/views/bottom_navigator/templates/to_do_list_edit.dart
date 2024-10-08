import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/templates_controller.dart';

import '../../../helper/print_color.dart';
import '../../../helper/print_images.dart';

class ToDoListEditPage extends StatelessWidget {
  const ToDoListEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    TemplatesController templatesController = Get.put(TemplatesController());
    return GetBuilder<TemplatesController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit To Do List'),
          actions: [
            InkWell(
              onTap: () {
                controller.getImageFromUI(context);
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                margin: EdgeInsets.only(right: 16.w),
                decoration: BoxDecoration(
                    color: PrintColors.mainColor.withOpacity(.3),
                    borderRadius: BorderRadius.circular(4.r)),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      PrintImages.selectedPrint,
                      height: 25.h,
                      width: 25.h,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    const Text(
                      "Print",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 48.h,
          child: InkWell(
            onTap: () {
              controller.addToDoTextField();
            },
            child: const Column(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  size: 25,
                ),
                Text(
                  "Add Entry",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
            key: controller.toDoListGlobalKey,
            child: Column(
              children: [
                Image.network(
                  controller.selectedToDoList.topImage!,
                ),
                ListView.builder(
                    itemCount: controller.toDoListEditingControllers.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return controller.toDoListEditingControllers.length == 1
                          ? Container(
                              height: 60.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                        controller.selectedToDoList.middleImage!,
                                      ))),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 80.w),
                                child: TextField(
                                  controller: controller
                                      .toDoListEditingControllers[index],
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold),
                                  // onChanged: (val) {
                                  //   controller.toDoListEditingControllers[index]
                                  //       .text = val;
                                  // },
                                ),
                              ))
                          : Container(
                              height: 60.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                        controller.selectedToDoList.middleImage!,
                                      ))),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 80.w),
                                child: Dismissible(
                                  key: Key(controller
                                      .toDoListEditingControllers[index]
                                      .hashCode
                                      .toString()),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    controller.removeToDoTextField(index);
                                  },
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: TextField(
                                    controller: controller.toDoListEditingControllers[index],
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ));
                    }),
                Image.network(
                  controller.selectedToDoList.bottomImage!,
                ),
              ],
            )),
      );
    });
  }
}
