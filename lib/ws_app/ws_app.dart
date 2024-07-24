import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_flutter_app/ws_app/ws_app_const.dart';

import '../ws_services/ws_app_service.dart';
import '../ws_utils/ws_shared_preferences_util.dart';
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

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        Get.put(WSAppService());
        Get.put(WSLoginController());
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
}
