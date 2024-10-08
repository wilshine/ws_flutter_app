import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ume/flutter_ume.dart'; // UME 框架
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart'; // UI 插件包
import 'package:flutter_ume_kit_perf/flutter_ume_kit_perf.dart'; // 性能插件包
import 'package:flutter_ume_kit_show_code/flutter_ume_kit_show_code.dart'; // 代码查看插件包
import 'package:flutter_ume_kit_device/flutter_ume_kit_device.dart'; // 设备信息插件包
import 'package:flutter_ume_kit_console/flutter_ume_kit_console.dart'; // debugPrint 插件包
import 'package:flutter_ume_kit_dio/flutter_ume_kit_dio.dart';
import 'package:flutter_ume_kit_channel_monitor/flutter_ume_kit_channel_monitor.dart';
import 'package:ws_flutter_app/ws_utils/ws_http/ws_http_client.dart'; // Dio 网络请求调试工具

class WSUmeUtil {
  /// 初始化UME
  static Widget init({required Widget child}) {
    if (kDebugMode) {
      PluginManager.instance // 注册插件
        ..register(WidgetInfoInspector())
        ..register(WidgetDetailInspector())
        ..register(ColorSucker())
        ..register(AlignRuler())
        ..register(ColorPicker()) // 新插件
        ..register(TouchIndicator()) // 新插件
        ..register(Performance())
        ..register(ShowCode())
        ..register(MemoryInfoPage())
        ..register(CpuInfoPage())
        ..register(DeviceInfoPanel())
        ..register(Console())
        ..register(ChannelPlugin())
        ..register(DioInspector(dio: WSHttpCore().dio));
      return UMEWidget(
        enable: true,
        child: child,
      );
    }
    return child;
  }
}
