import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'printer_plugin_platform_interface.dart';

/// An implementation of [PrinterPluginPlatform] that uses method channels.
class MethodChannelPrinterPlugin extends PrinterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('printer_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
