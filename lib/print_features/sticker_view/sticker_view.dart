import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
import 'draggable_sticker.dart';
import 'sticker_view_controller.dart';

enum ImageQuality { low, medium, high }

class StickerView extends StatefulWidget {


  static Future<Uint8List?> saveAsUint8List(ImageQuality imageQuality) async {
    try {
      Uint8List? pngBytes;
      double pixelRatio = 1;
      if (imageQuality == ImageQuality.high) {
        pixelRatio = 2;
      } else if (imageQuality == ImageQuality.low) {
        pixelRatio = 0.5;
      }
      await Future.delayed(const Duration(milliseconds: 700))
          .then((value) async {
        RenderRepaintBoundary boundary = stickGlobalKey.currentContext
            ?.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        pngBytes = byteData?.buffer.asUint8List();
      });
      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }

  @override
  StickerViewState createState() => StickerViewState();
}

final GlobalKey stickGlobalKey = GlobalKey();

class StickerViewState extends State<StickerView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<StickerViewController>(builder: (stickerViewController) {
      return Column(
        children: [
          RepaintBoundary(
            key: stickGlobalKey,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              height:
              MediaQuery.of(context).size.height * 0.7,
              width:  MediaQuery.of(context).size.width,
              child: DraggableStickers(),
            ),
          ),
        ],
      );
    });
  }
}

class Sticker extends StatefulWidget {
  final Widget? child;
  final bool? isText;
  final String id;
  final Size size;
  late TextStyle textStyle; // Added textStyle property

  Sticker({
    Key? key,
    this.child,
    this.isText,
    required this.id,
    required this.size,
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
