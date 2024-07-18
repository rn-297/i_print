import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/templates_controller.dart';

class ToDoListPage extends StatelessWidget {
  const ToDoListPage({super.key});

  @override
  Widget build(BuildContext context) {

    return GetBuilder<TemplatesController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("To Do List"),
        ),
        body: Column(
          children: [
            GridView.builder(
                shrinkWrap: true,
                itemCount: controller.toDoListImages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        controller.setSelectedToDo(index);
                      },
                      child: Image.network(controller.toDoListImages[index].todoMainImage!));
                })
          ],
        ),
      );
    });
  }
}
