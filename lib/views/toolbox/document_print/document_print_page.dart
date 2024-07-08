import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/document_controller.dart';
import 'package:i_print/views/toolbox/document_print/all_files_page.dart';
import 'package:i_print/views/toolbox/document_print/pdf_files_page.dart';
import 'package:i_print/views/toolbox/document_print/word_files_page.dart';

class DocumentPrintPage extends StatelessWidget {
  const DocumentPrintPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DocumentController documentController =Get.find();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Document Print'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Word'),
              Tab(text: 'Pdf'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AllFilesPage(),
            WordFilesPage(),
            PdfFilesPage(),
          ],
        ),
      ),
    );
  }
}
