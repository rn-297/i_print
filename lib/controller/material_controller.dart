import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:i_print/api_service/api_service.dart';
import 'package:i_print/api_service/models/category_model.dart';
import 'package:i_print/api_service/models/subcategory_model.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/helper/router.dart';

import '../print_features/sticker_view/sticker_view_controller.dart';

class MaterialController extends GetxController {
  late TabController tabController;
  late TabController nestedTabController;

  List<Categories> categoriesList = [];

  List<ImageList> subCategoriesList = [];

  List labelList = [
    [
      "assets/images/lable_border/label_border1.jpg",
      "assets/svg/icon/satr5.svg",
      "assets/images/lable_border/label3.jpeg",
      "Weather"
    ],
    [
      "assets/images/lable_border/label_border2.jpg",
      "assets/svg/icon/vehicle8.svg",
      "assets/images/lable_border/label4.jpeg",
      "MOTOR CYCLE"
    ],
    [
      "assets/images/lable_border/label_border3.jpg",
      "assets/svg/icon/zodiac2.svg",
      "assets/images/lable_border/label1.jpeg",
      "Zodiac"
    ],
    [
      "assets/images/lable_border/label_border4.jpg",
      "assets/svg/icon/robo2.svg",
      "assets/images/lable_border/label2.jpeg",
      "Robot"
    ]
  ];
  List selectedLabel = [];

  bool isLoading = true;

  Future<void> getCategoryList() async {
    isLoading = true;
    var response = await ApiClient.getData(
        AppConstants.baseUrl + AppConstants.getCategories);

    if (response.statusCode == 200) {
      CategoryClass categoryClass =
          CategoryClass.fromJson(jsonDecode(response.body));
      categoriesList = categoryClass.categories!;
      getSubCategoryImagesList(
          int.parse(categoriesList[0].subCategories![0].subcatId!));
    }

    update();
  }

  Future<void> getSubCategoryImagesList(int id) async {
    isLoading = true;
    final map = <String, dynamic>{};
    map['subcat_id'] = '$id';
    var response = await ApiClient.postData(
        AppConstants.baseUrl + AppConstants.getSubCategoriesImages, map);

    if (response.statusCode == 200) {
      SubCategoryClass subCategoryClass =
          SubCategoryClass.fromJson(jsonDecode(response.body));
      subCategoriesList = subCategoryClass.subCategories![0].imageList!;
    }
    isLoading = false;
    update();
  }

  void setSelectedLabel(int index, BuildContext context) {
    selectedLabel = labelList[index];
    StickerViewController stickerViewController = Get.find();
    stickerViewController.isChangeableHeight = false;
    stickerViewController.stickerViewHeight.value = 150.h;
    stickerViewController.setCurrentPage(AppConstants.label);
    stickerViewController.selectedBorder.value = selectedLabel[2];
    stickerViewController.stickerTextController.text=selectedLabel[3];
    stickerViewController.context=context;
    stickerViewController.labelList = [
      InkWell(
        onTap: () {
          stickerViewController.setIconBottomSheet(context);
          stickerViewController.labelListIndex = 0;
        },
        child: SvgPicture.asset(
          selectedLabel[1],
          height: 100,
          fit: BoxFit.fill,
        ),
      ),
      Expanded(
          child: InkWell(
        onTap: () {
          stickerViewController.labelListIndex = 2;
          stickerViewController.stickerTextController.text=selectedLabel[3];
          stickerViewController.showTextEditBottomSheet(context);
        },
        child: Text(
          selectedLabel[3],
          textAlign: stickerViewController.labelAlign,
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: stickerViewController.labelFontWeight,
            fontStyle: stickerViewController.labelFontStyle,
            decoration: stickerViewController.labelDecoration,
          ),
        ),
      ))
    ];

    Get.toNamed(RouteHelper.labelEditPage);
  }
}
