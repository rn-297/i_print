import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/api_service/api_service.dart';
import 'package:i_print/api_service/models/category_model.dart';
import 'package:i_print/api_service/models/subcategory_model.dart';
import 'package:i_print/api_service/models/to_do_list_model.dart';
import 'package:i_print/helper/print_constants.dart';

class MaterialController extends GetxController {
  late TabController tabController;
  late TabController nestedTabController;

  List<Categories> categoriesList = [];

  List<ImageList> subCategoriesList = [];
  bool isLoading = true;

  Future<void> getCategoryList() async {
    isLoading=true;
    var response = await ApiClient.getData(
        AppConstants.baseUrl + AppConstants.getCategories);

    if (response.statusCode == 200) {
      CategoryClass categoryClass =
          CategoryClass.fromJson(jsonDecode(response.body));
      categoriesList = categoryClass.categories!;
    }
    getSubCategoryImagesList(
        int.parse(categoriesList[0].subCategories![0].subcatId!));
    update();
  }



  Future<void> getSubCategoryImagesList(int id) async {
    isLoading=true;
    final map = <String, dynamic>{};
    map['subcat_id'] = '$id';
    var response = await ApiClient.postData(
        AppConstants.baseUrl + AppConstants.getSubCategoriesImages, map);

    if (response.statusCode == 200) {
      SubCategoryClass subCategoryClass =
          SubCategoryClass.fromJson(jsonDecode(response.body));
      subCategoriesList = subCategoryClass.subCategories![0].imageList!;
    }
    isLoading=false;
    update();
  }
}
