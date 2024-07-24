import 'package:common_tools/common_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_base/ws_base_ui.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main/ws_main_controllers/ws_main_controller.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_example/ws_example_views/ws_example_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_find/ws_views/ws_find_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_home/ws_home_views/ws_home_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_im_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_mine/ws_mine_views/ws_mine_view.dart';

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
    DeviceUtil.dartStatusTheme();
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
            WSHomeView(title: 'Home'),
            const WSFindView(title: 'Find'),
            const WSIMView(title: 'IM'),
            WsExampleView(title: 'Example'),
            const WSMineView(title: 'Mine'),
          ],
        );
      }),
      bottomNavigationBar: Container(
          height: 80.h,
          alignment: Alignment.bottomCenter,
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              WSTabItem(
                  title: '主页',
                  icon: Icon(
                    Icons.home,
                    color: (controller.currentIndex.value == 0 ? Colors.blue : Colors.grey),
                  ),
                  isActive: controller.currentIndex.value == 0,
                  onPressed: () {
                    controller.currentIndex.value = 0;
                    DeviceUtil.dartStatusTheme();
                  }),
              WSTabItem(
                  title: '发现',
                  icon: Icon(
                    Icons.find_in_page,
                    color: (controller.currentIndex.value == 1 ? Colors.blue : Colors.grey),
                  ),
                  isActive: controller.currentIndex.value == 1,
                  onPressed: () {
                    controller.currentIndex.value = 1;
                    DeviceUtil.lightStatusTheme();
                  }),
              WSTabItem(
                  title: '消息',
                  icon: Icon(
                    Icons.message,
                    color: (controller.currentIndex.value == 2 ? Colors.blue : Colors.grey),
                  ),
                  isActive: controller.currentIndex.value == 2,
                  onPressed: () {
                    controller.currentIndex.value = 2;
                  }),
              WSTabItem(
                  title: '示例',
                  icon: Icon(
                    Icons.ac_unit_outlined,
                    color: (controller.currentIndex.value == 3 ? Colors.blue : Colors.grey),
                  ),
                  isActive: controller.currentIndex.value == 3,
                  onPressed: () {
                    controller.currentIndex.value = 3;
                    DeviceUtil.lightStatusTheme();
                  }),
              WSTabItem(
                  title: '我的',
                  icon: Icon(
                    Icons.person,
                    color: (controller.currentIndex.value == 4 ? Colors.blue : Colors.grey),
                  ),
                  isActive: controller.currentIndex.value == 4,
                  onPressed: () {
                    controller.currentIndex.value = 4;
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
    required this.title,
  });

  final bool isActive;
  final Widget icon;
  final Function() onPressed;
  final String title;

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
        child: Column(
          children: [
            SizedBox(width: 72.w, height: 32.h, child: widget.icon),
            Text(
              widget.title,
              style: TextStyle(color: widget.isActive ? Colors.blue : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
