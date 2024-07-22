import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:i_print/local_db/print_record/print_record_table.dart';

class PrintRecordController extends GetxController {
  late Box<PrintRecordModel> _printRecordBox;

  loadBox() {
    _printRecordBox = Hive.box<PrintRecordModel>('print_record');
  }

  Future<void> addPrintRecord(PrintRecordModel record) async {
    await _printRecordBox.put(record.id, record);
  }

  Future<int> getNextId() async {
    loadBox();
    final lastKey = _printRecordBox.keys.isEmpty
        ? 0
        : _printRecordBox.keys
            .cast<int>()
            .reduce((curr, next) => curr > next ? curr : next);
    return lastKey + 1;
  }

  Future<void> updatePrintRecord(PrintRecordModel record) async {
    if (_printRecordBox.containsKey(record.id)) {
      await _printRecordBox.put(record.id, record);
    } else {
      print("No Id");
    }
  }

  void deleteApiKey(int index) {
    loadBox();
    _printRecordBox.deleteAt(index);
    update();
  }

  onRecordClick(PrintRecordModel printRecord) {}

  List<PrintRecordModel> getAllRecords() {
    loadBox();
    return _printRecordBox.values.map((printRecord) => printRecord).toList();
  }
}
