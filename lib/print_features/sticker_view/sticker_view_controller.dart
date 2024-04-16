
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_images.dart';

import 'sticker_view.dart';

class StickerViewController extends GetxController implements GetxService {
  final initialStickerScale = 5.0;
  double sliderValue = 24.0;
  String selectedOption = "";
  String textStickerId = "";
  String textStickerText = "";
  FontStyle textStickerFontStyle = FontStyle.normal;
  double textStickerFontSize = 24;
  FontWeight textStickerFontWeight = FontWeight.normal;
  Color textStickerColor = Colors.black;
  TextEditingController stickerTextController = TextEditingController();

  List<Sticker> stickers = [];
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
      "Text",
    ),
    StickerEdit(
      PrintImages.image,
      "Image",
    ),
    StickerEdit(
      PrintImages.icon,
      "Icon",
    ),
    StickerEdit(
      PrintImages.border,
      "Border",
    ),
    StickerEdit(
      PrintImages.qr,
      "QR Code",
    ),

    StickerEdit(
      PrintImages.graffitti,
      "Graffiti",
    ),
  ];

  List<String> styleList=[PrintImages.bold,
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
    switch(type){
      case "Image":
        return stickerEditOptions[index].image;
        case "Text":
        return stickerEditOptions[index].name;
      default:return "";
    }
  }

  double getSliderValue() {
    return sliderValue;
  }

  int getColorListCount() {
    return textColorList.length;
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
      size: Size(100, 100),
      textStyle: TextStyle(
        fontSize: textStickerFontSize,
        fontWeight: textStickerFontWeight,
        color: textStickerColor,
      ),
      child: Text(
        textStickerText,
        style: TextStyle(
          fontSize: textStickerFontSize,
          fontWeight: textStickerFontWeight,
          color: textStickerColor,
        ),
        textAlign: TextAlign.center,
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

  String getStyleListItem(int index){
    return styleList[index];
  }

  int getStyleListCount(){
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
                              onTap: () {},
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
                                      getStyleListItem(
                                          index),
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
    stickerTextController.text=textStickerText;
    showTextEditBottomSheet(context);
  }
}

class StickerEdit {
  String name;
  String image;

  StickerEdit(this.image, this.name);
}


