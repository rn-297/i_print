import 'dart:typed_data';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_images.dart';
import 'dart:ui' as ui;
import 'draggable_sticker.dart';
import 'sticker_view_controller.dart';

enum ImageQuality { low, medium, high }

class StickerView extends StatefulWidget {
  @override
  StickerViewState createState() => StickerViewState();
}

class StickerViewState extends State<StickerView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StickerViewController stickerViewController = Get.put(StickerViewController());
    return Column(
      children: [
        Obx(() => RepaintBoundary(
              key: stickerViewController.stickGlobalKey,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    image: stickerViewController
                                .selectedBorder.value.isNotEmpty &&
                            stickerViewController.isNetworkImage
                        ? DecorationImage(
                            image: NetworkImage(
                                stickerViewController.selectedBorder.value),
                            fit: BoxFit.fill,
                          )
                        : stickerViewController.selectedBorder.value.isNotEmpty
                            ? DecorationImage(
                                image: AssetImage(
                                    stickerViewController.selectedBorder.value,),fit: BoxFit.fill,)
                            : null),
                height: stickerViewController.stickerViewHeight.value,
                width: MediaQuery.of(context).size.width,
                child: DraggableStickers(),
              ),
            )),
      ],
    );
  }
}

class Sticker extends StatefulWidget {
  final Widget? child;
  final bool? isText;
  final String id;
  Size size;
  Offset position;
  late TextStyle textStyle; // Added textStyle property

  Sticker({
    Key? key,
    this.child,
    this.isText,
    required this.id,
    required this.size,
    required this.position,
    required this.textStyle, // Added textStyle property
  }) : super(key: key);

  @override
  _StickerState createState() => _StickerState();
}

class _StickerState extends State<Sticker> {
  @override
  Widget build(BuildContext context) {
    return widget.child != null ? widget.child! : Container();
  }

  // Method to update text style
  void updateTextStyle(TextStyle newTextStyle) {
    if (widget.isText ?? false) {
      // final DynamicTextStyle? dynamicTextWidget = widget.child as DynamicTextStyle?;
      // dynamicTextWidget?.updateTextStyle(newTextStyle);
      widget.textStyle = newTextStyle;
    }
  }
}
