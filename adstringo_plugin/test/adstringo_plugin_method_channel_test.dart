import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adstringo_plugin/adstringo_plugin_method_channel.dart';

void main() {
  MethodChannelAdstringoPlugin platform = MethodChannelAdstringoPlugin();
  const MethodChannel channel = MethodChannel('adstringo_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
