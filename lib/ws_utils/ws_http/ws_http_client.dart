import 'package:dio/dio.dart';
import 'package:ws_flutter_app/ws_app/ws_url.dart';

import 'ws_base_http.dart';

class WSHttpCore extends WSBaseHttp {
  static WSHttpCore? _instance;
  static final _dio = Dio(BaseOptions(
    baseUrl: WSUrls.getBaseUrl(),
    connectTimeout: const Duration(milliseconds: 10 * 1000),
    receiveTimeout: const Duration(milliseconds: 10 * 1000),
    contentType: Headers.formUrlEncodedContentType,
  ));

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

  void _init() {
  }

  static void changeProxyIP(String ip) {}

  static WSHttpCore getInstance() {
    _instance ??= WSHttpCore._internal();
    return _instance!;
  }

}
