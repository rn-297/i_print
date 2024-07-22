import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
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
  List<Widget> navigatorPages=<Widget>[const PrintPage(),const MaterialsPage(),const TemplatesPage(),const MyPage()];
  getSelectedIndex() {
    return selectedIndex;
  }
  @override
  onInit(){
    super.onInit();

 requestPermission();
    Get.put(TemplatesController());
    StickerViewController stickerViewController=Get.put(StickerViewController());
    stickerViewController.getIconData();
    stickerViewController.getBorderData();
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
    var storageStatus = await Permission.storage.status;
    // print(storageStatus);
    var cameraStatus = await Permission.camera.status;
    // print(cameraStatus);
    var mediaLibraryStatus = await Permission.mediaLibrary.status;
    // print(mediaLibraryStatus);
    var photosStatus = await Permission.photos.status;
    // print(photosStatus);
    var videoStatus = await Permission.videos.status;
    // print("videoStatus $videoStatus");
    var extStorageStatus = await Permission.manageExternalStorage.status;
    // print("extStorageStatus $extStorageStatus");
    // if (status.isDenied) {
    // You can request multiple permissions at once.
    if (storageStatus != PermissionStatus.granted) {
      storageStatus = await Permission.storage.request();
    }
    if (cameraStatus != PermissionStatus.granted) {
      cameraStatus = await Permission.camera.request();
    }
    if (mediaLibraryStatus != PermissionStatus.granted) {
      mediaLibraryStatus = await Permission.mediaLibrary.request();
    }
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        /// use [Permissions.storage.status]
      } else {
        /// use [Permissions.photos.status]
        if (photosStatus != PermissionStatus.granted) {
          photosStatus = await Permission.photos.request();
        }
        if (videoStatus != PermissionStatus.granted) {
          videoStatus = await Permission.videos.request();
        }
      }
      extStorageStatus = await Permission.manageExternalStorage.request();
    } else {
      /// use [Permissions.photos.status]
      if (photosStatus != PermissionStatus.granted) {
        photosStatus = await Permission.photos.request();
      }
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