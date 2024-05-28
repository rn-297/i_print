import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/document_controller.dart';

class AllFilesPage extends StatelessWidget {
  const AllFilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    DocumentController documentController=Get.find();
    return Scaffold(
      body: Obx(() => ListView.builder(
        itemCount: documentController.allFiles.length,
        itemBuilder: (context,index){
        return (Text(documentController.allFiles[index].name));
      },))
    );
  }
}
