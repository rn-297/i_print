import 'package:flutter/material.dart';

class VariousScenePage extends StatelessWidget {
  const VariousScenePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Center(child: Text("Various scene Page"))),
        ],
      ),
    );
  }
}
