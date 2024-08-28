import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:barcode/barcode.dart';
import 'package:crop_image/crop_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as Http;
import 'package:i_print/api_service/models/IconsDataClass.dart';
import 'package:i_print/api_service/models/borders_data_class.dart';
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/helper/print_images.dart';
import 'package:i_print/helper/router.dart';
import 'package:i_print/print_features/sticker_view/icon_tab/icon_tab.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:screenshot/screenshot.dart';
import 'package:webcontent_converter/webcontent_converter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../api_service/api_service.dart';
import '../../controller/scan_controller.dart';
import '../../views/toolbox/document_print/pdf_action.dart';
import 'sticker_view.dart';
import 'package:image/image.dart' as img;

class StickerViewController extends GetxController implements GetxService {
  final GlobalKey stickGlobalKey = GlobalKey();
  final GlobalKey stickGlobalKey1 = GlobalKey();
  final GlobalKey stickGlobalKey2 = GlobalKey();
  final initialStickerScale = 5.0;
  double sliderValue = 24.0;
  String selectedOption = "";
  String textStickerId = "";
  String textStickerText = "";
  String currentPage = "";
  RxString selectedBorder = "".obs;
  bool photoPrint = false;
  bool isLabelSticker = false;

  RxString selectedAssetId = "".obs;
  List<Widget> labelList = [];
  List<IconsTabs> iconsList = [];
  List<BordersImages> borderList = [];
  int selectedIconTabIndex = 0;
  String selectedIcon = "";
  late BuildContext context;

  int labelListIndex = 0;

  //text Extraction

  @override
  onInit() {
    super.onInit();
    Future.delayed(Duration.zero, () {
      stickerViewHeight.value = (Get.size.height * 0.4);
      update(); // Notify GetX that the state has changed
    });
  }

  getIconData() async {
    var response = await ApiClient.postData(
        AppConstants.baseUrl + AppConstants.getIconsData, null);

    if (response.statusCode == 200) {
      IconsDataClass iconsDataClass =
          IconsDataClass.fromJson(jsonDecode(response.body));
      // labelImages = stickyNotesClass.images!;
      iconsList = iconsDataClass.tabs!;
    }
    update();
  }

  getBorderData() async {
    var response = await ApiClient.postData(
        AppConstants.baseUrl + AppConstants.getBordersData, null);

    if (response.statusCode == 200) {
      BordersDataClass bordersDataClass =
          BordersDataClass.fromJson(jsonDecode(response.body));
      // labelImages = stickyNotesClass.images!;
      borderList = bordersDataClass.borders!;
    }
    update();
  }

  bool isChangeableHeight = true;
  bool extractingText = false;
  FontWeight extractedTextFontWeight = FontWeight.normal;
  FontStyle extractedTextFontStyle = FontStyle.normal;
  TextDecoration extractedTextTextDecoration = TextDecoration.none;
  TextAlign extractedTextTextAlign = TextAlign.left;
  TextEditingController extractedTextController = TextEditingController();

//Web page print
  InAppWebViewController? webViewController;
  ScreenshotController screenshotController = ScreenshotController();
  late List<Uint8List> capturedSS;
  late List<int> capturedSS1;
  final GlobalKey webScreen = GlobalKey();

  //Banner print
  bool isHorizontal = true;
  double bannerTextSize = 30;
  TextEditingController bannerTextController = TextEditingController();
  double verticalTextSize = 150;
  double horizontalTextSize = 50;
  final GlobalKey horizontalTextKey = GlobalKey();
  final GlobalKey verticalTextKey = GlobalKey();

  DrawingController drawingController = DrawingController();
  Color drawingColor = Colors.black;
  double drawingWidth = 2.5;
  CropController cropController = CropController();

  RxDouble stickerViewHeight = (Get.size.height * 0.4).obs;
  FontStyle textStickerFontStyle = FontStyle.normal;
  double textStickerFontSize = 24;
  TextAlign textStickerAlign = TextAlign.center;
  TextAlign labelAlign = TextAlign.center;
  Offset textStickerPosition = Offset.zero;
  FontWeight textStickerFontWeight = FontWeight.normal;
  TextDecoration textStickerDecoration = TextDecoration.none;
  Color textStickerColor = Colors.black;
  TextEditingController stickerTextController = TextEditingController();
  TextEditingController qrCodeTextController = TextEditingController();
  TextEditingController barcodeTextController = TextEditingController();
  int qrIndex = 0;
  late File image = File("");
  late Image memoryImage; //=Image.memory(controller.image);
  double memoryImageHeight = 0;
  double memoryImageWidth = 0;
  RxList<Sticker> stickers = <Sticker>[].obs;

  FontWeight labelFontWeight = FontWeight.bold;
  FontStyle labelFontStyle = FontStyle.normal;

  TextDecoration labelDecoration = TextDecoration.none;

  List<Color> textColorList = [
    Colors.black,
    Colors.white,
    Colors.grey,
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.red,
    Colors.deepOrange,
    Colors.purple,
    Colors.pink,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.yellow,
  ];

  List<StickerEdit> stickerEditOptions = [
    StickerEdit(
      PrintImages.text,
      AppConstants.text,
    ),
    StickerEdit(
      PrintImages.image,
      AppConstants.image,
    ),
    StickerEdit(
      PrintImages.icon,
      AppConstants.icon,
    ),
    StickerEdit(
      PrintImages.border,
      AppConstants.border,
    ),
    StickerEdit(
      PrintImages.qr,
      AppConstants.qrCode,
    ),
    StickerEdit(
      PrintImages.graffitti,
      AppConstants.graffiti,
    ),
  ];

