import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/local_db/print_record/print_record_table.dart';
import 'package:intl/intl.dart';

import '../../../helper/print_decoration.dart';
import '../../../local_db/print_record/print_record_controller.dart';

class PrintRecordPage extends StatelessWidget {
  const PrintRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PrintRecordController());
    return Scaffold(
      backgroundColor: PrintColors.mainColor1,
        appBar: AppBar(
          backgroundColor: PrintColors.mainColor,
          title: Text("Print Record"),
        ),
        body: GetBuilder<PrintRecordController>(builder: (controller) {
          List<PrintRecordModel> printRecords = controller.getAllRecords();
          DateFormat dateFormat = DateFormat('dd-MM-yyyy – hh:mm a');
          return ListView.builder(
              itemCount: printRecords.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(16.h),

                  padding: EdgeInsets.all(8.h),
                  decoration: PrintDecoration.mainDecoration,
                  child: Container(
                    padding: EdgeInsets.all(8.h),
                    decoration: PrintDecoration.itemDecoration,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.memory(
                          printRecords[index].imageData[0],
                          height: 80.h,
                          width: 80.h,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(
                          width: 18.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Time : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    "${dateFormat.format(printRecords[index].printTime)}"),
                              ],
                            ),
                            SizedBox(height: 8.h,),
                            Row(
                              children: [
                                Text(
                                  "Number of Pages : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("${printRecords[index].imageData.length}"),
                              ],
                            ),
                            SizedBox(height: 8.h,),

                            Row(
                              children: [
                                Text(
                                  "Number Of Copies : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text("${printRecords[index].noOfCopies}"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        }));
  }
}
