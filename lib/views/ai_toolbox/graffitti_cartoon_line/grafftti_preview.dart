/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/graffiti_cartoon_line_controller.dart';

class GraffitiPracticePage extends StatefulWidget {
  const GraffitiPracticePage({super.key});

  @override
  State<GraffitiPracticePage> createState() => _GraffitiPracticePageState();
}

class _GraffitiPracticePageState extends State<GraffitiPracticePage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GetBuilder<GraffitiCartoonLineController>(
      builder: (controller) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.memory(controller.selectedImage1) ,

              ...displayBoxesAroundRecognizedObjects(size,controller),
            ],
          ),
        );
      }
    );
  }


 */
/* List<Widget> displayBoxesAroundRecognizedObjects(Size screen, GraffitiCartoonLineController controller) {
    if (controller.yoloResults.isEmpty) return [];

    double factorX = screen.width / (controller.selectedImageWidth);
    double imgRatio = controller.selectedImageWidth / controller.selectedImageHeight;
    double newWidth = controller.selectedImageWidth * factorX;
    double newHeight = newWidth / imgRatio;
    double factorY = newHeight / (controller.selectedImageHeight);

    double pady = (screen.height - newHeight) / 2;

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);
    return controller.yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY + pady,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
*//*

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen,GraffitiCartoonLineController controller) {
    if (controller.yoloResults.isEmpty) return [];

    double factorX = screen.width / (controller.selectedImageWidth);
    double imgRatio = controller.selectedImageWidth / controller.selectedImageHeight;
    double newWidth = controller.selectedImageWidth * factorX;
    double newHeight = newWidth / imgRatio;
    double factorY = newHeight / (controller.selectedImageHeight);

    double pady = (screen.height - newHeight) / 2;

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);
    return controller.yoloResults.map((result) {
      return Stack(children: [
        Positioned(
          left: result["box"][0] * factorX,
          top: result["box"][1] * factorY + pady,
          width: (result["box"][2] - result["box"][0]) * factorX,
          height: (result["box"][3] - result["box"][1]) * factorY,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(color: Colors.pink, width: 2.0),
            ),
            child: Text(
              "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                background: Paint()..color = colorPick,
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
        ),
        Positioned(
            left: result["box"][0] * factorX,
            top: result["box"][1] * factorY + pady,
            width: (result["box"][2] - result["box"][0]) * factorX,
            height: (result["box"][3] - result["box"][1]) * factorY,
            child: CustomPaint(
              painter: PolygonPainter(
                  points: (result["polygons"] as List<dynamic>).map((e) {
                    Map<String, double> xy = Map<String, double>.from(e);
                    xy['x'] = (xy['x'] as double) * factorX;
                    xy['y'] = (xy['y'] as double) * factorY;
                    return xy;
                  }).toList()),
            )),
      ]);
    }).toList();
  }



}

class PolygonPainter extends CustomPainter {
  final List<Map<String, double>> points;

  PolygonPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(129, 255, 2, 124)
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    final path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points[0]['x']!, points[0]['y']!);
      for (var i = 1; i < points.length; i++) {
        path.lineTo(points[i]['x']!, points[i]['y']!);
      }
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
*/
