import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late WebViewController webController;
  late String base64Data;

  @override
  void initState() {
    super.initState();
    setData();
  }

  void loadDocument() async {
    final url =
        'data:application/vnd.openxmlformats-officedocument.wordprocessingml.document;base64,$base64Data';
    await webController.loadRequest(Uri.parse(url));
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: webController,
      ),
    );
  }

  void setData() {
    StickerViewController stickerViewController =
        Get.put(StickerViewController());
    base64Data = base64.encode(stickerViewController.capturedSS1);
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    loadDocument();
  }
}
