import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'adstringo_plugin_platform_interface.dart';

/// An implementation of [AdstringoPluginPlatform] that uses method channels.
class MethodChannelAdstringoPlugin extends AdstringoPluginPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('image_picker_plugin');

  Future<void> deleteImage(String assetId) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      methodChannel.invokeMethod<String>('deleteImage', assetId);
    });
  }

  Future<void> getUniversalPath(String path) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      methodChannel.invokeMethod('getUniversalPath', "path");
    });
  }

  Future<void> getAlbumData(String mediaType) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      methodChannel.invokeMethod('getAlbumData', mediaType);
    });
  }

  Future<void> stopFetchingFromNative() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      methodChannel.invokeMethod('stopFetchingFromNative');
    });
  }

  Future<List<dynamic>> getPdfFile(String timeStamp) async {
    final version = await methodChannel.invokeMethod('getPdfFiles', timeStamp);
    if (version != null && version is List<dynamic>) {
      // Convert the dynamic list to a List<String>
      final List<String> pdfPaths = version.cast<String>();
      return pdfPaths;
    }
    return [];
  }

  Future<void> getVideoData(String timeStamp) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      methodChannel.invokeMethod('getVideoData', timeStamp);
    });
  }

  Future<void> getImageData(String albumId, String timeStamp,int startIndex) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      methodChannel.invokeMethod('getImageData', [albumId, timeStamp,startIndex]);
    });
  }
}
