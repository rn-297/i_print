import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/material_controller.dart';
import 'package:i_print/controller/scan_controller.dart';
import 'package:i_print/controller/templates_controller.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';
import 'package:i_print/views/bottom_navigator/materials/material_page.dart';
import 'package:i_print/views/bottom_navigator/my_page.dart';
import 'package:i_print/views/bottom_navigator/print_page.dart';
import 'package:i_print/views/bottom_navigator/templates/templates_page.dart';
import 'package:permission_handler/permission_handler.dart';

class BottomNavigationController extends GetxController implements GetxService{
  int selectedIndex=0;
  List<Widget> navigatorPages=<Widget>[PrintPage(),MaterialsPage(),TemplatesPage(),MyPage()];
  getSelectedIndex() {
    return selectedIndex;
  }
  @override
  onInit(){
    super.onInit();

 requestPermission();
    Get.put(TemplatesController());
    Get.put(StickerViewController());
    MaterialController materialController=Get.put( MaterialController());
    materialController.getCategoryList();
    Get.put(ScanPrinterController());
  }

  setSelectedIndex( int index){
    selectedIndex=index;
    update();
  }

  Widget getSelectedPage() {

    return navigatorPages.elementAt(selectedIndex);
  }

  requestPermission()async {
    if(await Permission.storage.isDenied){
      await Permission.storage.request();
    }
    if (await Permission.bluetooth.isDenied) {
      print("here");
      await Permission.bluetooth.request();
    }

    if (await Permission.bluetoothScan.isDenied) {
      print("here1");

      await Permission.bluetoothScan.request();
    }

    if (await Permission.bluetoothConnect.isDenied) {
      print("here2");

      await Permission.bluetoothConnect.request();
    }

    if (await Permission.location.isDenied) {
      print("here3");

      await Permission.location.request();
    }
    Get.put(ScanPrinterController());
    //requestBluetoothPermissions();
    // print(statuses[Permission.storage]);
  }

  Future<void> requestBluetoothPermissions() async {
    if (await Permission.bluetooth.isDenied) {
      print("here");
      await Permission.bluetooth.request();
    }

    if (await Permission.bluetoothScan.isDenied) {
      print("here1");

      await Permission.bluetoothScan.request();
    }

    if (await Permission.bluetoothConnect.isDenied) {
      print("here2");

      await Permission.bluetoothConnect.request();
    }

    if (await Permission.location.isDenied) {
      print("here3");

      await Permission.location.request();
    }
  }

  instanceSegmentation()async{


    

  }


}