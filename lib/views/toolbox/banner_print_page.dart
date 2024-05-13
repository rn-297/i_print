import 'package:flutter/material.dart';

class BannerPrintPage extends StatelessWidget {
  const BannerPrintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Center(child: Text("Banner Print Page"))),
        ],
      ),
    );
  }
}
