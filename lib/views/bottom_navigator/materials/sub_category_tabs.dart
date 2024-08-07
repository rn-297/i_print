import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';
import 'package:i_print/controller/material_controller.dart';

class NestedTabBar extends StatefulWidget {
  const NestedTabBar({super.key});

  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  MaterialController materialController = Get.put(MaterialController());

  @override
  void initState() {
    super.initState();
    materialController.nestedTabController = TabController(
        length: materialController
            .categoriesList[materialController.tabController.index]
            .subCategories!
            .length,
        vsync: this);
    materialController.nestedTabController.addListener(() {
      print("here");
      int id = int.parse(materialController
          .categoriesList[materialController.tabController.index]
          .subCategories![materialController.nestedTabController.index]
          .subcatId!);
      materialController.getSubCategoryImagesList(id);
      materialController.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return GetBuilder<MaterialController>(builder: (materialController) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          TabBar(
              controller: materialController.nestedTabController,
              unselectedLabelColor: Colors.black54,
              isScrollable: true,
              tabs: materialController
                  .categoriesList[materialController.tabController.index]
                  .subCategories!
                  .map((tab) => Tab(text: "${tab.subcatName} "))
                  .toList()),
          Expanded(
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: TabBarView(
                  controller: materialController.nestedTabController,
                  children: materialController
                      .categoriesList[materialController.tabController.index]
                      .subCategories!
                      .map((tab) {
                    return  GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (_, index) => InkWell(
                              onTap: () {
                                StickerViewController stickerViewController =
                                    Get.put(StickerViewController());
                                stickerViewController.networkImageToUint8List(
                                    materialController.subCategoriesList[index]
                                        .subcatImgUrl!);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.h),
                                margin: EdgeInsets.all(4.h),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 2)),
                                child: Image.network(materialController
                                    .subCategoriesList[index].subcatImgUrl!),
                              ),
                            ),
                            itemCount:
                                materialController.subCategoriesList.length,
                          );
                  }).toList(),
                )),
          )
        ],
      );
    });
  }
}
