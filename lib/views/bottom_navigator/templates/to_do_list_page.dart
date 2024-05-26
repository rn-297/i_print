import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/templates_controller.dart';

class TemplateImagesPage extends StatelessWidget {
  const TemplateImagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TemplatesController>(
      builder: (controller) {
        return Scaffold(
          body: Column(
            children: [
              GridView.builder(
                itemCount:controller.images.length ,
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    List<String> mainImages = controller.images.keys.toList();
                  return Image.asset(mainImages[index]);
                  })
            ],
          ),
        );
      }
    );
  }
}
