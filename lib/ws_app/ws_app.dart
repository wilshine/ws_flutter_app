import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_flutter_app/ws_app/ws_app_const.dart';

import '../ws_utils/ws_shared_preferences_util.dart';
import 'ws_app_route.dart';

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
        return app();
      },
    );
  }

  Widget app() {
    String initialLocation = '/splash';
    bool isDoneSplash = WSSharedPreferencesUtil().prefs.getBool(WSAppConst.keyDoneSplash) == true;
    if (isDoneSplash) {
      initialLocation = '/login';
    }
    GoRouter router = GoRouter(
      initialLocation: initialLocation,
      routes: <RouteBase>[deskAppRoute],
      onException: (BuildContext ctx, GoRouterState state, GoRouter router) {
        router.go('/404', extra: state.uri.toString());
      },
    );
    return MaterialApp.router(
      routerConfig: router,
      builder: EasyLoading.init(),
    );
  }
}
