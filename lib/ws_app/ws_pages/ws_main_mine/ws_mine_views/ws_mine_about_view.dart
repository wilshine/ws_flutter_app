import 'package:common_tools/common_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_app_util.dart';

import 'ws_mine_base_view.dart';

class WSMineAboutView extends StatefulWidget {
  const WSMineAboutView({super.key});

  @override
  State<WSMineAboutView> createState() => _WSMineAboutViewState();
}

class _WSMineAboutViewState extends WSMineBaseState<WSMineAboutView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        SizedBox(height: context.mediaQueryPadding.top.h),
        buildTopBar(title: 'About'),
        SizedBox(height: 52.h),
        Container(
          alignment: Alignment.center,
          child: Text(
            'MoovIntract',
            style: TextStyle(color: const Color(0xFF202020), fontSize: 22.sp),
          ),
        ),
        SizedBox(height: 52.h),
        buildItem(title: 'Version', tail: DeviceUtil.instance.packageInfo.version),
        SizedBox(height: 20.h),
        buildItem(
            title: 'Terms and Condition',
            onTap: () {
              WSAppUtil.onEventTermOfUse();
            }),
        SizedBox(height: 20.h),
        buildItem(
            title: 'Privacy Policy',
            onTap: () {
              WSAppUtil.onEventPrivacyPolicy();
            }),
        SizedBox(height: 20.h),
        // buildItem(
        //     title: 'Rate US',
        //     onTap: () async {
        //       final InAppReview inAppReview = InAppReview.instance;
        //
        //       if (await inAppReview.isAvailable()) {
        //         inAppReview.requestReview();
        //       }
        //     }),
      ]),
    );
  }

  Widget buildItem({required String title, String? tail, Function()? onTap}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap?.call();
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
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF404040),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Text(tail ?? ''),
              SizedBox(width: 32.w),
            ],
          )),
    );
  }
}
