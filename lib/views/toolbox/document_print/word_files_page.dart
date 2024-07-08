import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controller/document_controller.dart';
import '../../../helper/print_images.dart';

class WordFilesPage extends StatelessWidget {
  const WordFilesPage({super.key});

  @override
  Widget build(BuildContext context) {

    DocumentController documentController = Get.put(DocumentController());
    return Scaffold(body: Obx(
          () => ListView.builder(
        itemCount: documentController.wordFiles.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 24.h, vertical: 8.h),
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
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
                        documentController.wordFiles[index].endsWith(".pdf")
                            ? PrintImages.pdf
                            : PrintImages.word)),
                Expanded(
                    flex: 3,
                    child: Text(
                        documentController.wordFiles[index].split("/").last)),
              ],
            ),
          );
        },
      ),
    ),);
  }
}
