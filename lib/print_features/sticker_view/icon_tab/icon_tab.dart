import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:i_print/helper/print_constants.dart';

import '../../../helper/print_color.dart';
import '../sticker_view_controller.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({super.key});

  @override
  State<MainWidget> createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  late TabController controller;
  final StickerViewController stickerViewController =
      Get.put(StickerViewController());

  @override
  void initState() {
    // TODO: implement initState
    setControllerData();
    super.initState();
  }

  void updateTabs() {
    try {
      controller = TabController(
        length: stickerViewController.iconsList.length,
        vsync: this,
        initialIndex: stickerViewController.selectedIconTabIndex,
      );
      setState(() {});
    } catch (on) {
      print(on); // TODO: rem
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TabBar(
          isScrollable: true,
          controller: controller,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).hintColor,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
          ),
          tabs: List.generate(stickerViewController.iconsList.length, (index) {
            String tabIconUrl = stickerViewController.iconsList[index]!.icon!;
            return tabIconUrl.split("/").last.contains(".svg")
                ? SvgPicture.network(
                    tabIconUrl,
                    height: 30.h,
                    width: 30.w,
                  )
                : Image.network(
                    tabIconUrl,
                    height: 30.h,
                    width: 30.w,
                  );
          }),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              stickerViewController.iconsList.length,
              (index) {
                int iconsLength=stickerViewController.iconsList[index].view!.length;
                return Center(
                  child: iconsLength>0? ListView.separated(
                      separatorBuilder: (_, __) {
                        return const Divider();
                      },
                      itemCount:
                      iconsLength,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctxx, index1) {
                        String iconUrl =
                        stickerViewController.iconsList[index].view![index1];

                        return InkWell(
                          onTap: () {
                            // setBorder(index);
                            if (stickerViewController.currentPage ==
                                AppConstants.label) {
                              stickerViewController.setLabelIcon(iconUrl);
                            } else {
                              stickerViewController.addAssetSvgSticker(iconUrl);
                            }
                          },
                          child: Container(
                            height: 60.w,
                            width: 60.w,
                            margin: EdgeInsets.all(8.w),
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                                color: PrintColors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4.r)),
                            child: iconUrl
                                .split("/")
                                .last
                                .contains(".svg")
                                ? SvgPicture.network(
                              iconUrl,
                              height: 60.w,
                              width: 60.w,
                            )
                                : Image.network(
                              iconUrl,
                              height: 60.w,
                              width: 60.w,
                            ),
                          ),
                        );
                      }):Text("No Icons Available"),
                )
                ;
              }
            ),
          ),
        ),
      ],
    );
  }

  void setControllerData() {
    controller = TabController(
      length: stickerViewController.iconsList.length,
      vsync: this,
      initialIndex: stickerViewController.selectedIconTabIndex,
    );
  }
}
