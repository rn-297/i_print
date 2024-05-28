import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class DocumentController extends GetxController{
  RxList<PlatformFile> pdfFiles = <PlatformFile>[].obs;
  RxList<PlatformFile> allFiles = <PlatformFile>[].obs;
  RxList<PlatformFile> wordFiles = <PlatformFile>[].obs;

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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [ 'pdf', 'doc'],
    );
    allFiles.value=result!.files;
  }

  Future<void> fetchDocFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [ 'doc'],
    );
    wordFiles.value=result!.files;
  }

  Future<void> fetchPdfFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [ 'pdf', ],
    );
    pdfFiles.value=result!.files;
  }
}