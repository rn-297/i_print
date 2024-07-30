import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/about_us_controller.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: GetBuilder<AboutUsController>(builder: (controller) {
        return Padding(
          padding: EdgeInsets.all(24.w),
          child: ListView.builder(
              itemCount: controller.privacyPolicy.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.privacyPolicy[index]["title"] == ""
                        ? Container()
                        : Text(
                      controller.privacyPolicy[index]["title"]!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    controller.privacyPolicy[index]["title"] == ""
                        ? Container()
                        : SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      controller.privacyPolicy[index]["content"]!,
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
