import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/views/bottom_navigator/materials/sub_category_tabs.dart';

import '../../../controller/material_controller.dart';

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({super.key});

  @override
  _MaterialsPageState createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage>
    with SingleTickerProviderStateMixin {
  MaterialController materialController = Get.put(MaterialController());

  @override
  void initState() {
    super.initState();
    materialController.tabController = TabController(
        length: materialController.categoriesList.length, vsync: this);
    materialController.tabController.addListener(() {
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
  void dispose() {
    super.dispose();
    materialController.tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MaterialController>(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: PrintColors.mainColor1,
          elevation: 0,
          title: const Text('Materials'),
          bottom: TabBar(
            controller: materialController.tabController,
            unselectedLabelColor: Colors.black54,
            tabs: materialController.categoriesList
                .map((tab) => Tab(text: tab.catName))
                .toList(),
          ),
        ),
        body: TabBarView(
          controller: materialController.tabController,
          children: materialController.categoriesList
              .map((tab) => const NestedTabBar())
              .toList(),
        ),
      );
    });
  }
}
