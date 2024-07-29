import 'package:docx_to_text/docx_to_text.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:get/get.dart';

class AboutUsController extends GetxController {

  String userAgreement="";
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  getData() async {
    userAgreement=await readFilesFromAssets();
    print(userAgreement);
  }

  Future<String> readFilesFromAssets() async {
    ByteData bytes = await rootBundle.load('assets/docs/PRINT INDIA.docx');
    final text = docxToText(bytes.buffer.asUint8List());
    return text;
  }
}
