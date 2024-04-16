import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/views/graphic_editing/graphiic_editing.dart';

import '../views/bottom_navigator/bottom_navigator_page.dart';
import '../views/splash_screen/splash_screen.dart';

abstract class RouteHelper {
  static const String initial = '/';

  static const String navigator = '/i_print_navigator';
  static const String graphicEditing = '/i_print_graphic_editing';

  static List<GetPage> route = [
    GetPage(name: initial, page: () => SplashScreen()),
    GetPage(name: navigator, page: () => NavigatorPage()),
    GetPage(name: graphicEditing, page: () => GraphicEditingPage()),
  ];

  static void goToNextPage(String label) {
    switch (label) {
      case AppConstants.myDevice:
        print(label);
        break;
      case AppConstants.printRecord:
        print(label);
        break;
      case AppConstants.aboutUs:
        print(label);
        break;
      case AppConstants.stickyNote:
        print(label);
        break;
      case AppConstants.toDoList:
        print(label);
        break;
      case AppConstants.label:
        print(label);
        break;
      case AppConstants.photoPrinting:
        print(label);
        break;
      case AppConstants.graphicEditing:
        Get.toNamed(graphicEditing);
        print(label);
        break;
      case AppConstants.graffitiPractice:
        print(label);
        break;
      case AppConstants.cartoonishPortraits:
        print(label);
        break;
      case AppConstants.lineArt:
        print(label);
        break;
      case AppConstants.variousScenes:
        print(label);
        break;
      case AppConstants.aiPainting:
        print(label);
        break;
      case AppConstants.creativePainting:
        print(label);
        break;
      case AppConstants.textExtraction:
        print(label);
        break;
      case AppConstants.documentPrint:
        print(label);
        break;
      case AppConstants.printWebPages:
        print(label);
        break;
      case AppConstants.bannerPrint:
        print(label);
        break;
    }
  }
}
