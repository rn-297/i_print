import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/scan_controller.dart';
import 'package:i_print/helper/router.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';
import 'package:i_print/views/toolbox/document_print/pdf_action.dart';

import '../../../controller/document_controller.dart';
import '../../../helper/print_images.dart';

class PdfFilesPage extends StatelessWidget {
  const PdfFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    DocumentController documentController = Get.put(DocumentController());
    return Scaffold(
      body: Obx(
        () => ListView.builder(
          itemCount: documentController.pdfFiles.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                StickerViewController controller =
                    Get.put(StickerViewController());
                controller.capturedSS =
                    await PdfFileAction.convertPdfImagesToUint8List(
                        documentController.pdfFiles[index]);
                ScanPrinterController scanPrinterController =
                    Get.put(ScanPrinterController());
                scanPrinterController.copies = 1.0;
                Get.toNamed(RouteHelper.printPreviewPage);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.h, vertical: 8.h),
                padding: EdgeInsets.all(8.h),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                height: 70.h,
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: SvgPicture.asset(
                            documentController.pdfFiles[index].endsWith(".pdf")
                                ? PrintImages.pdf
                                : PrintImages.word)),
                    Expanded(
                        flex: 3,
                        child: Text(documentController.pdfFiles[index]
                            .split("/")
                            .last)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
