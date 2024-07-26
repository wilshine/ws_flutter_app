import 'dart:io';

import 'package:common_ui/common_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_login/ws_controllers/ws_login_controller.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/util/ws_media_util.dart';
import 'package:ws_flutter_app/ws_utils/ws_dialog_util.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_utils/ws_tracer.dart';

class WSMineBaseState<T extends StatefulWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

  /// 顶部导航栏
  Widget buildTopBar({String? title}) {
    return Container(
      margin: EdgeInsets.only(top: 13.h),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              title ?? '',
              style: TextStyle(color: Color(0xFF202020), fontSize: 18.sp, fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            left: 20.w,
            top: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                child: Icon(Icons.arrow_back),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildUserPicWidget() {
    return GestureDetector(
      onTap: () async {
        List list = [
          {
            'title': 'Take a picture',
            'onPressed': () async {
              String? imgPath = await WSMediaUtil.instance.takePhoto();
              if (imgPath != null) {
                updateUserAvatar(imgPath);
              }
            },
          },
          {
            'title': 'Photo album',
            'onPressed': () async {
              String? imgPath = await WSMediaUtil.instance.pickImage();
              if (imgPath != null) {
                updateUserAvatar(imgPath);
              }
            },
          }
        ];
        WSDialogUtil.showSelectDialog(list);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(left: 32.w),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(1.8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(49.w)),
                color: Colors.white,
              ),
              child: Obx(
                () => CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 50.w,
                  backgroundImage: Get.find<WSLoginController>().getAvatarImage(),
                ),
              ),
            ),
            Positioned(
              right: 2.w,
              bottom: 2.w,
              child: SizedBox(
                width: 24.w,
                height: 20.w,
                child: Image.asset('assets/webp/mine_top_pic.webp'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 更新头像
  void updateUserAvatar(String path) async {
    try {
      EasyLoading.show();
      await Get.find<WSLoginController>().refreshAvatar(path);
      WSToast.show('update successfully');
    } finally {
      EasyLoading.dismiss();
    }
  }

  Widget buildCustomerServiceIconWidget() {
    return Container(
      margin: EdgeInsets.only(right: 20.w),
      alignment: Alignment.centerRight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          WSLogManger().putLog(WSLogType.clickEvent, {'page': WSLogPages.pageCustomer});
        },
        child: Image(
          image: const AssetImage('assets/webp/mine_top_icon.webp'),
          width: 32.w,
        ),
      ),
    );
  }
}
