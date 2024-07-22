import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3),(){
      Get.toNamed(RouteHelper.navigator);
    });
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/PRINT_LOGO.png",
        ),
      ),
    );
  }
}
