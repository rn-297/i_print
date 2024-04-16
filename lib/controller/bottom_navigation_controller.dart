import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/views/bottom_navigator/material_page.dart';
import 'package:i_print/views/bottom_navigator/my_page.dart';
import 'package:i_print/views/bottom_navigator/print_page.dart';
import 'package:i_print/views/bottom_navigator/templates_page.dart';

class BottomNavigationController extends GetxController implements GetxService{
  int selectedIndex=0;
  List<Widget> navigatorPages=<Widget>[PrintPage(),MaterialsPage(),TemplatesPage(),MyPage()];
  getSelectedIndex() {
    return selectedIndex;
  }

  setSelectedIndex( int index){
    selectedIndex=index;
    update();
  }

  Widget getSelectedPage() {
    return navigatorPages.elementAt(selectedIndex);
  }



}