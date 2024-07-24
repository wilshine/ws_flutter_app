import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WSNavigationWidgets {
  static late BuildContext gContext;

  static double commonBackButtonTop(BuildContext? context) => (context ?? gContext).mediaQueryPadding.top.h + 8.h;

  static Widget commonBackButton({Color color = Colors.white}) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(Get.context!);
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: EdgeInsets.only(left: 20.w),
        child: Icon(
          Icons.arrow_back,
          color: color,
        ),
      ),
    );
  }
}
