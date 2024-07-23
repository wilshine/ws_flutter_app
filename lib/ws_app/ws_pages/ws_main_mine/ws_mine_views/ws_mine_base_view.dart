import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/util/ws_media_util.dart';
import 'package:ws_flutter_app/ws_app/ws_url.dart';
import 'package:ws_flutter_app/ws_services/ws_app_service.dart';
import 'package:ws_flutter_app/ws_utils/ws_dialog_util.dart';
import 'package:ws_flutter_app/ws_utils/ws_http/ws_http_client.dart';
import 'package:ws_flutter_app/ws_utils/ws_toast_util.dart';
import 'package:get/get.dart' as getx;
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
            getx.Obx(() {
              return Container(
                padding: EdgeInsets.all(1.8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(49.w)),
                  color: Colors.white,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 49.w,
                  // foregroundImage: (WSAppService.instance.userInfo.value.avatarUrl != null &&
                  //         WSAppService.instance.userInfo.value.avatarUrl!.isNotEmpty)
                  //     ? NetworkImage(WSAppService.instance.userInfo.value.avatarUrl ?? '')
                  //     : null,
                ),
              );
            }),
            Positioned(
              right: 2.w,
              bottom: 2.w,
              child: Container(
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
      var ossRes = await WSHttpCore.getInstance().get(WSUrls.ossPolicy);
      var data = ossRes['data'];
      File file = File(path);
      DateTime dateTime = DateTime.now();
      String fileName = file.path.split('/').last;
      String format = fileName.split('.').last;
      int imageTimeName = dateTime.millisecondsSinceEpoch + (dateTime.microsecondsSinceEpoch ~/ 1000000);
      String imageName = '$imageTimeName.$format';
      String host = data!['host'];
      String dir = data!['dir'];
      var filePath = await MultipartFile.fromFile(file.path, filename: fileName);
      final formData = FormData.fromMap({
        'ossaccessKeyId': data!['accessKeyId'],
        'policy': data!['policy'],
        'signature': data!['signature'],
        'callback': data!['callback'],
        'key': '$dir/$imageName',
        'file': filePath,
      });
      var res = await WSHttpCore.getInstance().postByOptionsJson(host, data: formData);
      if (res != null) {
        if (res["data"]["filename"] != null) {
          var avatarInfo = await WSHttpCore.getInstance().postByOptionsJson(
            WSUrls.updateAvatar,
            data: {'avatarPath': res["data"]["filename"]},
          );
          if (avatarInfo != null) {
            // WSAppService.instance.userInfo.value.avatarUrl = avatarInfo['data']['thumbUrl'];
            WSAppService.instance.refreshUserInfo();
            WSToastUtil.show('update successfully');
          }
        }
      } else {
        WSToastUtil.show('update failed');
      }
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
          // String userId = WSAppService.instance.strategyModel!.userServiceAccountId!;
          // WSUserModel user = await UserInfoDataSource.getUserInfo(userId);
          // getx.Get.to(() => WSConversationView(user: user));
        },
        child: Container(
          child: const Image(
            image: AssetImage(
              'assets/webp/mine_top_icon.webp',
            ),
            width: 32,
          ),
        ),
      ),
    );
  }

  Widget buildCoinWidget() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          child: getx.Obx(() {
            return Text(
              '',
              // '${WSAppService.instance.userInfo.value.availableCoins}',
              style: TextStyle(color: Colors.white, fontSize: 24.sp),
            );
          }),
        ),
        SizedBox(height: 10.h),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'My Coins',
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }
}
