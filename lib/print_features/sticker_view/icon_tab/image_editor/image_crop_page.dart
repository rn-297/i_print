import 'dart:ui' as ui;

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/helper/print_images.dart';
import 'package:i_print/helper/router.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

class ImageCropPage extends StatelessWidget {
  const ImageCropPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop"),
      ),
      body: GetBuilder<StickerViewController>(builder: (stickerViewController) {
        return Column(
          children: [
            Expanded(
                child: CropImage(
              gridColor: PrintColors.mainColor,
              controller: stickerViewController.cropController,
              image: Image.file(
                stickerViewController.image,
              ),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                      onTap: () {
                        stickerViewController.memoryImage = Image.memory(
                            stickerViewController.image.readAsBytesSync());
                        stickerViewController.drawingController
                            .setStyle(color: Colors.white, strokeWidth: 3);
                        stickerViewController.setDrawingColor(Colors.white);
                        stickerViewController.drawingController.clear();
                        stickerViewController.memoryImage.image
                            .resolve(const ImageConfiguration())
                            .addListener(
                          ImageStreamListener((ImageInfo info, bool _) async {
                            int width = info.image.width;
                            int height = info.image.height;
                            double aspectRatio = width / height;
                            print("Width: $width, Height: $height");
                            // stickerViewController.memoryImageWidth = double.parse("$width");
                            stickerViewController.memoryImageHeight =
                                Get.size.width / aspectRatio;
                            stickerViewController.update();
                            stickerViewController.drawingController
                                .setBoardSize(Size(Get.size.width,
                                    stickerViewController.memoryImageHeight));

                            Get.offNamed(RouteHelper.imageEditor);
                            print("here");
                            stickerViewController.update();
                          }),
                        );
                      },
                      child: SvgPicture.asset(PrintImages.eraser)),
                  InkWell(
                      onTap: () async {
                        stickerViewController.cropController.crop;
                        ui.Image bitmap = await stickerViewController
                            .cropController
                            .croppedBitmap(quality: FilterQuality.low);
                        stickerViewController.saveBitmap(bitmap);

                      },
                      child: stickerViewController.photoPrint
                          ? const Icon(Icons.print,size: 30,)
                          : SvgPicture.asset(PrintImages.done1)),
                  InkWell(
                      onTap: () {
                        stickerViewController.cropController.rotateRight();
                      },
                      child: SvgPicture.asset(PrintImages.rotate)),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
