import 'package:flutter/material.dart';

import '../../../print_features/sticker_view/sticker_view.dart';

class StickyNoteEditPage extends StatelessWidget {
  const StickyNoteEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Sticky Notes"),),
      body: Center(child: StickerView()),
    );
  }
}
