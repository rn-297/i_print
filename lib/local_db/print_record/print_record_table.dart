import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'print_record_table.g.dart';

@HiveType(typeId: 1)
class PrintRecordModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final List<Uint8List> imageData;
  @HiveField(2)
  final DateTime printTime;
  @HiveField(3)
  final int noOfCopies;

  const PrintRecordModel(
    this.id,
    this.imageData,
    this.printTime,
    this.noOfCopies,
  );
}
