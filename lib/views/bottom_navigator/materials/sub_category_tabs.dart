import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';
import 'package:i_print/views/bottom_navigator/materials/material_controller.dart';

class NestedTabBar extends StatefulWidget {
  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<NestedTabBar>
    with TickerProviderStateMixin {
  MaterialController materialController = Get.put(MaterialController());

  @override
  void initState() {
    super.initState();
    materialController.nestedTabController = new TabController(
        length: materialController
            .nestedTabs[materialController.tabController.index].length,
        vsync: this);
    materialController.nestedTabController.addListener(() {
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
                  .nestedTabs[materialController.tabController.index]
                  .map((tab) => Tab(text: "$tab "))
                  .toList()),
          Expanded(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: TabBarView(
                  controller: materialController.nestedTabController,
                  children: materialController
                      .nestedTabs[materialController.tabController.index]
                      .map((tab) {
                    print(materialController
                        .images[materialController.tabController.index * 3 +
                            materialController.nestedTabController.index]
                        .length);
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (_, index) => InkWell(
                        onTap: () {
                          StickerViewController stickerViewController =
                              Get.put(StickerViewController());
                          stickerViewController.assetImageToUint8List(
                              materialController.images[
                                  materialController.tabController.index * 3 +
                                      materialController
                                          .nestedTabController.index][index]);
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.h),
                          margin: EdgeInsets.all(4.h),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 2)),
                          child: Image.asset(materialController.images[
                              materialController.tabController.index * 3 +
                                  materialController
                                      .nestedTabController.index][index]),
                        ),
                      ),
                      itemCount: materialController
                          .images[materialController.tabController.index * 3 +
                              materialController.nestedTabController.index]
                          .length,
                    );
                  }).toList(),
                )),
          )
        ],
      );
    });
  }
}
