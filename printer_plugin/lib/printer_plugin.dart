

import 'package:flutter/services.dart';

import 'printer_plugin_platform_interface.dart';

class PrinterPlugin {
  static const MethodChannel _channel = MethodChannel('printer_plugin');

  Future<String?> getPlatformVersion() {
    return PrinterPluginPlatform.instance.getPlatformVersion();
  }

   Future<void> printPhoto(Uint8List imageData) async {
    try {
      await _channel.invokeMethod('printData', {'imageData': imageData});
    } on PlatformException catch (e) {
      print("Failed to print photo: '${e.message}'.");
    }
  }
}
