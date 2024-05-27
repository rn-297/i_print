import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/bottom_navigation_controller.dart';
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/helper/text_styles.dart';

class NavigatorPage extends StatelessWidget {
  const NavigatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BottomNavigationController());

    return GetBuilder<BottomNavigationController>(
        builder: (navigatorController) {
          navigatorController.requestPermission();
      return SafeArea(
        child: Scaffold(
          backgroundColor: PrintColors.mainColor1,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: navigatorController.getSelectedIndex(),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              bottomNavigatorIcon(AppConstants.print, Icons.print),
              bottomNavigatorIcon(AppConstants.materials, Icons.forest),
              bottomNavigatorIcon(AppConstants.templates, Icons.backup_table_rounded),
              bottomNavigatorIcon(AppConstants.my, Icons.person)
            ],
            onTap: (index) {
              navigatorController.setSelectedIndex(index);
            },
          ),
          body: navigatorController.getSelectedPage(),
        ),
      );
    });
  }

  BottomNavigationBarItem bottomNavigatorIcon(String label, IconData iconData) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: Colors.grey,
          ),
          SizedBox(height: 4.h,),
          Text(label,style: PrintTextStyles.labelUnselected,)
        ],
      ),
      label: label,
      activeIcon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: Colors.blue,
          ),
          SizedBox(height: 4.h,),
          Text(label,style: PrintTextStyles.labelSelected,)
        ],
      ),
    );
  }
}
