import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(414, 782),
      builder: (context,Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'iPrint',
          theme: ThemeData(


            useMaterial3: true,
          ),

          initialRoute: RouteHelper.navigator,
          getPages: RouteHelper.route,

        );
      }
    );
  }
}

