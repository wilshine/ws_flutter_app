import 'package:common_tools/common_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../ws_services/ws_app_service.dart';
import 'ws_app_route.dart';
import 'ws_pages/ws_login/ws_controllers/ws_login_controller.dart';

class WSApp extends StatefulWidget {
  const WSApp({super.key});

  @override
  State<WSApp> createState() => WSAppState();
}

class WSAppState extends State<WSApp> {
  @override
  void initState() {
    super.initState();
  }

  void initGet() {
    Get.put(WSAppService());
    Get.put(WSLoginController());
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        printScreenInformation();
        initGet();
        return app();
      },
    );
  }

  Widget app() {
    return MaterialApp(
      home: MaterialApp.router(
        key: Get.key,
        routerConfig: router,
        builder: EasyLoading.init(),

      ),
    );
  }

  void printScreenInformation() {
    print('设备宽度:${1.sw}dp');
    print('设备高度:${1.sh}dp');
    print('设备的像素密度:${ScreenUtil().pixelRatio}');
    print('底部安全区距离:${ScreenUtil().bottomBarHeight}dp');
    print('状态栏高度:${ScreenUtil().statusBarHeight}dp');
    print('实际宽度和字体(dp)与设计稿(dp)的比例:${ScreenUtil().scaleWidth}');
    print('实际高度(dp)与设计稿(dp)的比例:${ScreenUtil().scaleHeight}');
    print('高度相对于设计稿放大的比例:${ScreenUtil().scaleHeight}');
    print('系统的字体缩放比例:${ScreenUtil().textScaleFactor}');
    print('屏幕宽度的0.5:${0.5.sw}dp');
    print('屏幕高度的0.5:${0.5.sh}dp');
    print('屏幕方向:${ScreenUtil().orientation}');
  }
}
