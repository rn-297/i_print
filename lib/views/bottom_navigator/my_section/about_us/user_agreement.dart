import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/controller/about_us_controller.dart';

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<AboutUsController>(
      builder: (controller) {
        return Text(controller.userAgreement);
      }
    ),);
  }
}
