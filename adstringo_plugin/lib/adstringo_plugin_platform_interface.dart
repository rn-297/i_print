import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'adstringo_plugin_method_channel.dart';

abstract class AdstringoPluginPlatform extends PlatformInterface {
  /// Constructs a AdstringoPluginPlatform.
  AdstringoPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static AdstringoPluginPlatform _instance = MethodChannelAdstringoPlugin();

  /// The default instance of [AdstringoPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelAdstringoPlugin].
  static AdstringoPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AdstringoPluginPlatform] when
  /// they register themselves.
  static set instance(AdstringoPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
