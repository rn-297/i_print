import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:barcode/barcode.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:i_print/controller/ai_creation_controller.dart';
import 'package:http/http.dart' as Http;
import 'package:i_print/helper/print_color.dart';
import 'package:i_print/helper/print_constants.dart';
import 'package:i_print/helper/print_images.dart';
import 'package:i_print/helper/router.dart';
import 'package:i_print/print_features/sticker_view/icon_tab/icon_tab.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:screenshot/screenshot.dart';
import 'package:webcontent_converter/webcontent_converter.dart';
import 'sticker_view.dart';
import 'package:image/image.dart' as img;

class StickerViewController extends GetxController implements GetxService {
  final GlobalKey stickGlobalKey = GlobalKey();
  final GlobalKey stickGlobalKey1 = GlobalKey();
  final initialStickerScale = 5.0;
  double sliderValue = 24.0;
  String selectedOption = "";
  String textStickerId = "";
  String textStickerText = "";
  String currentPage = "";
  RxString selectedBorder = "".obs;
  bool photoPrint = false;

  RxString selectedAssetId = "".obs;

  //text Extraction

  bool isChangeableHeight=true;
  bool extractingText = false;
  FontWeight extractedTextFontWeight = FontWeight.normal;
  FontStyle extractedTextFontStyle = FontStyle.normal;
  TextDecoration extractedTextTextDecoration = TextDecoration.none;
  TextAlign extractedTextTextAlign = TextAlign.left;
  TextEditingController extractedTextController = TextEditingController();

//Web page print
  InAppWebViewController? webViewController;
  ScreenshotController screenshotController = ScreenshotController();
  late Uint8List capturedSS;
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

