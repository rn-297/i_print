import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/router.dart';
import 'package:screenshot/screenshot.dart';

import '../print_features/sticker_view/sticker_view_controller.dart';

class TemplatesController extends GetxController {
  Map<String, List<String>> images = {
    'assets/images/to_do_list/img_1.jpg': [
      'assets/images/to_do_list/img_1_1.jpg',
      'assets/images/to_do_list/img_1_2.jpg',
      'assets/images/to_do_list/img_1_3.jpg'
    ],
    'assets/images/to_do_list/img_2.jpg': [
      'assets/images/to_do_list/img_2_1.jpg',
      'assets/images/to_do_list/img_2_2.jpg'
    ],
    'assets/images/to_do_list/img_3.jpg': [
      'assets/images/to_do_list/img_3_1.jpg',
      'assets/images/to_do_list/img_3_2.jpg',
      'assets/images/to_do_list/img_3_3.jpg'
    ],
    'assets/images/to_do_list/img_4.jpg': [
      'assets/images/to_do_list/img_4_1.jpg',
      'assets/images/to_do_list/img_4_2.jpg',
      'assets/images/to_do_list/img_4_3.jpg'
    ],
    'assets/images/to_do_list/img_5.jpg': [
      'assets/images/to_do_list/img_5_1.jpg',
      'assets/images/to_do_list/img_5_2.jpg',
      'assets/images/to_do_list/img_5_3.jpg'
    ],
  };

  List<String> selectedToDoList = [];
  List<TextEditingController> toDoListEditingControllers = [
    TextEditingController()
  ];
  GlobalKey toDoListGlobalKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  void setSelectedToDo(String selected) {
    selectedToDoList = images[selected]!;
    toDoListEditingControllers = [TextEditingController()];
    Get.toNamed(RouteHelper.toDoListEditPage);
  }

  void addToDoTextField() {
    toDoListEditingControllers.add(TextEditingController());
    update();
  }

  void removeToDoTextField(int index) {
    toDoListEditingControllers[index].dispose();
    toDoListEditingControllers.removeAt(index);
    update();
  }

  Future<void> getImageFromUI(BuildContext context) async {
    Widget retrievedWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          selectedToDoList[0],
          fit: BoxFit.cover,
        ),
        Column(
          children: toDoListEditingControllers.map((controller) {

            return Container(
              height: 60.h,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(
                    selectedToDoList[1],
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 80.w),
                child: Localizations(
                  locale: const Locale('en', 'US'),
                  delegates: const <LocalizationsDelegate<dynamic>>[
                    DefaultWidgetsLocalizations.delegate,
                    DefaultMaterialLocalizations.delegate,
                  ],
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Colors.transparent,
                      ),
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        Image.asset(
          selectedToDoList[2],
        ),
      ],
    );
    final FlutterView? view = View.maybeOf(context);
    final Size? viewSize =
        view == null ? null : view.physicalSize / view.devicePixelRatio;
    final Size? targetSizeVertical =
        viewSize == null ? null : Size(viewSize.width, 99999);
    screenshotController
        .captureFromWidget(
            targetSize: targetSizeVertical,
            retrievedWidget, // Pass your widget
            context: context)
        .then((capturedImage) {
      // Here you will get the image object
      final StickerViewController stickerViewController =
          Get.put(StickerViewController());
      stickerViewController.setCapturedSS(capturedImage);
      Get.toNamed(RouteHelper.printPreviewPage);
    });
  }
}
