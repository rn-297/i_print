import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/document_controller.dart';
import 'package:i_print/helper/print_images.dart';

class AllFilesPage extends StatelessWidget {
  const AllFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    DocumentController documentController = Get.put(DocumentController());
    return Scaffold(
        body: Obx(
      () => ListView.builder(
        itemCount: documentController.allFiles.length,
        itemBuilder: (context, index) {
          return Container(
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
                        documentController.allFiles[index].endsWith(".pdf")
                            ? PrintImages.pdf
                            : PrintImages.word)),
                Expanded(
                    flex: 4,
                    child: Text(
                        documentController.allFiles[index].split("/").last)),
              ],
            ),
          );
        },
      ),
    ));
  }
}
