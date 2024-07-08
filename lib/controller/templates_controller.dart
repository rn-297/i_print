import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/api_service/models/sticky_notes_nodel.dart';
import 'package:i_print/api_service/models/to_do_list_model.dart';
import 'package:i_print/helper/router.dart';
import 'package:screenshot/screenshot.dart';

import '../api_service/api_service.dart';
import '../helper/print_constants.dart';
import '../print_features/sticker_view/sticker_view_controller.dart';
import 'package:http/http.dart' as Http;

class TemplatesController extends GetxController {
  List<TodoList> toDoListImages = [];
  List<StickyNotes> stickyNoteImages = [];

  late TodoList selectedToDoList ;
  List<TextEditingController> toDoListEditingControllers = [];
  String selectedStickyNote = "";
  GlobalKey toDoListGlobalKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  getStickyNotes() async {
    var response = await ApiClient.getData(
        AppConstants.baseUrl + AppConstants.getStickyNotes);

    if (response.statusCode == 200) {
      StickyNotesClass stickyNotesClass =
          StickyNotesClass.fromJson(jsonDecode(response.body));
      stickyNoteImages = stickyNotesClass.stickyNotes!;
    }
    update();
  }

  void setSelectedToDo(int selected) {
    print(selected);
    selectedToDoList = toDoListImages[selected];
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
        Image.network(
          selectedToDoList.topImage!,
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
                  image: NetworkImage(
                    selectedToDoList.middleImage!,
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
        Image.network(
          selectedToDoList.bottomImage!,
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
    Http.Response response = await Http.get(
      Uri.parse(selectedStickyNote),
    );
    Uint8List bytesNetwork = response.bodyBytes;
    final Image image = Image.memory(bytesNetwork);

    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        double _imageWidth = info.image.width.toDouble();
        double _imageHeight = info.image.height.toDouble();
        double aspectRatio = _imageWidth! / _imageHeight!;
        StickerViewController stickerViewController =
            Get.put(StickerViewController());
        stickerViewController.selectedBorder.value = selectedStickyNote;
        stickerViewController.isNetworkImage=true;
        stickerViewController.stickers.clear();
        stickerViewController.setTextStickerText("Your Text Here");
        stickerViewController.isChangeableHeight = false;
        stickerViewController.stickerViewHeight.value =
            Get.size.width / aspectRatio;
      }),
    );
  }

  Future<void> getToDoList() async {
    // isLoading=true;
    var response = await ApiClient.getData(
        AppConstants.baseUrl + AppConstants.getToDoList);

    if (response.statusCode == 200) {
      ToDoListClass toDoListClass =
      ToDoListClass.fromJson(jsonDecode(response.body));
      toDoListImages = toDoListClass.todoList!;
    }
    // getSubCategoryImagesList(
    //     int.parse(categoriesList[0].subCategories![0].subcatId!));
    update();
  }
}
