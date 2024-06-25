import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/scan_controller.dart';

import '../sticker_view/sticker_view_controller.dart';

class ScanPrinterPage extends StatefulWidget {
  const ScanPrinterPage({super.key});

  @override
  State<ScanPrinterPage> createState() => _ScanPrinterPageState();
}

class _ScanPrinterPageState extends State<ScanPrinterPage> {
  @override
  Widget build(BuildContext context) {
    Get.put(ScanPrinterController());
    return GetBuilder<ScanPrinterController>(builder: (scanController) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Printers"),
          ),
          body: ListView.builder(
              itemCount: scanController.bluetoothPrinter.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    scanController.selectPrinter(scanController.bluetoothPrinter[index]);
                    // scanController.printImage();
                  },
                  child: Container(
                    padding: EdgeInsets.all(24.h),
                    child: Text(scanController.bluetoothPrinter[index].name!),
                  ),
                );
              }));
    });
  }
}
