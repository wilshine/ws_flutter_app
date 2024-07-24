import 'dart:io';

import 'package:common_tools/common_tools.dart';
import 'package:dio/dio.dart';
import 'package:ws_flutter_app/ws_app/ws_url.dart';


class WSHttpCore extends WsDioHttp {
  static final WSHttpCore _instance = WSHttpCore._internal();
  static final _dio = Dio(BaseOptions(
    baseUrl: WSUrls.getBaseUrl(),
    connectTimeout: const Duration(milliseconds: 10 * 1000),
    receiveTimeout: const Duration(milliseconds: 10 * 1000),
    contentType: Headers.formUrlEncodedContentType,
  ));

  factory WSHttpCore() => _instance;

  WSHttpCore._internal() : super(_dio) {
    _init();
  }

  static void changeBaseUrl(String url) {
    _dio.options.baseUrl = url;
    // WSLogger.debug('changeBaseUrl  $url   ${_dio.options.baseUrl}');
  }

  static String getBaseUrl() {
    return _dio.options.baseUrl;
  }

  void _init() {}

  static void changeProxyIP(String ip) {}

  static String? accessToken;

  @override
  Map<String, dynamic> getDefaultHeaders() {
    Map<String, dynamic> headers = {};

    headers['device-id'] = DeviceUtil().deviceId; // 设备id或者uuid
    if (Platform.isAndroid) {
      headers['platform'] = 'Android';
      headers['model'] = DeviceUtil().androidDeviceInfo.hardware;
    } else if (Platform.isIOS) {
      headers["platform"] = "iOS";
      headers['model'] = DeviceUtil().iosInfo.model;
    }
    headers['pkg'] = DeviceUtil().packageInfo.packageName; // 包名
    headers['ver'] = DeviceUtil().packageInfo.version; // 版本 例如1.0.0，读取实际配置的版本号
    headers['p_ver'] = DeviceUtil().packageInfo.buildNumber; // build number
    headers['kst'] = '1'; // 固定传1
    headers['sys_lan'] = DeviceUtil().getLanguageCode(); // 手机系统语言 如英文en 中文zh
    headers['lang'] = DeviceUtil().getLanguageCode(); // 手机系统语言 如英文en 中文zh
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer$accessToken'; //
    }
    return headers;
  }
}
