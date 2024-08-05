import 'dart:async';

import 'package:common_tools/common_tools.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ws_flutter_app/ws_utils/ws_ume_util.dart';
import 'package:flutter_ume_kit_channel_monitor/flutter_ume_kit_channel_monitor.dart';
import 'ws_app/ws_app.dart';
import 'ws_utils/ws_shared_preferences_util.dart';

void main() {
  runZonedGuarded(() async {
    if (kDebugMode) {
      ChannelBinding.ensureInitialized(); //debug情况下接入ume，监控channel
    } else {
      WidgetsFlutterBinding.ensureInitialized();
    }
    DeviceUtil.immersionSetting();
    DeviceUtil.lightStatusTheme();
    await XPToolManager.instance.init();
    await Logger.init(logLevel: Logger.levelDebug);
    await DeviceUtil().init();
    await WSSharedPreferencesUtil().init();
    Align;
    runApp(WSUmeUtil.init(child: const WSApp()));
  }, runZonedGuardedOnError, zoneSpecification: null);
}

void runZonedGuardedOnError(Object exception, StackTrace stackTrace) {
  Logger.error('>>>>>>>>>>$exception    $stackTrace');
}
