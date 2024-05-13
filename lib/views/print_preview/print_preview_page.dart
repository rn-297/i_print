import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

class PrintPreviewPage extends StatelessWidget {
  const PrintPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StickerViewController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: Text("Preview"),),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: Center(child: Image.memory(controller.capturedSS))),
            ],
          ),
        );
      }
    );
  }
}