  List<String> borderList = [
    PrintImages.border1,
    PrintImages.border2,
    PrintImages.border3,
    PrintImages.border4,
    PrintImages.border5,
    PrintImages.border6,
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
      size: Size(100, 100),
      textStyle: TextStyle(
          fontSize: textStickerFontSize,
          fontWeight: textStickerFontWeight,
          fontStyle: textStickerFontStyle,
          color: textStickerColor,
          decoration: textStickerDecoration,
          decorationColor: textStickerColor),
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
      isText: true,
    );
    addSticker(sticker);
  }

  addSvgSticker(String file) {
    var sticker = Sticker(
      id: textStickerId,
      size: Size(100, 100),
      textStyle: TextStyle(
        fontSize: textStickerFontSize,
        fontWeight: textStickerFontWeight,
        color: textStickerColor,
      ),
      child: SvgPicture.file(File(file)),
      position: Offset(100, 100),
    );

    addSticker(sticker);
  }

  addImageSticker(File file) {
    var sticker = Sticker(
      id: textStickerId,
      size: Size(100, 100),
      textStyle: TextStyle(
        fontSize: textStickerFontSize,
        fontWeight: textStickerFontWeight,
        color: textStickerColor,
      ),
      child: Image.file(file),
      position: Offset(100, 100),
    );

    addSticker(sticker);
  }

  addAssetSvgSticker(String file) {
    var sticker = Sticker(
      id: textStickerId,
      size: Size(100, 100),
      textStyle: TextStyle(
        fontSize: textStickerFontSize,
        fontWeight: textStickerFontWeight,
        color: textStickerColor,
      ),
      child: SvgPicture.asset(
        file,
        height: 100,
        width: 100,
      ),
      position: Offset(100, 100),
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
    return borderList[index];
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
        shape: RoundedRectangleBorder(
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
                                maxLength: 20,
                                // autofocus: true,
                                decoration: InputDecoration(
                                    hintText: "Enter Text",
                                    counterText: "",
                                    border: OutlineInputBorder()),
                                onChanged: (text) {
                                  stickerViewController
                                      .setTextStickerText(text);
                                },
                              ),
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
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
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        height: 48,
                        child: ListView.separated(
                            separatorBuilder: (_, __) {
                              return Divider();
                            },
                            itemCount:
                                stickerViewController.getColorListCount(),
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
                                  margin: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: stickerViewController
                                          .getColor(index)),
                                ),
                              );
                            }),
                      ),
                      Text("Font Size: ${stickerViewController.sliderValue}"),
                      Row(
                        children: [
                          Expanded(
                              child: Center(
                            child: InkWell(
                              onTap: () {
                                stickerViewController.decreaseTextSize();
                              },
                              child: Text("A-"),
                            ),
                          )),
                          Expanded(
                            flex: 7,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                  trackShape: RoundedRectSliderTrackShape(),
                                  trackHeight: 6,
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 12, elevation: 2),

                                  // disabledInactiveTickMarkColor: blue25,
                                  // overlayColor: Colors.red.withAlpha(32),
                                  // overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                                  // tickMarkShape: RoundSliderTickMarkShape(),

                                  inactiveTickMarkColor: Colors.transparent,
                                  // valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                                  // valueIndicatorColor: Colors.redAccent,
                                  showValueIndicator: ShowValueIndicator.never),
                              child: Slider(
                                min: 20,
                                max: 100,
                                divisions: 80,
                                onChanged: (value) {
                                  // setState(
                                  //   () {
                                  stickerViewController.setSliderValue(value);
                                  //   },
                                  // );
                                },
                                value: stickerViewController.getSliderValue(),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Center(
                            child: InkWell(
                              onTap: () {
                                stickerViewController.increaseTextSize();
                              },
                              child: Text("A+"),
                            ),
                          ))
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
                                    margin: EdgeInsets.all(4.0),
                                    padding: EdgeInsets.all(8.0),
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
                            return Divider();
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

  void setIconBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
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
                    child: MainWidget());
              }),
            );
          });
        });
  }

  void setBorderBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
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
                              return Divider();
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
                                  height: 80.h,
                                  width: 60.w,
                                  margin: EdgeInsets.all(8.w),
                                  padding: EdgeInsets.all(8.w),
                                  decoration: BoxDecoration(
                                      color: PrintColors.grey.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(4.r)),
                                  child: Image.asset(
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
        shape: RoundedRectangleBorder(
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
                                      tabs: <Widget>[
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
                                    child: Text(AppConstants.done),
                                  ))
                                ],
                              ),
                              Container(
                                height: 100,
                                //I want to use dynamic height instead of fixed height
                                child: TabBarView(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        TextField(
                                          controller: qrCodeTextController,
                                          decoration: InputDecoration(
                                              hintText:
                                                  AppConstants.qrCodeHint),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: <Widget>[
                                        TextField(
                                          controller: barcodeTextController,
                                          decoration: InputDecoration(
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
      File('$filename').writeAsStringSync(svg);
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
      File('$filename').writeAsStringSync(svg);
      addSvgSticker(filename);
    }
    Get.back();
  }

  Future<String> getPath(String extension) async {
    final dir = await path_provider.getApplicationDocumentsDirectory();
    String imageName =
        '${DateTime.now().microsecondsSinceEpoch}_iPrint.${extension}';
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
    selectedBorder.value = borderList[index];
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
        File('$filename').writeAsBytes(imageData);
        // AICreationController aiCreationController =
        //     Get.put(AICreationController());
        // aiCreationController.setBase64(imageData);
        // aiCreationController.setInitImageName(filename);
      } else {
        Uint8List imageData = base64Decode(img64);
        String filename = await getPath("png");
        File('$filename').writeAsBytes(imageData);
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
      File('$filename').writeAsBytes(imageData);

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

  void saveBitmap(ui.Image bitmap) async {

    ByteData? data = await bitmap.toByteData(format: ui.ImageByteFormat.png);
    Uint8List bytes = data!.buffer.asUint8List();
    if (photoPrint) {
      final originalImage = img.decodePng(bytes);
      final grayscaleImage = img.grayscale(originalImage!);
      final grayBytes=Uint8List.fromList(img.encodePng(grayscaleImage));
      capturedSS = grayBytes.buffer.asUint8List(grayBytes.offsetInBytes,grayBytes.lengthInBytes);
      Get.toNamed(RouteHelper.printPreviewPage);
    } else {
      String filePath = await getPath("png");
      File file = File(filePath);
      file.writeAsBytes(bytes);
      addImageSticker(file);
      Get.back();
    }
  }

  void onStyleItemClick(int index) {
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

  void setCurrentPage(String page) {
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
    Get.toNamed(RouteHelper.printPreviewPage);
  }

  void captureFullPage(BuildContext context) async {
    bool _isLoading=true;
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
    String content = await webViewController!.evaluateJavascript(source: "document.documentElement.outerHTML");

    var bytes = await WebcontentConverter.contentToImage(content: content);

    setCapturedSS(bytes);
    Get.toNamed(RouteHelper.printPreviewPage);
  }
  Future<Uint8List?> saveAsUint8List(ImageQuality imageQuality) async {
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
      final boundary = stickGlobalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
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

      // Resize the image to fit an 80mm POS printer while maintaining the aspect ratio
      const int posPrinterWidthPixels = 384; // assuming 203 DPI and 80mm width
      final resizedImage = img.copyResize(
        originalImage,
        width: posPrinterWidthPixels,
        height: (originalImage.height * posPrinterWidthPixels / originalImage.width).round(),
      );

      // Converting to grayscale
      final grayscaleImage = img.grayscale(resizedImage);

      // Updating the captured screenshot variable
      final grayBytes=Uint8List.fromList(img.encodePng(grayscaleImage));
      capturedSS = grayBytes.buffer.asUint8List(grayBytes.offsetInBytes,grayBytes.lengthInBytes);

      // Navigating to the print preview page
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
        RenderRepaintBoundary boundary = stickGlobalKey1.currentContext
            ?.findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        pngBytes = byteData?.buffer.asUint8List();
        final originalImage = img.decodeImage(pngBytes!);
        final grayscaleImage = img.grayscale(originalImage!);
        capturedSS = Uint8List.fromList(img.encodePng(grayscaleImage));
        // capturedSS = pngBytes!;
        Get.toNamed(RouteHelper.printPreviewPage);
      });
      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }

  void setCapturedSS(Uint8List previewImage) {
    final originalImage = img.decodeImage(previewImage!);
    const int posPrinterWidthPixels = 384;
    final resizedImage = img.copyResize(
      originalImage!,
      width: posPrinterWidthPixels,
      height: (originalImage.height * posPrinterWidthPixels / originalImage.width).round(),
    );
    final grayscaleImage = img.grayscale(resizedImage!);
    capturedSS = Uint8List.fromList(img.encodePng(grayscaleImage));
  }

  assetImageToUint8List(String assetPath) async {
    ByteData? imageData = await rootBundle.load(assetPath);
    if (imageData == null) return null;

    List<int> bytes = Uint8List.view(imageData.buffer);
    setCapturedSS(Uint8List.fromList(bytes));

    Get.toNamed(RouteHelper.printPreviewPage);
  }
  networkImageToUint8List(String networkPath) async {
    Http.Response response = await Http.get(
      Uri.parse(networkPath),
    );
    Uint8List bytesNetwork = response.bodyBytes;
    setCapturedSS(bytesNetwork.buffer
        .asUint8List(bytesNetwork.offsetInBytes, bytesNetwork.lengthInBytes));
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
        Get.toNamed(RouteHelper.printPreviewPage);
      });
    }
    // capturedSS = byteData!.buffer.asUint8List();
  }
}

class StickerEdit {
  String name;
  String image;

  StickerEdit(this.image, this.name);
}
