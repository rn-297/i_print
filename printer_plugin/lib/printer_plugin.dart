
import 'printer_plugin_platform_interface.dart';

class PrinterPlugin {
  Future<String?> getPlatformVersion() {
    return PrinterPluginPlatform.instance.getPlatformVersion();
  }
}
