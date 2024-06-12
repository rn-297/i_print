import 'package:adstringo_plugin/adstringo_plugin_method_channel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DocumentController extends GetxController {
  RxList<PlatformFile> pdfFiles = <PlatformFile>[].obs;
  RxList<String> allFiles = <String>[].obs;
  RxList<PlatformFile> wordFiles = <PlatformFile>[].obs;
  static const platform = MethodChannel('iPrintFilePicker');

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    fetchAllFiles();
    fetchDocFiles();
    fetchPdfFiles();
  }

  Future<void> fetchAllFiles() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: [ 'pdf', 'doc'],
    // );

    try {

      // final List<String> pdfFiles = await platform.invokeMethod('getPdfFiles');
      // // final int platformversion = await platform.invokeMethod('getBatteryLevel');
      // print(pdfFiles);
      // allFiles.value = pdfFiles;

      final _imagePickerPlugin = MethodChannelAdstringoPlugin();


      var data = await _imagePickerPlugin.getPdfFile("");
      print(data);

    } on PlatformException catch (e) {
      print("Failed to get PDF files: '${e.message}'.");
    }
    update();

    // allFiles.value=result!.files;
  }

  Future<void> fetchDocFiles() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: [ 'doc'],
    // );
    // wordFiles.value=result!.files;
  }

  Future<void> fetchPdfFiles() async {
    // FilePickerResult? result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: [ 'pdf', ],
    // );
    // pdfFiles.value=result!.files;
  }
}
