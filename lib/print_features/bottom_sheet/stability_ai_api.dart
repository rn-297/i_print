import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/local_db/api_key_controller.dart';

import '../../helper/print_color.dart';

class StabilityAIApi {
  static showAPIKeyBottomSheet(BuildContext context) {
    Get.put(ApiKeyController());
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return LayoutBuilder(builder: (context, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: GetBuilder<ApiKeyController>(builder: (controller) {
                List<String> list = controller.getAllIds();
                return Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      list.isNotEmpty
                          ? Column(
                              children: [
                                Text(
                                  "Choose Key",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp),
                                ),
                                SizedBox(
                                  height: 18.h,
                                ),
                                ListView.builder(
                                    itemCount: list.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    controller
                                                        .setApiKey(list[index]);
                                                  },
                                                  child: Text(
                                                    maskText(list[index]),
                                                    maxLines: 1,
                                                  )),
                                              InkWell(
                                                onTap: () {
                                                  controller
                                                      .deleteApiKey(index);
                                                },
                                                child: Icon(Icons.delete),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          dashedBorder(1500, 1, Colors.grey),
                                        ],
                                      );
                                    }),
                                SizedBox(
                                  height: 18.h,
                                ),
                                dashedBorder(500, 2, Colors.black),
                                SizedBox(
                                  height: 8.h,
                                ),
                              ],
                            )
                          : Container(),

                      TextField(
                        controller: controller.stabilityApiKeyController,
                        maxLines: 1,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrintColors.grey, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: PrintColors.grey, width: 1),
                            ),
                            hintText: "Enter Generated API Key"),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      InkWell(
                          onTap: () {
                            controller.addOrUpdateApiKey();
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                  color: PrintColors.mainColor,
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: Text("Save Key"))),
                      SizedBox(
                        height: 16.h,
                      ),
                      dashedBorder(500, 2, Colors.black),
                      SizedBox(
                        height: 16.h,
                      ),
                      InkWell(
                          onTap: () {
                            controller.launchMyUrl();
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                  color: PrintColors.mainColor,
                                  borderRadius: BorderRadius.circular(8.r)),
                              child: Text("Generate Key"))),
                    ],
                  ),
                );
              }),
            );
          });
        });
  }

  static String maskText(String text) {
    if (text.length <= 8) {
      // If the text is 8 characters or less, display all characters.
      return text;
    } else {
      // Otherwise, display the first 4 characters, followed by 'XXXX', and then the last 4 characters.
      return '${text.substring(0, 6)}********************${text.substring(text.length - 4)}';
    }
  }

  static Widget dashedBorder(int lines, double height, Color color) {
    return Row(
      children: List.generate(
          lines ~/ 10,
          (index) => Expanded(
                child: Container(
                  color: index % 2 == 0 ? Colors.transparent : color,
                  height: height,
                ),
              )),
    );
  }
}
