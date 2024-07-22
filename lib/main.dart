import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:i_print/controller/bottom_navigation_controller.dart';
import 'package:i_print/controller/material_controller.dart';
import 'package:i_print/controller/scan_controller.dart';
import 'package:i_print/helper/router.dart';
import 'package:i_print/local_db/api_key/api_key.dart';
import 'package:i_print/local_db/print_record/print_record_table.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';

import 'controller/document_controller.dart';
import 'controller/templates_controller.dart';
import 'local_db/print_record/print_record_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ApiKeyModelAdapter());
  Hive.openBox<ApiKeyModel>('api_key');
  Hive.registerAdapter(PrintRecordModelAdapter());
  Hive.openBox<PrintRecordModel>('print_record');

  runApp(const MyApp());
}

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StickerViewController());
    Get.lazyPut(() => ScanPrinterController());
    Get.lazyPut(() => BottomNavigationController());
    Get.lazyPut(() => TemplatesController());
    Get.lazyPut(() => DocumentController());
    Get.lazyPut(() => MaterialController());
    Get.lazyPut(() => PrintRecordController());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(414, 782),
        builder: (context, Widget? child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'PRINT INDIA',
            theme: ThemeData(
              useMaterial3: true,
            ),
            initialRoute: RouteHelper.splash,
            getPages: RouteHelper.route,
            initialBinding: AppBindings(),
          );
        });
  }
}
