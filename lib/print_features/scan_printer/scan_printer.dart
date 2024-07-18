import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/scan_controller.dart';
import 'package:i_print/helper/print_color.dart';


class ScanPrinterPage extends StatefulWidget {
  const ScanPrinterPage({super.key});

  @override
  State<ScanPrinterPage> createState() => _ScanPrinterPageState();
}

class _ScanPrinterPageState extends State<ScanPrinterPage> {
  @override
  Widget build(BuildContext context) {
    ScanPrinterController scanPrinterController =
        Get.put(ScanPrinterController());
    scanPrinterController.scanDevices();

    return GetBuilder<ScanPrinterController>(builder: (scanController) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Printers"),
            actions: [
              InkWell(
                onTap: () {
                  scanController.scanDevices();
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                    decoration: BoxDecoration(
                        color: PrintColors.mainColor1,
                        borderRadius: BorderRadius.circular(4.h)),
                    child: const Text(
                      "Scan",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(
                width: 20.w,
              )
            ],
          ),
          body: scanController.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: scanController.printers.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        scanController
                            .selectPrinter(scanController.printers[index]);
                        // Get.find<ScanPrinterController>(tag: 'scanController')
                        //     .selectPrinter(scanController.devices[index]);
                        // scanController.printImage();
                      },
                      child: Container(
                        padding: EdgeInsets.all(24.h),
                        child: Text(scanController.printers[index].name!),
                      ),
                    );
                  }));
    });
  }
}
