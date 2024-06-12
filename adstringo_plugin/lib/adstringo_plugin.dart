
import 'adstringo_plugin_platform_interface.dart';

class AdstringoPlugin {
  Future<String?> getPlatformVersion() {
    return AdstringoPluginPlatform.instance.getPlatformVersion();
  }
}
