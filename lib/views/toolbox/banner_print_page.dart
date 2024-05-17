import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

class BannerPrintPage extends StatelessWidget {
  const BannerPrintPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => StickerViewController());
    return GetBuilder<StickerViewController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Banner Print"),
        ),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: InkWell(
                        onTap: () {
                          controller.isHorizontal = true;
                          controller.update();
                        },
                        child: Text("data"))),
                Expanded(child: InkWell(
      onTap: () {
      controller.isHorizontal = false;
      controller.update();
      },
                    child: Text("data1"))),
                Expanded(child: Text("data2")),
                Expanded(child: Text("data3")),
              ],
            ),
            TextField(
              controller: controller.bannerTextController,
              maxLength: 20,
              decoration: InputDecoration(
                hintText: "Please Input Content",
              ),
              onChanged: (va) {
                controller.update();
              },
            ),
            controller.isHorizontal
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      controller.bannerTextController.text,
                      style:
                          TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
                    ),
                  )
                : Expanded(
                    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
      children: controller.bannerTextController.text
          .split('')
          .map((char) {
      return Text(
      char,
      style: TextStyle(
      fontSize: 100, fontWeight: FontWeight.bold),
      );
      }).toList(),
      ),
      ),
      ),
          ],
        ),
      );
    });
  }
}
