import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:i_print/controller/graffiti_cartoon_line_controller.dart';
import 'package:i_print/controller/scan_controller.dart';
import 'package:i_print/controller/templates_controller.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/print_features/scan_printer/scan_printer.dart';
import 'package:i_print/print_features/sticker_view/icon_tab/drawing_board/drawing_board.dart';
import 'package:i_print/print_features/sticker_view/icon_tab/image_editor/ImageEditorPage.dart';
import 'package:i_print/print_features/sticker_view/icon_tab/image_editor/image_crop_page.dart';
import 'package:i_print/print_features/sticker_view/sticker_view_controller.dart';
import 'package:i_print/views/ai_toolbox/ai_image_preview.dart';
import 'package:i_print/views/ai_toolbox/ai_painting/ai_painting_page.dart';
import 'package:i_print/views/ai_toolbox/creative_painting/creative_painting_page.dart';
import 'package:i_print/views/ai_toolbox/graffitti_cartoon_line/graffiti_cartoon_line_page.dart';
import 'package:i_print/views/ai_toolbox/graffitti_cartoon_line/graffiti_cartoon_line_preview.dart';
import 'package:i_print/views/ai_toolbox/graffitti_cartoon_line/grafftti_preview.dart';
import 'package:i_print/views/ai_toolbox/line_drawing_page.dart';
import 'package:i_print/views/ai_toolbox/various_page/various_page.dart';
import 'package:i_print/views/bottom_navigator/templates/label_edit_page.dart';
import 'package:i_print/views/bottom_navigator/templates/label_page.dart';
import 'package:i_print/views/bottom_navigator/templates/sticky_note_edit_page.dart';
import 'package:i_print/views/bottom_navigator/templates/sticky_note_page.dart';
import 'package:i_print/views/bottom_navigator/templates/to_do_list_edit.dart';
import 'package:i_print/views/bottom_navigator/templates/to_do_list_page.dart';
import 'package:i_print/views/graphic_editing/graphiic_editing.dart';
import 'package:i_print/views/print_preview/print_preview_page.dart';
import 'package:i_print/views/toolbox/banner_print_page.dart';
import 'package:i_print/views/toolbox/document_print/document_print_page.dart';
import 'package:i_print/views/toolbox/print_web_page.dart';
import 'package:i_print/views/toolbox/text_extraction_page.dart';

import '../views/bottom_navigator/bottom_navigator_page.dart';
import '../views/splash_screen/splash_screen.dart';

abstract class RouteHelper {
  static const String initial = '/';

  static const String navigator = '/i_print_navigator';
  static const String graphicEditing = '/i_print_graphic_editing';
  static const String drawingBoard = '/i_print_drawing_board';
  static const String imageCropper = '/i_print_image_cropper';
  static const String imageEditor = '/i_print_image_editor';
  static const String printPreviewPage = '/i_print_print_preview';
  static const String graffitiCartoonLinePage =
      '/i_print_graffiti_cartoon_line';
  static const String variousScenePage = '/i_print_various_scene';
  static const String aiPaintingPage = '/i_print_ai_painting';
  static const String creativePaintingPage = '/i_print_creative_painting';
  static const String textExtractionPage = '/i_print_text_extraction';
  static const String documentPrintPage = '/i_print_document_print';
  static const String printWebPagesPage = '/i_print_print_web_pages';
  static const String bannerPrintPage = '/i_print_banner_print';
  static const String aiImagePreviewPage = '/i_print_image_preview';
  static const String graffitiCartoonLinePreviewPage =
      '/i_print_graffiti_cartoon_line_preview';
  static const String lineDrawing = '/i_print_line_drawing';
  static const String printScanningPage = '/i_print_print_scanning';
  static const String graffitiPreviewPage = '/i_print_graffiti_preview';
  static const String stickyNotePage = '/i_print_sticky_note';
  static const String toDoListPage = '/i_print_to_do_list';
  static const String labelPage = '/i_print_label_page';
  static const String stickyNoteEditPage = '/i_print_sticky_note_edit';
  static const String toDoListEditPage = '/i_print_to_do_list_edit';
  static const String labelEditPage = '/i_print_label_page_edit';

