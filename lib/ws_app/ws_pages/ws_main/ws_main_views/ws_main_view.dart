import 'package:common_tools/common_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_base/ws_base_ui.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main/ws_main_controllers/ws_main_controller.dart';


class WSMainView extends StatefulWidget {
  WSMainView({super.key});

  @override
  State<WSMainView> createState() => _WSMainViewState();
}

class _WSMainViewState extends State<WSMainView> {
  Map<int, WSBaseStatefulWidget> pages = {};

  late WSMainController controller;


  @override
  void initState() {
    controller = Get.put(WSMainController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<WSMainController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return IndexedStack(
          index: controller.currentIndex.value,
          children: [
            // WSHomeView(title: 'Home'),
            // const WSFindView(title: 'Find'),
            // const WSIMView(title: 'IM'),
            // const WSMineView(title: 'Mine'),
          ],
        );
      }),
      bottomNavigationBar: Container(
          height: 83.h,
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x0D000000),
                offset: Offset(0, -1),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: buildBottomWidget()),
    );
  }

  Widget buildBottomWidget() {
    return Obx(() => SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WSTabItem(
                  icon: Image.asset(controller.currentIndex.value == 0
                      ? 'assets/webp/icon_home_active.webp'
                      : 'assets/webp/icon_home_normal.webp'),
                  isActive: controller.currentIndex.value == 0,
                  onPressed: () {
                    controller.currentIndex.value = 0;
                    DeviceUtil.dartStatusTheme();
                  }),
              WSTabItem(
                  icon: Image.asset(controller.currentIndex.value == 1
                      ? 'assets/webp/icon_find_active.webp'
                      : 'assets/webp/icon_find_normal.webp'),
                  isActive: controller.currentIndex.value == 1,
                  onPressed: () {
                    controller.currentIndex.value = 1;

                    DeviceUtil.lightStatusTheme();
                  }),
              WSTabItem(
                  icon: Image.asset(controller.currentIndex.value == 2
                      ? 'assets/webp/icon_info_active.webp'
                      : 'assets/webp/icon_info_normal.webp'),
                  isActive: controller.currentIndex.value == 2,
                  onPressed: () {
                    controller.currentIndex.value = 2;
                    // WSIMManager.getInstance().refreshMessageList();
                    // WSAppService.instance.refreshFollowedList();
                    // WSDeviceUtil.dartStatusTheme();
                  }),
              WSTabItem(
                  icon: Image.asset(controller.currentIndex.value == 3
                      ? 'assets/webp/icon_mine_active.webp'
                      : 'assets/webp/icon_mine_normal.webp'),
                  isActive: controller.currentIndex.value == 3,
                  onPressed: () {
                    controller.currentIndex.value = 3;
                    DeviceUtil.dartStatusTheme();
                  }),
            ],
          ),
        ));
  }
}

class WSTabItem extends StatefulWidget {
  const WSTabItem({
    super.key,
    required this.isActive,
    required this.onPressed,
    required this.icon,
  });

  final bool isActive;
  final Widget icon;
  final Function() onPressed;

  @override
  State<WSTabItem> createState() => _WSTabItemState();
}

class _WSTabItemState extends State<WSTabItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: SizedBox(
          width: 72,
          height: 32,
          child: widget.icon,
        ),
      ),
    );
  }
}
