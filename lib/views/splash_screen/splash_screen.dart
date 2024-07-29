import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/router.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3),(){
      Get.offNamed(RouteHelper.navigator);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          "assets/images/print_india_logo.png",
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
