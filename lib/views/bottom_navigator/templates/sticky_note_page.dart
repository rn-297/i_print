import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/templates_controller.dart';

class StickyNotePage extends StatelessWidget {
  const StickyNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TemplatesController>(builder: (controller) {
      // controller.getStickyNotes();
      return Scaffold(
        appBar: AppBar(
          title: const Text("Sticky Notes"),
        ),
        body: GridView.builder(
            shrinkWrap: true,
            itemCount: controller.stickyNoteImages.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              // List<String> mainImages = !;
              return InkWell(
                  onTap: () {
                    controller.setSelectedSticky(
                        controller.stickyNoteImages[index].stickynoteImage!);
                  },
                  child: Image.network(
                      controller.stickyNoteImages[index].stickynoteImage!));
            }),
      );
    });
  }
}
