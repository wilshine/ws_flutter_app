import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WSDialogUtil {
  /// 设置弹窗具体位置
  static void showDialog({required Widget child, double x = 0.0, double y = 0.0}) {
    Get.dialog(
      Stack(
        children: [
          Positioned(
            left: x,
            top: y,
            child: child,
          ),
        ],
      ),
      barrierDismissible: true,
      useSafeArea: true,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeInOut,
    );
  }

  static void confirm(String title, Function() onConfirm) {
    showCupertinoDialog(
      context: Get.context!,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Center(child: Text(title)),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Get.back();
                onConfirm.call();
              },
              child: const Text("Confirm"),
            ),
            CupertinoDialogAction(
              child: const Text("Cancel"),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }

  /// 选择日期
  static Future<DateTime?> showDatePicker({
    required DateTime initialDateTime,
    DateTime? maximumDate,
    Function(DateTime value)? onDateTimeChanged,
  }) async {
    DateTime select = initialDateTime;
    return showCupertinoModalPopup(
      context: Get.context!,
      builder: (ctx) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    CupertinoButton(
                      child: const Text('Confirm'),
                      onPressed: () {
                        onDateTimeChanged?.call(select);
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  maximumDate: maximumDate,
                  initialDateTime: initialDateTime,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (DateTime value) {
                    select = value;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 底部选择框
  /// {
  ///   title: 'title',
  ///   'onPressed': (){}
  /// }
  static void showSelectDialog(List menus) {
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (context) {
        List<Widget> children = [];
        for (var item in menus) {
          children.add(CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              item['onPressed']?.call();
            },
            child: Container(
              child: Text(item['title']),
            ),
          ));
        }

        return CupertinoActionSheet(
          actions: children,
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  /// 展示内购弹窗列表
  static void showPayDialog() {
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (context) {
        return Container(
          height: Get.size.height - context.mediaQueryPadding.top.h - 50.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.back();
                },
                child: Container(
                  height: 24.h,
                  width: 24.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  margin: EdgeInsets.only(right: 20.w, top: 10.h),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.close,
                    color: Color(0xFFCCCCCC),
                  ),
                ),
              ),
              // const Expanded(child: WSShopCoinView()),
            ],
          ),
        );
      },
    );
  }
}
