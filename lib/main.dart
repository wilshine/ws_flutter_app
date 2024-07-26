import 'dart:async';

import 'package:common_tools/common_tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ws_flutter_app/ws_utils/ws_ume_util.dart';

import 'ws_app/ws_app.dart';
import 'ws_utils/ws_shared_preferences_util.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // DeviceUtil.immersionSetting();
    DeviceUtil.lightStatusTheme();
    await XPToolManager.instance.init();
    await Logger.init(logLevel: Logger.levelDebug);
    await DeviceUtil().init();
    await WSSharedPreferencesUtil().init();
    runApp(WSUmeUtil.init(child: const WSApp()));
  }, runZonedGuardedOnError, zoneSpecification: null);
}




void runZonedGuardedOnError(Object exception, StackTrace stackTrace) {
  Logger.error('>>>>>>>>>>$exception    $stackTrace');
}