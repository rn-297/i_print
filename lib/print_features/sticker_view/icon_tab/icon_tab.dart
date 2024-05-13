import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../helper/print_color.dart';
import '../sticker_view_controller.dart';

class TabsConfig {
  static List<String> tabs = [
    "assets/svg/icon/bottle.svg",
    "assets/svg/icon/face1.svg",
    "assets/svg/icon/robo1.svg",
    "assets/svg/icon/star.svg",
    "assets/svg/icon/vehicle.svg",
    "assets/svg/icon/zoadiac1.svg"
  ];
  static List<List<String>> iconsList = [
    [
      'assets/svg/icon/bottle.svg',
      'assets/svg/icon/bottle2.svg',
      'assets/svg/icon/bottle3.svg',
      'assets/svg/icon/bottle4.svg',
      'assets/svg/icon/bottle5.svg',
      'assets/svg/icon/bottle6.svg',
      'assets/svg/icon/bottle7.svg',
      'assets/svg/icon/bottle8.svg',
    ],
    [
      'assets/svg/icon/face1.svg',
      'assets/svg/icon/face2.svg',
      'assets/svg/icon/face3.svg',
      'assets/svg/icon/face4.svg',
      'assets/svg/icon/face5.svg',
      'assets/svg/icon/face6.svg',
      'assets/svg/icon/face7.svg',
      'assets/svg/icon/face8.svg',
      'assets/svg/icon/face9.svg',
    ],
    [
      'assets/svg/icon/robo1.svg',
      'assets/svg/icon/robo2.svg',
      'assets/svg/icon/robo3.svg',
      'assets/svg/icon/robo4.svg',
      'assets/svg/icon/robo5.svg',
      'assets/svg/icon/robo6.svg',
      'assets/svg/icon/robo7.svg',
      'assets/svg/icon/robo8.svg',
      'assets/svg/icon/robo9.svg',
    ],
    [
      'assets/svg/icon/satr5.svg',
      'assets/svg/icon/star.svg',
      'assets/svg/icon/star1.svg',
      'assets/svg/icon/star2.svg',
      'assets/svg/icon/star3.svg',
      'assets/svg/icon/star4.svg',
      'assets/svg/icon/star5.svg',
      'assets/svg/icon/star6.svg',
      'assets/svg/icon/star7.svg',
    ],
    [
      'assets/svg/icon/vehicle.svg',
      'assets/svg/icon/vehicle1.svg',
      'assets/svg/icon/vehicle2.svg',
      'assets/svg/icon/vehicle3.svg',
      'assets/svg/icon/vehicle4.svg',
      'assets/svg/icon/vehicle5.svg',
      'assets/svg/icon/vehicle6.svg',
      'assets/svg/icon/vehicle7.svg',
      'assets/svg/icon/vehicle8.svg',
      'assets/svg/icon/vehicle9.svg',
      'assets/svg/icon/vehicle10.svg',
      'assets/svg/icon/vehicle11.svg',
    ],
    [
      'assets/svg/icon/zoadiac1.svg',
      'assets/svg/icon/zoadiac4.svg',
      'assets/svg/icon/zodiac.svg',
      'assets/svg/icon/zodiac2.svg',
      'assets/svg/icon/zodiac3.svg',
      'assets/svg/icon/zodiac4.svg',
      'assets/svg/icon/zodiac5.svg'
    ]
  ];
  static int selectedTabIndex = 0;
}

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

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
    controller = TabController(
      length: TabsConfig.tabs.length,
      vsync: this,
      initialIndex: TabsConfig.selectedTabIndex,
    );
    super.initState();
  }

  void updateTabs() {
    try {
      controller = TabController(
        length: TabsConfig.tabs.length,
        vsync: this,
        initialIndex: TabsConfig.selectedTabIndex,
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
          tabs: List.generate(
            TabsConfig.tabs.length,
            (index) => SvgPicture.asset(
              "${TabsConfig.tabs[index]}",
              height: 30.h,
              width: 30.w,
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              TabsConfig.tabs.length,
              (index) => Center(
                child: ListView.separated(
                    separatorBuilder: (_, __) {
                      return Divider();
                    },
                    itemCount: TabsConfig.iconsList[index].length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctxx, index1) {
                      return InkWell(
                        onTap: () {
                          // setBorder(index);
                          stickerViewController.addAssetSvgSticker(
                              TabsConfig.iconsList[index][index1]);
                        },
                        child: Container(
                          height: 60.w,
                          width: 60.w,
                          margin: EdgeInsets.all(8.w),
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                              color: PrintColors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4.r)),
                          child: SvgPicture.asset(
                            TabsConfig.iconsList[index][index1],
                            height: 60.w,
                            width: 60.w,
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
