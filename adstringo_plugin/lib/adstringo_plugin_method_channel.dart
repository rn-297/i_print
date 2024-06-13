import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'adstringo_plugin_platform_interface.dart';

/// An implementation of [AdstringoPluginPlatform] that uses method channels.
class MethodChannelAdstringoPlugin extends AdstringoPluginPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('image_picker_plugin');


  Future<List<String>> getAllFile() async {
    final version = await methodChannel.invokeMethod('getFiles', {"type":"All"});
    if (version != null && version is List<dynamic>) {
      // Convert the dynamic list to a List<String>
      final List<String> pdfPaths = version.cast<String>();
      return pdfPaths;
    }
    return [];
  }
  Future<List<String>> getPdfFile() async {
    final version = await methodChannel.invokeMethod('getFiles', {"type":"pdf"});
    if (version != null && version is List<dynamic>) {
      // Convert the dynamic list to a List<String>
      final List<String> pdfPaths = version.cast<String>();
      return pdfPaths;
    }
    return [];
  }
  Future<List<String>> getWordFile() async {
    final version = await methodChannel.invokeMethod('getFiles', {"type":"word"});
    if (version != null && version is List<dynamic>) {
      // Convert the dynamic list to a List<String>
      final List<String> pdfPaths = version.cast<String>();
      return pdfPaths;
    }
    return [];
  }


}