  List<String> styleList = [
    PrintImages.bold,
    PrintImages.italic,
    PrintImages.underline,
    PrintImages.leftAlign,
    PrintImages.centerAlign,
    PrintImages.rightAlign,
  ];

  void addSticker(Sticker sticker) {
    for (var i = 0; i < stickers.length; i++) {
      if (stickers[i].id == sticker.id) {
        stickers[i] = sticker;
        update();
        return;
      }
    }
    // If the sticker with the provided ID is not found, you might want to add it to the list.
    stickers.add(sticker);
    update();
  }

  int getEditOptionCount() {
    return stickerEditOptions.length;
  }

  String getItemData(int index, String type) {
    switch (type) {
      case "Image":
        return stickerEditOptions[index].image;
      case "Text":
        return stickerEditOptions[index].name;
      default:
        return "";
    }
  }

  /* setWebView() {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.google.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.google.com/'));
  }*/

  double getSliderValue() {
    return sliderValue;
  }

  int getColorListCount() {
    return textColorList.length;
  }

  int getBorderListCount() {
    return borderList.length;
  }

  setSliderValue(double value) {
    sliderValue = value;
    textStickerFontSize = value;
    changeTextStickerData();
  }

  void setSelectedOption(int index) {
    selectedOption = stickerEditOptions[index].name;
  }

