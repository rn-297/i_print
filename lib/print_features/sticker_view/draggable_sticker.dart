import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'draggable_resizable.dart';
import 'sticker_view_controller.dart';

class DraggableStickers extends StatefulWidget {
  const DraggableStickers({super.key});

  @override
  State<DraggableStickers> createState() => _DraggableStickersState();
}



class _DraggableStickersState extends State<DraggableStickers> {
  // initial scale of sticker

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final StickerViewController stickerViewController = Get.put(StickerViewController());

    // Update the sticker view height if the max height changes

    return Obx(() => stickerViewController.stickers.isNotEmpty &&
            stickerViewController.stickers != []
        ? Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  key: const Key('stickersView_background_gestureDetector'),
                  onTap: () {
                    stickerViewController.selectedAssetId.value = "0";
                    setState(() {});
                  },
                ),
              ),
              for (final sticker in stickerViewController.stickers)

                // Main widget that handles all features like rotate, resize, edit, delete, layer update etc.
                DraggableResizable(
                  key:
                      Key('stickerPage_${sticker.id}_draggableResizable_asset'),
                  canTransform: stickerViewController.selectedAssetId == sticker.id ? true : false

                  //  true
                  /*sticker.id == state.selectedAssetId*/,
                  onUpdate: (update) => {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      sticker.position = update.position;
                      sticker.size=update.size;
                      stickerViewController.calculateMaxBottomPosition(sticker);
                    })
                  },
                  isDeletable: stickerViewController.isChangeableHeight,

                  // To update the layer (manage position of widget in stack)
                  onLayerTapped: () {
                    var listLength = stickerViewController.stickers.length;
                    var ind = stickerViewController.stickers.indexOf(sticker);
                    stickerViewController.stickers.remove(sticker);
                    if (ind == listLength - 1) {
                      stickerViewController.stickers.insert(0, sticker);
                    } else {
                      stickerViewController.stickers
                          .insert(listLength - 1, sticker);
                    }

                    stickerViewController.selectedAssetId.value = sticker.id;
                    setState(() {});
                  },

                  // To edit (Not implemented yet)
                  onEdit: () {
                    stickerViewController.editTextSticker(sticker, context);
                  },
                  isText: sticker.isText ?? false,

                  // To Delete the sticker
                  onDelete: () async {
                    {
                      stickerViewController.stickers.remove(sticker);
                      setState(() {});
                    }
                  },

                  // Size of the sticker
                  size:
                      sticker.isText == true ? const Size(200, 100) : const Size(100, 100),

                  // Constraints of the sticker
                  constraints: sticker.isText == true
                      ? BoxConstraints.tight(
                          const Size(200, 100),
                        )
                      : BoxConstraints.tight(
                          Size(
                            64 * stickerViewController.initialStickerScale,
                            64 * stickerViewController.initialStickerScale,
                          ),
                        ),

                  // Child widget in which sticker is passed
                  child: InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      // To update the selected widget
                      stickerViewController.selectedAssetId.value = sticker.id;
                      setState(() {});
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: /*sticker.isText == true
                          ? FittedBox(child: sticker)
                          :*/ sticker,
                    ),
                  ),
                ),
            ],
          )
        : Container());
  }
}
