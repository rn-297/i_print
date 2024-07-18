import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/scan_controller.dart';
import 'package:i_print/helper/router.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';
import 'package:input_quantity/input_quantity.dart';

import '../../helper/print_color.dart';

class PrintPreviewPage extends StatelessWidget {
  const PrintPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    ScanPrinterController scanPrinterController =
        Get.put(ScanPrinterController());
    return GetBuilder<StickerViewController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Preview"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                    child: SingleChildScrollView(
                        child: Image.memory(

                      controller.capturedSS,
                      fit: BoxFit.fitWidth,
                          width: Get.size.width,
                    )))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text("Quantity to print"),
                    InputQty(
                      maxVal: 10.0,
                      initVal: 1.0,
                      minVal: 1.0,
                      steps: 1.0,
      decoration: const QtyDecorationProps(
      isBordered: false,
      borderShape: BorderShapeBtn.circle,
      width: 12),
                      qtyFormProps: const QtyFormProps(enableTyping: false),
                      onQtyChanged: (val) {
                        print(val);
                        scanPrinterController.copies = val.toDouble();
                      },
                    )
                  ],
                ),
                InkWell(
                  onTap: () async {
                    // await scanPrinterController.getSelectedDeviceState();
                    print(scanPrinterController.isDeviceConnected);
                    if (scanPrinterController.isDeviceConnected) {
                      scanPrinterController.selectPrinter(scanPrinterController.selectedPrinter!);
                    } else {
                      Get.toNamed(RouteHelper.printScanningPage);
                    }
                  },
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                      margin: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                          color: PrintColors.mainColor,
                          borderRadius: BorderRadius.circular(8.r)),
                      child: const Text("Print")),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
