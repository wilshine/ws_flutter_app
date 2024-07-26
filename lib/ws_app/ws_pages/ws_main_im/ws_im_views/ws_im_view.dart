import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_base/ws_base_ui.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_followed_list_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_messages_list_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_switch_bar.dart';
import 'package:ws_flutter_app/ws_utils/ws_log/ws_logger.dart';

import '../ws_im_controllers/ws_im_controller.dart';

class WSIMView extends WSBaseStatefulWidget {
  const WSIMView({super.key, required super.title});

  @override
  State<WSIMView> createState() => _WSIMViewState();
}

class _WSIMViewState extends State<WSIMView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List tabs = ["消息", "关注"];

  late WSIMController imController;

  @override
  void initState() {
    super.initState();

    imController = Get.put(WSIMController());

    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      WSLogger.debug('=====_tabController.index=${_tabController.index}');
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    Get.delete<WSIMController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.mediaQueryPadding.top.h),
        SizedBox(
          height: 2.h,
        ),
        WSSwitchBar(
          tabs: tabs,
          onEventTapped: (i, value) {
            _tabController.animateTo(i);
          },
          selectedValue: tabs[_tabController.index],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              WSMessagesListView(),
              WSFollowedListView(),
            ],
          ),
        )
      ],
    );
  }
}
