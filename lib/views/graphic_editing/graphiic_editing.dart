import 'package:flutter/material.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_edit_options.dart';

import '../../print_features/sticker_view/sticker_view.dart';

class GraphicEditingPage extends StatelessWidget {
  const GraphicEditingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        bottomNavigationBar: StickerViewEditOptions(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Graphic Editing"),
            StickerView(),
          ],
        ),
      ),
    );
  }
}
