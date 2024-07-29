import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/router.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [InkWell(
        onTap: (){
          Get.toNamed(RouteHelper.userAgreementPage);
        },
        child: Text("User Agreement"))],),);
  }
}
