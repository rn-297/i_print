import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/templates_controller.dart';

class StickyNotePage extends StatelessWidget {
  const StickyNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TemplatesController());
    return GetBuilder<TemplatesController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Sticky Notes"),
          ),
          body: GridView.builder(
              shrinkWrap: true,
              itemCount: controller.stickyNoteImages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                List<String> mainImages = controller.stickyNoteImages.toList();
                return InkWell(
                    onTap: () {
                      controller.setSelectedSticky(mainImages[index]);
                    },
                    child: Image.asset(mainImages[index]));
              }),
        );
      }
    );
  }
}
