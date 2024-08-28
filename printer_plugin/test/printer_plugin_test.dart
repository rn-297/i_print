import 'package:flutter_test/flutter_test.dart';
import 'package:printer_plugin/printer_plugin.dart';
import 'package:printer_plugin/printer_plugin_platform_interface.dart';
import 'package:printer_plugin/printer_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPrinterPluginPlatform
    with MockPlatformInterfaceMixin
    implements PrinterPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final PrinterPluginPlatform initialPlatform = PrinterPluginPlatform.instance;

  test('$MethodChannelPrinterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPrinterPlugin>());
  });

  test('getPlatformVersion', () async {
    PrinterPlugin printerPlugin = PrinterPlugin();
    MockPrinterPluginPlatform fakePlatform = MockPrinterPluginPlatform();
    PrinterPluginPlatform.instance = fakePlatform;

    expect(await printerPlugin.getPlatformVersion(), '42');
  });
}
