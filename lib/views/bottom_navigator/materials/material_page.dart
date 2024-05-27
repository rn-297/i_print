import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/views/bottom_navigator/materials/sub_category_tabs.dart';

import 'material_controller.dart';

class MaterialsPage extends StatefulWidget {
  @override
  _MaterialsPageState createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage>
    with SingleTickerProviderStateMixin {
  MaterialController materialController = Get.put(MaterialController());

  @override
  void initState() {
    super.initState();
    materialController.tabController = new TabController(
        length: materialController.outerTabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    materialController.tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:PrintColors.mainColor1,
        elevation: 0,
        title: Text('Materials'),
        bottom: TabBar(
          controller: materialController.tabController,

          unselectedLabelColor: Colors.black54,
          tabs: materialController.outerTabs
              .map((tab) => Tab(text: tab))
              .toList(),
        ),
      ),
      body: TabBarView(
        children:
            materialController.outerTabs.map((tab) => NestedTabBar()).toList(),
        controller: materialController.tabController,
      ),
    );
  }
}
