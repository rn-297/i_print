import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/router.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About Us"),),
      body: Padding(
        padding:  EdgeInsets.all(12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("App Version"),
                Text(" 1.0.0"),
              ],
            ),),
            Divider(height: 30.h,),
            InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.userAgreementPage);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("User Agreement"),

                    Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 20,)
                  ],
                )),
            Divider(height: 30.h,),
            InkWell(
                onTap: () {
                  Get.toNamed(RouteHelper.privacyPolicyPage);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Privacy Policy"),
                    Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey,size: 20,)
                  ],
                )),
            Divider(height: 30.h,),
          ],
        ),
      ),
    );
  }
}