  void setStickerId() {
    textStickerId = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void changeTextStickerData() {
    var sticker = Sticker(
      id: textStickerId,
      position: textStickerPosition,
      size: const Size(100, 100),
      textStyle: TextStyle(
          fontSize: textStickerFontSize,
          fontWeight: textStickerFontWeight,
          fontStyle: textStickerFontStyle,
          color: textStickerColor,
          decoration: textStickerDecoration,
          decorationColor: textStickerColor),
      isText: true,
      child: Text(
        textStickerText,
        style: TextStyle(
            fontSize: textStickerFontSize,
            fontWeight: textStickerFontWeight,
            color: textStickerColor,
            fontStyle: textStickerFontStyle,
            decoration: textStickerDecoration,
            decorationColor: textStickerColor),
        textAlign: textStickerAlign,
      ),
    );
    addSticker(sticker);
  }

  addSvgSticker(String file) {
    var sticker = Sticker(
      id: textStickerId,
      size: const Size(100, 100),
      textStyle: TextStyle(
        fontSize: textStickerFontSize,
        fontWeight: textStickerFontWeight,
        color: textStickerColor,
      ),
      position: const Offset(100, 100),
      child: SvgPicture.file(File(file)),
    );

    addSticker(sticker);
  }

  addImageSticker(File file) {
    var sticker = Sticker(
      id: textStickerId,
      size: const Size(100, 100),
      textStyle: TextStyle(
        fontSize: textStickerFontSize,
        fontWeight: textStickerFontWeight,
        color: textStickerColor,
      ),
      position: const Offset(100, 100),
      child: Container(
          decoration:
              BoxDecoration(image: DecorationImage(image: FileImage(file)))),
    );

    addSticker(sticker);
  }

  addAssetSvgSticker(String file) {
    var sticker = Sticker(
      id: textStickerId,
      size: const Size(100, 100),
      textStyle: TextStyle(
        fontSize: textStickerFontSize,
        fontWeight: textStickerFontWeight,
        color: textStickerColor,
      ),
      position: const Offset(100, 100),
      child: SvgPicture.network(
        file,
        height: 100,
        width: 100,
      ),
    );

    addSticker(sticker);
  }

  void setTextStickerText(String text) {
    textStickerText = text;
    changeTextStickerData();
  }

  void setStickerTextColor(int index) {
    textStickerColor = textColorList[index];
    changeTextStickerData();
  }

  Color getColor(int index) {
    return textColorList[index];
  }

  String getFile(int index) {
    return borderList[index].borderImage!;
  }

  bool isBorderSquare(int index) {
    return borderList[index].type!.toLowerCase() == "square";
  }

  void decreaseTextSize() {
    if (textStickerFontSize > 20) {
      textStickerFontSize--;
      sliderValue = textStickerFontSize;
      changeTextStickerData();
    }
  }

  void increaseTextSize() {
    if (textStickerFontSize < 100) {
      textStickerFontSize++;
      sliderValue = textStickerFontSize;
      changeTextStickerData();
    }
  }

  String getStyleListItem(int index) {
    return styleList[index];
  }

  int getStyleListCount() {
    return styleList.length;
  }

  void showTextEditBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.0))),
        builder: (BuildContext ctx) {
          return LayoutBuilder(builder: (context, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: GetBuilder<StickerViewController>(
                  builder: (stickerViewController) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 48.0,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: stickerTextController,
                                // maxLength: 20,
                                // autofocus: true,
                                decoration: const InputDecoration(
                                    hintText: "Enter Text",
                                    counterText: "",
                                    border: OutlineInputBorder()),
                                onChanged: (text) {
                                  if (currentPage == AppConstants.label) {
                                    setLabelText();
                                  } else {
                                    stickerViewController
                                        .setTextStickerText(text);
                                  }
                                },
                              ),
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                if (currentPage == AppConstants.label) {
                                  update();
                                }
                                Get.back();
                              },
                              child: SvgPicture.asset(
                                PrintImages.done,
                                color: Colors.black,
                              ),
                            ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      stickerViewController.currentPage == AppConstants.label
                          ? Container()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 48,
                                  child: ListView.separated(
                                      separatorBuilder: (_, __) {
                                        return const Divider();
                                      },
                                      itemCount: stickerViewController
                                          .getColorListCount(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (ctxx, index) {
                                        return InkWell(
                                          onTap: () {
                                            stickerViewController
                                                .setStickerTextColor(index);
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            margin: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: stickerViewController
                                                    .getColor(index)),
                                          ),
                                        );
                                      }),
                                ),
                                Text(
                                    "Font Size: ${stickerViewController.sliderValue}"),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          stickerViewController
                                              .decreaseTextSize();
                                        },
                                        child: const Text("A-"),
                                      ),
                                    )),
                                    Expanded(
                                      flex: 7,
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                            trackShape:
                                                const RoundedRectSliderTrackShape(),
                                            trackHeight: 6,
                                            thumbShape:
                                                const RoundSliderThumbShape(
                                                    enabledThumbRadius: 12,
                                                    elevation: 2),

                                            // disabledInactiveTickMarkColor: blue25,
                                            // overlayColor: Colors.red.withAlpha(32),
                                            // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                            // tickMarkShape: RoundSliderTickMarkShape(),

                                            inactiveTickMarkColor:
                                                Colors.transparent,
                                            // valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                            // valueIndicatorColor: Colors.redAccent,
                                            showValueIndicator:
                                                ShowValueIndicator.never),
                                        child: Slider(
                                          min: 20,
                                          max: 100,
                                          divisions: 80,
                                          onChanged: (value) {
                                            // setState(
                                            //   () {
                                            stickerViewController
                                                .setSliderValue(value);
                                            //   },
                                            // );
                                          },
                                          value: stickerViewController
                                              .getSliderValue(),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Center(
                                      child: InkWell(
                                        onTap: () {
                                          stickerViewController
                                              .increaseTextSize();
                                        },
                                        child: const Text("A+"),
                                      ),
                                    ))
                                  ],
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 48,
                        child: ListView.separated(
                          itemCount: getStyleListCount(),
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                onStyleItemClick(index);
                              },
                              child: SizedBox(
                                  height: 30,
                                  width:
                                      MediaQuery.of(context).size.width / 6 - 3,
                                  child: Container(
                                    height: 25.0,
                                    width: 25.0,
                                    margin: const EdgeInsets.all(4.0),
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade300),
                                    child: SvgPicture.asset(
                                      getStyleListItem(index),
                                      color: Colors.black,
                                    ),
                                  )),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        ),
                      )
                    ],
                  ),
                );
              }),
            );
          });
        });
  }

  void editTextSticker(Sticker sticker, BuildContext context) {
    textStickerId = sticker.id;
    textStickerFontSize = sticker.textStyle.fontSize!;
    textStickerFontWeight = sticker.textStyle.fontWeight!;
    textStickerColor = sticker.textStyle.color!;
    var myWidget = sticker.child as Text;
    textStickerText = myWidget.data!;
    print(textStickerId);
    print(textStickerFontSize);
    print(textStickerFontWeight);
    print(textStickerColor);
    print(textStickerText);
    stickerTextController.text = textStickerText;
    showTextEditBottomSheet(context);
  }

  String getSelectedOption() {
    return selectedOption;
  }

  selectImage() {
    Get.dialog(Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
      child: Container(
        padding: EdgeInsets.all(20.h),
        decoration: BoxDecoration(
            color: PrintColors.background,
            borderRadius: BorderRadius.circular(4.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      clickImage();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 5.h),
                        decoration: BoxDecoration(
                            color: PrintColors.mainColor,
                            borderRadius: BorderRadius.circular(4.r)),
                        child: Center(
                            child: Text(
                          "Open Camera",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ))),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 5.h),
                        decoration: BoxDecoration(
                            color: PrintColors.mainColor,
                            borderRadius: BorderRadius.circular(4.r)),
                        child: Center(
                            child: Text(
                          "Open Gallery",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ))),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.h,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 5.h),
                        decoration: BoxDecoration(
                            color: PrintColors.mainColor,
                            borderRadius: BorderRadius.circular(4.r)),
                        child: Center(
                            child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  void clickImage() async {
    print(Get.currentRoute);
    Get.back();
    photoPrint = Get.currentRoute == RouteHelper.navigator;
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
    );
    if (photo != null) {
      image = File(photo.path);
      cropController = CropController();
      if (currentPage == AppConstants.textExtraction) {
        Get.toNamed(RouteHelper.textExtractionPage);
        extractingText = true;
        extractingTextFromImage();
      } else {
        Get.toNamed(RouteHelper.imageCropper);
      }
    }
  }

  void pickImage() async {
    Get.back();
    print(Get.currentRoute);
    photoPrint = Get.currentRoute == RouteHelper.navigator;
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (photo != null) {
      int imageSize = await photo.length();
      double inMB = imageSize / 1024 / 1024;
      int quality = 96;
      if (inMB > 2) {
        quality = 50;
      } else if (inMB > 5) {
        quality = 40;
      } else if (inMB > 10) {
        quality = 30;
      } else if (inMB > 15) {
        quality = 20;
      } else if (inMB > 20) {
        quality = 15;
      }

      String targetPath = await getPath("jpg");

      var result = await FlutterImageCompress.compressAndGetFile(
        photo.path,
        targetPath,
        quality: quality,
      );

      image = File(targetPath);
      print("file size");
      print(inMB);
      print((await image.length() / 1024 / 1024));
      cropController = CropController();
      if (currentPage == AppConstants.textExtraction) {
        Get.toNamed(RouteHelper.textExtractionPage);
        extractingText = true;
        extractingTextFromImage();
      } else {
        Get.toNamed(RouteHelper.imageCropper);
      }
    }
  }

  void setIconBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.0))),
        builder: (BuildContext ctx) {
          return LayoutBuilder(builder: (context, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: GetBuilder<StickerViewController>(
                  builder: (stickerViewController) {
                return Container(
                    height: 150,
                    padding: const EdgeInsets.all(8.0),
                    child: const MainWidget());
              }),
            );
          });
        });
  }

  void setBorderBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.0))),
        builder: (BuildContext ctx) {
          return LayoutBuilder(builder: (context, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: GetBuilder<StickerViewController>(
                  builder: (stickerViewController) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 116,
                        child: ListView.separated(
                            separatorBuilder: (_, __) {
                              return const Divider();
                            },
                            itemCount:
                                stickerViewController.getBorderListCount(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctxx, index) {
                              return InkWell(
                                onTap: () {
                                  setBorder(index);
                                },
                                child: Container(
                                  height: stickerViewController
                                          .isBorderSquare(index)
                                      ? 80.h
                                      : 60.h,
                                  width: stickerViewController
                                          .isBorderSquare(index)
                                      ? 60.w
                                      : 180.w,
                                  margin: EdgeInsets.all(8.w),
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                      color: PrintColors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(4.r)),
                                  child: Image.network(
                                    stickerViewController.getFile(index),
                                    height: 80.h,
                                    width: 60.w,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                );
              }),
            );
          });
        });
  }

  void setQrCodeBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.0))),
        builder: (BuildContext ctx) {
          return LayoutBuilder(builder: (context, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: GetBuilder<StickerViewController>(
                  builder: (stickerViewController) {
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DefaultTabController(
                        length: 2,
                        initialIndex: 0,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: TabBar(
                                      labelColor: PrintColors.mainColor,
                                      indicatorColor: PrintColors.mainColor,
                                      onTap: (int index) {
                                        print(index);
                                        qrIndex = index;
                                      },
                                      tabs: const <Widget>[
                                        Tab(
                                          child: Text(AppConstants.qrCode),
                                        ),
                                        Tab(
                                          child: Text(AppConstants.barcode),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      generateQrBarcode();
                                    },
                                    child: const Text(AppConstants.done),
                                  ))
                                ],
                              ),
                              SizedBox(
                                height: 100,
                                //I want to use dynamic height instead of fixed height
                                child: TabBarView(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        TextField(
                                          controller: qrCodeTextController,
                                          decoration: const InputDecoration(
                                              hintText:
                                                  AppConstants.qrCodeHint),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        TextField(
                                          controller: barcodeTextController,
                                          decoration: const InputDecoration(
                                              hintText:
                                                  AppConstants.barcodeHint),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ])));
              }),
            );
          });
        });
  }

  void drawGraffiti() {
    drawingController.setStyle(color: Colors.black, strokeWidth: 2.5);
    Get.toNamed(RouteHelper.drawingBoard);
  }

  Future<void> generateQrBarcode() async {
    if (qrIndex == 0) {
      Barcode bc = Barcode.qrCode();
      final svg = bc.toSvg(
        barcodeTextController.text,
        width: 200,
        height: 80,
        fontHeight: 18.h,
      );
      String filename = await getPath("svg");
      File(filename).writeAsStringSync(svg);
      addSvgSticker(filename);
    } else if (qrIndex == 1) {
      Barcode bc = Barcode.pdf417();
      // Barcode bc = Barcode.upcA();
      final svg = bc.toSvg(
        barcodeTextController.text,
        width: 200,
        height: 80,
        fontHeight: 18.h,
      );
      String filename = await getPath("svg");
      File(filename).writeAsStringSync(svg);
      addSvgSticker(filename);
    }
    Get.back();
  }

  Future<String> getPath(String extension) async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    String imageName =
        '${DateTime.now().microsecondsSinceEpoch}_iPrint.$extension';
    final targetPath = '${dir.absolute.path}/iPrint Images/$imageName';
    if (!await Directory('${dir.absolute.path}/iPrint Images/').exists()) {
      Directory('${dir.absolute.path}/iPrint Images/').create();
      // print('Directory created');
    } else {
      // print('directory already present');
    }
    return targetPath;
  }

  void setBorder(int index) {
    selectedBorder.value = borderList[index].borderImage!;
    Get.back();
    update();
  }

  void calculateMaxBottomPosition(Sticker sticker) {
    if (isChangeableHeight) {
      double maxBottom = 0;

      for (final sticker in stickers) {
        final stickerBottom = sticker.position.dy + sticker.size.height + 50;
        if (stickerBottom > maxBottom) {
          maxBottom = stickerBottom;
        }
      }

      if (maxBottom > Get.size.height * 0.4) {
        stickerViewHeight.value = maxBottom;
      }
      print("$maxBottom,${stickerViewHeight.value}");
      update();
    }
  }

  void setDrawingColor(Color color) {
    drawingColor = color;
    drawingWidth = 3;
    drawingController.setStyle(color: color, strokeWidth: 3);
    update();
  }

  void undoDrawing() {
    drawingController.undo();
  }

  void redoDrawing() {
    drawingController.redo();
  }

  void saveDrawing() async {
    final Uint8List? data =
        (await drawingController.getImageData())?.buffer.asUint8List();
    if (data != null) {
      final String img64 = base64Encode(data);

      if (currentPage == AppConstants.creativePainting) {
        Uint8List imageData = base64Decode(img64);
        String filename = await getPath("png");
        File(filename).writeAsBytes(imageData);
        // AICreationController aiCreationController =
        //     Get.put(AICreationController());
        // aiCreationController.setBase64(imageData);
        // aiCreationController.setInitImageName(filename);
      } else {
        Uint8List imageData = base64Decode(img64);
        String filename = await getPath("png");
        File(filename).writeAsBytes(imageData);
        addImageSticker(File(filename));
        Get.back();
      }
    }
  }

  void saveImageDrawing() async {
    final Uint8List? data =
        (await drawingController.getImageData())?.buffer.asUint8List();
    if (data != null) {
      final String img64 = base64Encode(data);
      Uint8List imageData = base64Decode(img64);
      String filename = await getPath("png");
      File(filename).writeAsBytes(imageData);

      image = File(filename);
      update();
    }

    Get.offNamed(RouteHelper.imageCropper);
  }

  void setWidth(double d) {
    drawingWidth = d;
    drawingController.setStyle(color: drawingColor, strokeWidth: drawingWidth);
    update();
  }

  Future<Uint8List> getResizedBytesData(img.Image originalImage) async {
    Directory appDocDir =
        await path_provider.getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    int originalWidth = originalImage!.width;
    int originalHeight = originalImage!.height;

    // Calculate the aspect ratio
    double aspectRatio = originalHeight / originalWidth;

    // Calculate the target height maintaining the aspect ratio
    int targetHeight = (384 * aspectRatio).round();
    final grayscaleImage = img.grayscale(originalImage!);
    final grayBytes = Uint8List.fromList(img.encodePng(grayscaleImage));

    String filePath = '$appDocPath/bitmap.png';

    // Check if the file exists and delete it if it does
    File file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      print('Existing file deleted.');
    }

    // Write the bytes to the file
    await file.writeAsBytes(grayBytes);

    double inMB = file.lengthSync() / 1024 / 1024;
    int quality = 96;
    if (inMB > 2) {
      quality = 50;
    } else if (inMB > 5) {
      quality = 40;
    } else if (inMB > 10) {
      quality = 30;
    } else if (inMB > 15) {
      quality = 20;
    } else if (inMB > 20) {
      quality = 15;
    }

    String targetPath = await getPath("jpg");

    var result = await FlutterImageCompress.compressAndGetFile(
        filePath, targetPath,
        quality: quality, minWidth: 384, minHeight: targetHeight);
    Uint8List data = await result!.readAsBytes();
    File file1 = File(targetPath);
    if (await file1.exists()) {
      await file1.delete();
      print('Existing file deleted.');
    }
    return data;
  }

  void saveBitmap(ui.Image bitmap) async {
    ByteData? data = await bitmap.toByteData(format: ui.ImageByteFormat.png);
    Uint8List bytes = data!.buffer.asUint8List();

    // Define the file path and name

    if (photoPrint) {
      img.Image? originalImage = img.decodePng(bytes);
      print("originalImage");
      print(originalImage);
      // const int posPrinterWidthPixels = 384; // assuming 203 DPI and 80mm width
      // final resizedImage = img.copyResize(
      //   originalImage!,
      //   width: posPrinterWidthPixels,
      //   height: (originalImage!.height *
      //           posPrinterWidthPixels /
      //           originalImage.width)
      //       .round(),
      // );

      // img.Image? tempImage =await img.decodeImage(result);
      Uint8List tempData = await getResizedBytesData(originalImage!);
      capturedSS = [tempData];
      // Uint8List.fromList(img.encodePng(tempImage!));
      // print(capturedSS.length / 1024 / 1024);
      ScanPrinterController scanPrinterController = ScanPrinterController();
      scanPrinterController.copies = 1.0;
      Get.toNamed(RouteHelper.printPreviewPage);
      update();
    } else {
      String filePath = await getPath("png");
      File file = File(filePath);
      file.writeAsBytes(bytes);
      addImageSticker(file);
      Get.back();
    }
  }

