import 'package:flutter/material.dart';

class DocumentPrintPage extends StatelessWidget {
  const DocumentPrintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Center(child: Text("Document Print Page"))),
      ],
    ),);
  }
}