  static List<GetPage> route = [
    GetPage(name: initial, page: () => SplashScreen()),
    GetPage(name: navigator, page: () => NavigatorPage()),
    GetPage(name: graphicEditing, page: () => GraphicEditingPage()),
    GetPage(name: drawingBoard, page: () => DrawingPage()),
    GetPage(name: imageCropper, page: () => ImageCropPage()),
    GetPage(name: imageEditor, page: () => ImageEditorPage()),
    GetPage(name: printPreviewPage, page: () => PrintPreviewPage()),
    // GetPage(
    //     name: graffitiCartoonLinePage, page: () => GraffitiCartoonLinePage()),
    // GetPage(name: variousScenePage, page: () => VariousScenePage()),
    // GetPage(name: aiPaintingPage, page: () => AiPaintingPage()),
    // GetPage(name: creativePaintingPage, page: () => CreativePaintingPage()),
    GetPage(name: textExtractionPage, page: () => TextExtractionPage()),
    GetPage(name: documentPrintPage, page: () => DocumentPrintPage()),
    GetPage(name: printWebPagesPage, page: () => PrintWebPage()),
    GetPage(name: bannerPrintPage, page: () => BannerPrintPage()),
    // GetPage(name: aiImagePreviewPage, page: () => AIImagePreviewPage()),
    // GetPage(name: graffitiCartoonLinePreviewPage, page: () => GraffitiCartoonLinePreviewPage()),
    // GetPage(name: lineDrawing, page: () => LineDrawingPage()),
    GetPage(name: printScanningPage, page: () => ScanPrinterPage()),
    // GetPage(name: graffitiPreviewPage, page: () => GraffitiPracticePage()),
    GetPage(name: stickyNotePage, page: () => StickyNotePage()),
    GetPage(name: toDoListPage, page: () => ToDoListPage()),
    GetPage(name: labelPage, page: () => LabelPage()),
    GetPage(name: stickyNoteEditPage, page: () => StickyNoteEditPage()),
    GetPage(name: toDoListEditPage, page: () => ToDoListEditPage()),
    GetPage(name: labelEditPage, page: () => LabelEditPage()),
  ];

  static void goToNextPage(String label) {
    switch (label) {
      case AppConstants.myDevice:
        print(label);
        Get.toNamed(printScanningPage);
        break;
      case AppConstants.printRecord:
        print(label);

        break;
      case AppConstants.aboutUs:
        print(label);
        break;

      case AppConstants.photoPrinting:
        StickerViewController controller = Get.put(StickerViewController());
        controller.selectImage();
        print(label);
        break;
      case AppConstants.graphicEditing:
        StickerViewController controller = Get.put(StickerViewController());
        controller.setCurrentPage(AppConstants.graphicEditing);
        Get.toNamed(graphicEditing);
        print(label);
        break;
      case AppConstants.graffitiPractice:
        // GraffitiCartoonLineController controller =
        //     Get.put(GraffitiCartoonLineController());
        // controller.setCurrentPage(AppConstants.graffitiPractice);
        // Get.toNamed(graffitiCartoonLinePage);
        // print(label);
        break;
      case AppConstants.cartoonishPortraits:
        // GraffitiCartoonLineController controller =
        //     Get.put(GraffitiCartoonLineController());
        // controller.setCurrentPage(AppConstants.cartoonishPortraits);
        // Get.toNamed(graffitiCartoonLinePage);
        // print(label);
        break;
      case AppConstants.lineArt:
        // GraffitiCartoonLineController controller =
        //     Get.put(GraffitiCartoonLineController());
        // controller.setCurrentPage(AppConstants.lineArt);
        // Get.toNamed(graffitiCartoonLinePage);
        print(label);
        break;
      case AppConstants.variousScenes:
        Get.toNamed(variousScenePage);
        print(label);
        break;
      case AppConstants.aiPainting:
        Get.toNamed(aiPaintingPage);
        print(label);
        break;
      case AppConstants.creativePainting:
        StickerViewController controller = Get.put(StickerViewController());
        controller.setCurrentPage(AppConstants.creativePainting);
        controller.drawGraffiti();

        print(label);
        break;
      case AppConstants.textExtraction:
        StickerViewController controller = Get.put(StickerViewController());
        controller.setCurrentPage(AppConstants.textExtraction);
        controller.selectImage();
        print(label);
        break;
      case AppConstants.documentPrint:
        Get.toNamed(documentPrintPage);
        print(label);
        break;
      case AppConstants.printWebPages:
        // StickerViewController controller = Get.put(StickerViewController());
        // controller.setWebView();
        Get.toNamed(printWebPagesPage);
        print(label);
        break;
      case AppConstants.bannerPrint:
        Get.toNamed(bannerPrintPage);
        print(label);
        break;
      case AppConstants.stickyNote:
        TemplatesController templatesController =
            Get.put(TemplatesController());
        templatesController.getStickyNotes();
        Get.toNamed(stickyNotePage);
        print(label);
        break;
      case AppConstants.toDoList:
        TemplatesController templatesController =
            Get.put(TemplatesController());
        templatesController.getToDoList();
        Get.toNamed(toDoListPage);

        print("11$label");
        break;
      case AppConstants.label:

        Get.toNamed(labelPage);
        print(label);
        break;
    }
  }
}