/*
  Uint8List _convertImageToThermalFormat(img.Image image) {
    int width = image.width;
    int height = image.height;
    List<int> bytes = [];

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        num luminance = img.getLuminance(image.getPixel(x, y));
        bytes.add(luminance < 128 ? 0 : 1);
      }
    }

    return Uint8List.fromList(bytes);
  }
*/
  /* Uint8List _convertImageToThermalFormat(img.Image image) {
    int width = image.width;
    int height = image.height;
    List<int> bytes = [];

    // Add the command for printing the image
    bytes.addAll([0x1D, 0x76, 0x30, 0x00]); // ESC * command

    // Width and height in dots
    bytes.addAll([width & 0xFF, (width >> 8) & 0xFF]);
    bytes.addAll([height & 0xFF, (height >> 8) & 0xFF]);

    // Convert each pixel to monochrome
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x += 8) {
        int byte = 0;
        for (int bit = 0; bit < 8; bit++) {
          if (x + bit < width) {
            img.Pixel pixel = image.getPixel(x + bit, y);
            num luminance = img.getLuminance(pixel);
            if (luminance < 128) {
              byte |= (1 << (7 - bit));
            }
          }
        }
        bytes.add(byte);
      }
    }

    return Uint8List.fromList(bytes);
  }
*/

  /*Uint8List _convertImageToThermalFormat(img.Image image) {
    int width = image.width;
    int height = image.height;
    List<int> bytes = [];

    // Add the command for printing the image
    bytes.addAll([0x1B, 0x19, 0x01, 0x07]); // ESC * command header

    // Width and height in dots
    bytes.addAll([width & 0xFF, (width >> 8) & 0xFF]);
    bytes.addAll([height & 0xFF, (height >> 8) & 0xFF]);

    // Convert each pixel to monochrome
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x += 8) {
        int byte = 0;
        for (int bit = 0; bit < 8; bit++) {
          if (x + bit < width) {
            img.Pixel pixel = image.getPixel(x + bit, y);
            num luminance = img.getLuminance(pixel);
            if (luminance < 128) {
              byte |= (1 << (7 - bit));
            }
          }
        }
        bytes.add(byte);
      }
    }

    return Uint8List.fromList(bytes);
  }*/

  Uint8List _convertImageToThermalFormat(img.Image image) {
    int width = image.width;
    int height = image.height;
    int printerWidth = 384; // Width of the thermal printer in pixels
    List<int> bytes = [];

    // Add the command for printing the image
    bytes.addAll([0x1B, 0x19, 0x01, 0x07]); // ESC * command header

    // Width and height in dots
    bytes.addAll([printerWidth & 0xFF, (printerWidth >> 8) & 0xFF]);
    bytes.addAll([height & 0xFF, (height >> 8) & 0xFF]);

    // Calculate padding for centering
    int padding = (printerWidth - width) ~/ 2;

    // Convert each pixel to monochrome with padding
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < printerWidth; x += 8) {
        int byte = 0;
        for (int bit = 0; bit < 8; bit++) {
          if (x + bit >= padding && x + bit < padding + width) {
            img.Pixel pixel = image.getPixel(x + bit - padding, y);
            int luminance = img.getLuminance(pixel).toInt();
            if (luminance < 128) {
              byte |= (1 << (7 - bit));
            }
          }
        }
        bytes.add(byte);
      }
    }

    return Uint8List.fromList(bytes);
  }

  void onStyleItemClick(int index) {
    if (currentPage == AppConstants.label) {
      switch (index) {
        case 0:
          labelFontWeight = labelFontWeight == FontWeight.bold
              ? FontWeight.normal
              : FontWeight.bold;
          break;
        case 1:
          labelFontStyle = labelFontStyle == FontStyle.italic
              ? FontStyle.normal
              : FontStyle.italic;
          break;
        case 2:
          labelDecoration = labelDecoration == TextDecoration.underline
              ? TextDecoration.none
              : TextDecoration.underline;
          break;
        case 3:
          labelAlign = TextAlign.left;
          break;
        case 4:
          labelAlign = TextAlign.center;
          break;
        case 5:
          labelAlign = TextAlign.right;
          break;
      }
      setLabelText();
    } else {
      switch (index) {
        case 0:
          textStickerFontWeight = textStickerFontWeight == FontWeight.bold
              ? FontWeight.normal
              : FontWeight.bold;
          break;
        case 1:
          textStickerFontStyle = textStickerFontStyle == FontStyle.italic
              ? FontStyle.normal
              : FontStyle.italic;
          break;
        case 2:
          textStickerDecoration =
              textStickerDecoration == TextDecoration.underline
                  ? TextDecoration.none
                  : TextDecoration.underline;
          break;
        case 3:
          textStickerAlign = TextAlign.left;
          break;
        case 4:
          textStickerAlign = TextAlign.center;
          break;
        case 5:
          textStickerAlign = TextAlign.right;
          break;
      }
      changeTextStickerData();
    }
  }

  void setCurrentPage(String page) {
    isChangeableHeight = true;
    currentPage = page;
  }

  void extractingTextFromImage() async {
    try {
      InputImage inputImage = InputImage.fromFile(image);
      final TextRecognizer textRecognizer = TextRecognizer();
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;
      print(text);
      extractedTextController.text = text;
      extractingText = false;
      update();
      textRecognizer.close();
    } catch (e) {
      print(e);
    }
  }

  void onExtractedTextStyleItemClick(int index) {
    switch (index) {
      case 0:
        extractedTextFontWeight = extractedTextFontWeight == FontWeight.bold
            ? FontWeight.normal
            : FontWeight.bold;
        break;
      case 1:
        extractedTextFontStyle = extractedTextFontStyle == FontStyle.italic
            ? FontStyle.normal
            : FontStyle.italic;
        break;
      case 2:
        extractedTextTextDecoration =
            extractedTextTextDecoration == TextDecoration.underline
                ? TextDecoration.none
                : TextDecoration.underline;
        break;
      case 3:
        extractedTextTextAlign = TextAlign.left;
        break;
      case 4:
        extractedTextTextAlign = TextAlign.center;
        break;
      case 5:
        extractedTextTextAlign = TextAlign.right;
        break;
    }
    update();
  }

  getSelectedColor(int index) {
    switch (index) {
      case 0:
        if (extractedTextFontWeight == FontWeight.bold) {
          return PrintColors.mainColor.withOpacity(.7);
        }

      case 1:
        if (extractedTextFontStyle == FontStyle.italic) {
          return PrintColors.mainColor.withOpacity(.7);
        }
        break;
      case 2:
        if (extractedTextTextDecoration == TextDecoration.underline) {
          return PrintColors.mainColor.withOpacity(.7);
        }
        break;
      case 3:
        if (extractedTextTextAlign == TextAlign.left) {
          return PrintColors.mainColor.withOpacity(.7);
        }
        break;
      case 4:
        if (extractedTextTextAlign == TextAlign.center) {
          return PrintColors.mainColor.withOpacity(.7);
        }
        break;
      case 5:
        if (extractedTextTextAlign == TextAlign.right) {
          return PrintColors.mainColor.withOpacity(.7);
        }
        break;
      default:
        return Colors.grey.shade300;
    }
    return Colors.grey.shade300;
  }

  void captureCurrentPage() async {
    Uint8List? bytes = await webViewController!.takeScreenshot();
    setCapturedSS(bytes!);
    ScanPrinterController scanPrinterController = ScanPrinterController();
    scanPrinterController.copies = 1.0;
    Get.toNamed(RouteHelper.printPreviewPage);
  }

  void captureFullPage(BuildContext context) async {
    bool isLoading = true;
    var url = await webViewController!.getUrl();
    /*Widget retrievedWidget = Container(
      width: Get.size.width,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: url),

              onWebViewCreated: (val){
                _isLoading=false;
              },
            ),
          ),
        ],
      ),
    );

    final FlutterView? view = View.maybeOf(context);
    final Size? viewSize =
        view == null ? null : view.physicalSize / view.devicePixelRatio;
    final Size? targetSizeVertical =
        viewSize == null ? null : Size(viewSize.width, 2000);


          screenshotController
              .captureFromWidget(
            targetSize: targetSizeVertical,
            retrievedWidget,
            context: context,
          )
              .then((capturedImage) {
            // Here you will get the captured image object
            setCapturedSS(capturedImage);
            Get.toNamed(RouteHelper.printPreviewPage);
          });
*/
    String content = await webViewController!
        .evaluateJavascript(source: "document.documentElement.outerHTML");

    var bytes = await WebcontentConverter.contentToImage(content: content);

    setCapturedSS(bytes);
    ScanPrinterController scanPrinterController = ScanPrinterController();
    scanPrinterController.copies = 1.0;
    Get.toNamed(RouteHelper.printPreviewPage);
  }

  Future<List<Uint8List>?> saveAsUint8List(ImageQuality imageQuality) async {
    try {
      Uint8List? pngBytes;
      double pixelRatio = 1.0;

      // Adjust pixelRatio based on image quality
      if (imageQuality == ImageQuality.high) {
        pixelRatio = 2.0;
      } else if (imageQuality == ImageQuality.low) {
        pixelRatio = 0.5;
      }

      // Delay for ensuring the widget rendering
      await Future.delayed(const Duration(milliseconds: 700));

      // Accessing the render boundary
      final boundary = currentPage == AppConstants.label
          ? stickGlobalKey1.currentContext?.findRenderObject()
              as RenderRepaintBoundary?
          : stickGlobalKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception("Render boundary not found");
      }

      // Capturing the image from the boundary
      final uiImage = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception("Failed to convert image to byte data");
      }

      pngBytes = byteData.buffer.asUint8List();

      // Decoding the original image using the 'image' package
      final originalImage = img.decodeImage(pngBytes);
      if (originalImage == null) {
        throw Exception("Failed to decode image");
      }
      Uint8List tempData = await getResizedBytesData(originalImage);

      capturedSS = [tempData]; //.buffer
      // .asUint8List(grayBytes.offsetInBytes, grayBytes.lengthInBytes);

      // Navigating to the print preview page
      ScanPrinterController scanPrinterController = ScanPrinterController();
      scanPrinterController.copies = 1.0;
      Get.toNamed(RouteHelper.printPreviewPage, arguments: capturedSS);

      return capturedSS; // Return the grayscale image bytes
    } catch (e) {
      print("Error: $e");
      rethrow;
    }
  }

  Future<Uint8List?> saveAsUint8List1(ImageQuality imageQuality) async {
    try {
      Uint8List? pngBytes;
      double pixelRatio = 1;
      if (imageQuality == ImageQuality.high) {
        pixelRatio = 2;
      } else if (imageQuality == ImageQuality.low) {
        pixelRatio = 0.5;
      }
      await Future.delayed(const Duration(milliseconds: 700))
          .then((value) async {
        RenderRepaintBoundary boundary = stickGlobalKey2.currentContext
            ?.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        pngBytes = byteData?.buffer.asUint8List();
        // final originalImage = img.decodeImage(pngBytes!);
        // final grayscaleImage = img.grayscale(originalImage!);
        capturedSS1 = pngBytes!;
        // capturedSS = pngBytes!;
        // Get.toNamed(RouteHelper.printPreviewPage);
      });
      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setCapturedSS(Uint8List previewImage) async {
    final originalImage = img.decodeImage(previewImage);
    Uint8List tempData = await getResizedBytesData(originalImage!);

    capturedSS = [tempData];
    update();
    // print(capturedSS[0]);
    // capturedSS = thermalImageBytes;
  }

  assetImageToUint8List(String assetPath) async {
    ByteData? imageData = await rootBundle.load(assetPath);

    List<int> bytes = Uint8List.view(imageData.buffer);
    setCapturedSS(Uint8List.fromList(bytes));
    ScanPrinterController scanPrinterController = ScanPrinterController();
    scanPrinterController.copies = 1.0;
    Get.toNamed(RouteHelper.printPreviewPage);
  }

  networkImageToUint8List(String networkPath) async {
    Http.Response response = await Http.get(
      Uri.parse(networkPath),
    );
    Uint8List bytesNetwork = response.bodyBytes;
    setCapturedSS(bytesNetwork.buffer
        .asUint8List(bytesNetwork.offsetInBytes, bytesNetwork.lengthInBytes));
    ScanPrinterController scanPrinterController = ScanPrinterController();
    scanPrinterController.copies = 1.0;
    Get.toNamed(RouteHelper.printPreviewPage);
  }

  void setBannerTextSize(int i) {
    if (isHorizontal) {
      if ((i < 0 && horizontalTextSize > 50) ||
          (i > 0 && horizontalTextSize < 150)) {
        horizontalTextSize += i;
      }
    } else {
      if ((i < 0 && verticalTextSize > 150) ||
          (i > 0 && verticalTextSize < 250)) {
        verticalTextSize += i;
      }
    }
    update();
  }

  Future<void> bannerSaveImage(BuildContext context) async {
    final FlutterView? view = View.maybeOf(context);
    final Size? viewSize =
        view == null ? null : view.physicalSize / view.devicePixelRatio;
    final Size? targetSizeVertical =
        viewSize == null ? null : Size(viewSize.width, 9999);

    if (isHorizontal) {
      screenshotController
          .captureFromWidget(
              targetSize: targetSizeVertical,
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: PrintColors.background.withOpacity(.5)),
                child: RepaintBoundary(
                  key: horizontalTextKey,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Center(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          bannerTextController.text,
                          style: TextStyle(
                              fontSize: horizontalTextSize,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              context: context)
          .then((capturedImage) {
        // Here you will get image object

        setCapturedSS(capturedImage);
        ScanPrinterController scanPrinterController = ScanPrinterController();
        scanPrinterController.copies = 1.0;
        Get.toNamed(RouteHelper.printPreviewPage);
      });
    } else {
      screenshotController
          .captureFromWidget(
              targetSize: targetSizeVertical,
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: PrintColors.background.withOpacity(.5)),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: bannerTextController.text.split('').map((char) {
                      return Text(
                        char,
                        style: TextStyle(
                            fontSize: verticalTextSize,
                            fontWeight: FontWeight.bold),
                      );
                    }).toList(),
                  ),
                ),
              ),
              context: context)
          .then((capturedImage) {
        // Here you will get image object
        setCapturedSS(capturedImage);
        ScanPrinterController scanPrinterController = ScanPrinterController();
        scanPrinterController.copies = 1.0;
        Get.toNamed(RouteHelper.printPreviewPage);
      });
    }
    // capturedSS = byteData!.buffer.asUint8List();
  }

  Future<void> docxToImage(BuildContext context, String docPath) async {
    final FlutterView? view = View.maybeOf(context);
    late WebViewController webController;
    late String base64Data;
    base64Data = base64.encode(File(docPath).readAsBytesSync());
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    final url =
        'data:application/vnd.openxmlformats-officedocument.wordprocessingml.document;base64,$base64Data';
    await webController.loadRequest(Uri.parse(url));
    final Size? viewSize =
        view == null ? null : view.physicalSize / view.devicePixelRatio;
    final Size? targetSizeVertical =
        viewSize == null ? null : Size(viewSize.width, 9999);
    screenshotController
        .captureFromWidget(
            targetSize: targetSizeVertical,
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                      child: WebViewWidget(
                    controller: webController,
                  )),
                ],
              ),
            ),
            context: context)
        .then((capturedImage) {
      // Here you will get image object
      print(capturedImage);
      setCapturedSS(capturedImage);
      ScanPrinterController scanPrinterController = ScanPrinterController();
      scanPrinterController.copies = 1.0;
      Get.toNamed(RouteHelper.printPreviewPage);
    });

    // capturedSS = byteData!.buffer.asUint8List();
  }

  void setLabelIcon(String icon) {
    selectedIcon = icon;
    labelList = [
      InkWell(
        onTap: () {
          setIconBottomSheet(context);
          labelListIndex = 0;
        },
        child: SvgPicture.network(
          selectedIcon,
          height: 100,
          fit: BoxFit.fill,
        ),
      ),
      Expanded(
          child: InkWell(
        onTap: () {
          labelListIndex = 2;

          showTextEditBottomSheet(context);
        },
        child: Text(
          stickerTextController.text,
          textAlign: labelAlign,
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: labelFontWeight,
            fontStyle: labelFontStyle,
            decoration: labelDecoration,
          ),
        ),
      ))
    ];
    update();
  }

  void setLabelText() {
    labelList = [
      InkWell(
        onTap: () {
          setIconBottomSheet(context);
          labelListIndex = 0;
        },
        child: SvgPicture.asset(
          selectedIcon,
          height: 100,
          fit: BoxFit.fill,
        ),
      ),
      Expanded(
          child: InkWell(
        onTap: () {
          labelListIndex = 2;

          showTextEditBottomSheet(context);
        },
        child: Text(
          stickerTextController.text,
          textAlign: labelAlign,
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: labelFontWeight,
            fontStyle: labelFontStyle,
            decoration: labelDecoration,
          ),
        ),
      ))
    ];
    update();
  }

  Future<void> setSelectedDocxFile(String wordFile) async {
    List<int> data = await File(wordFile).readAsBytesSync();
    capturedSS1 = data;
  }

  pickPdfFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowCompression: true,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      capturedSS =
          await PdfFileAction.convertPdfImagesToUint8List(result.paths[0]!);
      Get.toNamed(RouteHelper.printPreviewPage);

    }
  }
}

class StickerEdit {
  String name;
  String image;

  StickerEdit(this.image, this.name);
}
