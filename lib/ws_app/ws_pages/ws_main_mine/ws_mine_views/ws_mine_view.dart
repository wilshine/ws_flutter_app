import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_flutter_app/ws_app/ws_base/ws_base_ui.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_mine/ws_mine_views/ws_mine_base_view.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildTopWidget(),
            buildBottomWidget(),
          ],
        ),
      ),
    );
  }

  Widget buildTopWidget() {
    return Stack(
      children: [
        // const Image(image: AssetImage('assets/webp/mine_top_back.webp')),
        Container(
          color: Colors.blue,
        ),
        Column(
          children: [
            SizedBox(height: context.mediaQueryPadding.top.h),
            buildCustomerServiceIconWidget(),
            SizedBox(height: 20.h),
            Row(
              children: [
                buildUserPicWidget(),
                SizedBox(width: 6.w),
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
              child: Container(margin: EdgeInsets.only(left: 210.w))),
        ),
      ],
    );
  }

  Widget buildBottomWidget() {
    return Column(
      children: [
        buildItem('设置', Icons.settings, () {
          context.push('/main/setting');
        }, true),
      ],
    );
  }

  Widget buildItem(String title, IconData icon, Function() onTap, [bool isHideLine = false]) {
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
                Icon(icon, size: 24.w),
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
