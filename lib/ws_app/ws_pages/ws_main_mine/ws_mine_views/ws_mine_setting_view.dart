import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_flutter_app/ws_app/ws_app_const.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_mine/ws_mine_views/ws_mine_base_view.dart';
import 'package:ws_flutter_app/ws_services/ws_app_service.dart';
import 'package:ws_flutter_app/ws_utils/ws_dialog_util.dart';
import 'package:ws_flutter_app/ws_utils/ws_shared_preferences_util.dart';

class WSMineSettingView extends StatefulWidget {
  const WSMineSettingView({super.key});

  @override
  State<WSMineSettingView> createState() => _WSMineSettingViewState();
}

class _WSMineSettingViewState extends WSMineBaseState<WSMineSettingView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: context.mediaQueryPadding.top.h),
          buildTopBar(title: '设置'),
          SizedBox(height: 32.h),
          buildWatermarkItem(),
          SizedBox(height: 20.h),
          buildDeleteItem(),
          SizedBox(height: 20.h),
          buildLogoutItem(),
        ],
      ),
    );
  }

  Widget buildWatermarkItem() {
    return Container(
      height: 44.h,
      margin: EdgeInsets.only(left: 32.w, right: 32.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20.w),
              child: const Text(
                '展示水印',
                style: TextStyle(
                  color: Color(0xFF404040),
                  fontSize: 16,
                ),
              ),
            ),
          ),
          StatefulBuilder(
            builder: (context, setState) => Switch(
              activeTrackColor: const Color(0xFFFFE34E),
              inactiveThumbColor: Colors.white,
              activeColor: Colors.white,
              value: WSSharedPreferencesUtil().prefs.getBool(WSAppConst.keyAutoTranslate) ?? false,
              onChanged: (value) {
                WSSharedPreferencesUtil().prefs.setBool(WSAppConst.keyAutoTranslate, value);
                setState(() {});
                if (value) {
                  WsWatermark.addWatermark(context, '我是水印');
                } else {
                  WsWatermark.removeWatermark();
                }
              },
            ),
          ),
          SizedBox(width: 32.w),
        ],
      ),
    );
  }

  buildDeleteItem() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        context.push('/main/setting/about');
      },
      child: Container(
          height: 44.h,
          margin: EdgeInsets.only(left: 32.w, right: 32.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20.w),
                  child: const Text(
                    '关于',
                    style: TextStyle(
                      color: Color(0xFF404040),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16.w, color: const Color(0x4D000000)),
              SizedBox(width: 32.w),
            ],
          )),
    );
  }

  buildLogoutItem() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        WSDialogUtil.confirm('确认退出登录?', () async {
          WSAppService.instance.logout();
        });
      },
      child: Container(
        height: 44.h,
        margin: EdgeInsets.only(left: 32.w, right: 32.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20.w),
                child: const Text(
                  '退出登录',
                  style: TextStyle(
                    color: Color(0xFF404040),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.w, color: const Color(0x4D000000)),
            SizedBox(width: 32.w),
          ],
        ),
      ),
    );
  }
}
