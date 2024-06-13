import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/templates_controller.dart';

class ToDoListPage extends StatelessWidget {
  const ToDoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TemplatesController());
    return GetBuilder<TemplatesController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text("To Do List"),
        ),
        body: Column(
          children: [
            GridView.builder(
                shrinkWrap: true,
                itemCount: controller.toDoListImages.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  List<String> mainImages = controller.toDoListImages.keys.toList();
                  return InkWell(
                      onTap: () {
                        controller.setSelectedToDo(mainImages[index]);
                      },
                      child: Image.asset(mainImages[index]));
                })
          ],
        ),
      );
    });
  }
}
