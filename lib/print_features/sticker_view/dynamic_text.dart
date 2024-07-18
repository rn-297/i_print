import 'package:flutter/material.dart';


enum ImageQuality { low, medium, high }

class DynamicTextStyle extends StatefulWidget {
  final String data;
  final TextStyle textStyle;

  const DynamicTextStyle({super.key, 
    required this.data,
    required this.textStyle,
  });

  @override
  _DynamicTextStyleState createState() => _DynamicTextStyleState();

}

class _DynamicTextStyleState extends State<DynamicTextStyle> {
  late TextStyle _currentTextStyle;

  @override
  void initState() {
    super.initState();
    _currentTextStyle = widget.textStyle;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.data,
      style: _currentTextStyle,
    );
  }

  void updateTextStyle(TextStyle newTextStyle) {
    setState(() {
      _currentTextStyle = newTextStyle;
    });
  }
}
