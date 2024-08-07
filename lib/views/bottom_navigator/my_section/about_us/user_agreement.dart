import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/about_us_controller.dart';

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Agreement"),
      ),
      body: GetBuilder<AboutUsController>(builder: (controller) {
        return Padding(
          padding: EdgeInsets.all(24.w),
          child: ListView.builder(
              itemCount: controller.userAgreement.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.userAgreement[index]["title"] == ""
                        ? Container()
                        : Text(
                            controller.userAgreement[index]["title"]!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                    controller.userAgreement[index]["title"] == ""
                        ? Container()
                        : SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      controller.userAgreement[index]["content"]!,
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                  ],
                );
              }),
        );
      }),
    );
  }
}
