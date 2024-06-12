import 'package:flutter_test/flutter_test.dart';
import 'package:adstringo_plugin/adstringo_plugin.dart';
import 'package:adstringo_plugin/adstringo_plugin_platform_interface.dart';
import 'package:adstringo_plugin/adstringo_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAdstringoPluginPlatform
    with MockPlatformInterfaceMixin
    implements AdstringoPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AdstringoPluginPlatform initialPlatform = AdstringoPluginPlatform.instance;

  test('$MethodChannelAdstringoPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAdstringoPlugin>());
  });

  test('getPlatformVersion', () async {
    AdstringoPlugin adstringoPlugin = AdstringoPlugin();
    MockAdstringoPluginPlatform fakePlatform = MockAdstringoPluginPlatform();
    AdstringoPluginPlatform.instance = fakePlatform;

    expect(await adstringoPlugin.getPlatformVersion(), '42');
  });
}
