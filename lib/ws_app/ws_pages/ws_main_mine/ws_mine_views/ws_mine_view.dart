import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:ws_flutter_app/ws_app/ws_base/ws_base_ui.dart';
import 'package:ws_flutter_app/ws_app/ws_base/ws_base_ui.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_mine/ws_mine_views/ws_mine_base_view.dart';
import 'package:ws_flutter_app/ws_services/ws_app_service.dart';
import 'package:ws_flutter_app/ws_utils/ws_toast_util.dart';

import '../../../../ws_utils/ws_tracer.dart';
import '../ws_mine_controllers/ws_mine_controller.dart';
import 'ws_mine_setting_view.dart';

class WSMineView extends WSBaseStatefulWidget {
  const WSMineView({super.key, required super.title});

  @override
  State<WSMineView> createState() => _WSMineViewState();
}

class _WSMineViewState extends WSMineBaseState<WSMineView> {
  late WSMineController controller;

  @override
  void initState() {
    controller = Get.put(WSMineController());

    super.initState();
  }

  @override
  void dispose() {
    Get.delete<WSMineController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildTopWidget(),
              buildBottomWidget(),
            ],
          ),
        ),
      ),
    );
  }

  buildTopWidget() {
    return Container(
      child: Stack(
        children: [
          Container(
            child: const Image(image: AssetImage('assets/webp/mine_top_back.webp')),
          ),
          Column(
            children: [
              SizedBox(height: context.mediaQueryPadding.top.h),
              buildCustomerServiceIconWidget(),
              SizedBox(height: 20.h),
              Row(
                children: [
                  buildUserPicWidget(),
                  SizedBox(
                    width: 6.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            WSLogManger().putLog(WSLogType.clickEvent, {'page': WSLogPages.pageEditAvatar});
                            // Get.to(() => const WSMineEditInfoView());
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Obx(() {
                                    return Text(
                                      '',
                                      // '${WSAppService.instance.userInfo.value.nickname}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: const Color(0xFF202020),
                                        fontSize: 18.sp,
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(width: 8.w),
                                Image.asset('assets/webp/mine_top_setting.webp', width: 14.w),
                                SizedBox(width: 32.w)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            // Clipboard.setData(ClipboardData(text: WSAppService.instance.userInfo.value.userId ?? ''));
                            WSToastUtil.show('Copy successfully');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'ID:',
                                style: TextStyle(color: const Color(0x4D000000), fontSize: 14.sp),
                              ),
                              Expanded(
                                child: Obx(() {
                                  return Text(
                                    '',
                                    // '${WSAppService.instance.userInfo.value.userId}', //.padRight(7, '0').substring(0, 7)
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: const Color(0x4D000000), fontSize: 14.sp),
                                  );
                                }),
                              ),
                              SizedBox(width: 10.w),
                              Container(
                                alignment: Alignment.center,
                                width: 36.w,
                                height: 12.h,
                                color: const Color(0xFF454545),
                                child: const Text(
                                  'copy',
                                  style: TextStyle(color: Colors.white, fontSize: 10),
                                ),
                              ),
                              SizedBox(width: 32.w),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 26.h,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // Get.to(() => const WSShopView());
                },
                child: Container(margin: EdgeInsets.only(left: 210.w), child: buildCoinWidget())),
          ),
        ],
      ),
    );
  }

  Widget buildBottomWidget() {
    return Container(
      child: Column(
        children: [
          buildItem('My Ticket', 'assets/webp/mine_menu_ticket.webp', () {
            // Get.to(() => const WSMineTicketView());
          }),
          buildItem('Block List', 'assets/webp/mine_menu_block_list.webp', () {
            // Get.to(() => const WSBlockListView());
          }),
          buildItem('About', 'assets/webp/mine_menu_about.webp', () {
            // Get.to(() => const WSMineAboutView());
          }),
          buildItem('Setting', 'assets/webp/mine_menu_setting.webp', () {
            Get.to(() => const WSMineSettingView());
          }, true),
        ],
      ),
    );
  }

  Widget buildItem(String title, String assetPath, Function() onTap, [bool isHideLine = false]) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        height: 56.h,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: 32.w),
                Image.asset(assetPath, width: 24.w),
                SizedBox(width: 16.w),
                Container(
                  height: 55.h,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: TextStyle(color: const Color(0xFF202020), fontSize: 16.sp),
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, size: 16.w, color: const Color(0x4D000000)),
                SizedBox(width: 32.w),
              ],
            ),
            if (!isHideLine)
              Container(
                margin: EdgeInsets.only(left: 36.w, right: 36.w),
                height: 1.h,
                color: const Color(0x33333333),
              ),
          ],
        ),
      ),
    );
  }
}
