import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/router.dart';
import 'package:screenshot/screenshot.dart';

import '../print_features/sticker_view/sticker_view_controller.dart';

class TemplatesController extends GetxController {
  Map<String, List<String>> toDoListImages = {
    'assets/images/to_do_list/img_1.jpg': [
      'assets/images/to_do_list/img_1_1.jpg',
      'assets/images/to_do_list/img_1_2.jpg',
      'assets/images/to_do_list/img_1_3.jpg'
    ],
    'assets/images/to_do_list/img_2.jpg': [
      'assets/images/to_do_list/img_2_1.jpg',
      'assets/images/to_do_list/img_2_2.jpg',
      'assets/images/to_do_list/img_2_3.jpg'
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
  List<String> stickyNoteImages = [
    "assets/images/sticky_note/sticky_note_1.jpg",
    "assets/images/sticky_note/sticky_note_2.jpg",
    "assets/images/sticky_note/sticky_note_3.jpg",
    "assets/images/sticky_note/sticky_note_4.jpg",
  ];

  List<String> selectedToDoList = [];
  List<TextEditingController> toDoListEditingControllers = [];
  String selectedStickyNote = "";
  GlobalKey toDoListGlobalKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  void setSelectedToDo(String selected) {
    print(selected);
    selectedToDoList = toDoListImages[selected]!;
    print(selectedToDoList);
    toDoListEditingControllers.clear();
    addToDoTextField();
    Get.toNamed(RouteHelper.toDoListEditPage);
  }

  void addToDoTextField() {
    TextEditingController temp = TextEditingController();
    toDoListEditingControllers.add(temp);

    update();
  }

  void removeToDoTextField(int index) {
    toDoListEditingControllers[index].dispose();
    toDoListEditingControllers.removeAt(index);
    update();
  }

  Future<void> getImageFromUI(BuildContext context) async {
    update();
    toDoListEditingControllers.map((controller) {
      print("controller.text ${controller.text}");
    });
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

  void setSelectedSticky(String mainImg) {
    selectedStickyNote = mainImg;

    _loadImage();
    Get.toNamed(RouteHelper.stickyNoteEditPage);
  }

  Future<void> _loadImage() async {
    final ByteData data = await rootBundle.load(selectedStickyNote);
    final Uint8List bytes = data.buffer.asUint8List();
    final Image image = Image.memory(bytes);

    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        double _imageWidth = info.image.width.toDouble();
        double _imageHeight = info.image.height.toDouble();
        double aspectRatio = _imageWidth! / _imageHeight!;
        StickerViewController stickerViewController =
            Get.put(StickerViewController());
        stickerViewController.selectedBorder.value=selectedStickyNote;
        stickerViewController.stickers.clear();
        stickerViewController.setTextStickerText("Your Text Here");
        stickerViewController.isChangeableHeight = false;
        stickerViewController.stickerViewHeight.value=Get.size.width/aspectRatio;
      }),
    );
  }
}
