import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

class PrintWebPage extends StatelessWidget {
  const PrintWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StickerViewController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Print Web Pages"),
        ),
        bottomNavigationBar: Container(
          height: 48.h,
          color: PrintColors.mainColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  controller.captureCurrentPage();
                },
                child: const Row(
                  children: [Icon(Icons.print), Text("Print Current")],
                ),
              ),
              InkWell(
                onTap: () {
                  controller.captureFullPage(context);
                },
                child: const Row(
                  children: [Icon(Icons.print), Text("Print Full Page")],
                ),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: RepaintBoundary(
                  key: controller.webScreen,
                  child: InAppWebView(
                    initialUrlRequest:
                        URLRequest(url: WebUri('https://www.google.com')),
                    onWebViewCreated: (controller1) {

                      controller.webViewController = controller1;
                    },
                  ),
                )),
          ],
        ),
      );
    });
  }
}
