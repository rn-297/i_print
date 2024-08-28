import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'printer_plugin_method_channel.dart';

abstract class PrinterPluginPlatform extends PlatformInterface {
  /// Constructs a PrinterPluginPlatform.
  PrinterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static PrinterPluginPlatform _instance = MethodChannelPrinterPlugin();

  /// The default instance of [PrinterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelPrinterPlugin].
  static PrinterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PrinterPluginPlatform] when
  /// they register themselves.
  static set instance(PrinterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
