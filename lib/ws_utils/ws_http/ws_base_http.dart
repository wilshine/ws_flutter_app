import 'dart:convert';
import 'dart:io';

import 'package:common_tools/common_tools.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ws_flutter_app/ws_utils/ws_http/ws_entity.dart';

import '../../ws_app/ws_url.dart';
import 'ws_http_exception.dart';

class WSBaseHttp {
  static const String GET = 'get';
  static const String POST = 'post';
  static const String PUT = 'put';
  static const String PATCH = 'patch';
  static const String DELETE = 'delete';

  static String? accessToken;
  static String? refreshToken;

  final Dio dio;

  PackageInfo? packageInfo;
  IosDeviceInfo? iosInfo;
  var isRefreshToken = false;

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

  WSBaseHttp(this.dio) {
    dio.options.connectTimeout = const Duration(milliseconds: 10 * 1000);
  }

  /// get method
  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    bool getResponse = false,
  }) async {
    options ??= Options();
    options.extra ??= {};
    headers = headers ??= {};
    return _request(
      url,
      method: GET,
      params: params,
      data: data,
      options: options,
      cancelToken: cancelToken,
      headers: headers,
      getResponse: getResponse,
    );
  }

  Future<ResponseEntity<T>> getResponseEntity<T>(
    String url,
    EntityFactory<T> factory, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    bool getResponse = false,
    Map<String, dynamic>? headers,
  }) async {
    var res = await get(url,
        params: params, headers: headers, options: options, cancelToken: cancelToken, getResponse: getResponse);
    var responseEntity = ResponseEntity<T>.fromJson(res, factory: factory);
    return responseEntity;
  }

  Future<dynamic> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgressCallback,
    Map<String, dynamic>? headers,
    bool getResponse = false,
  }) async {
    options ??= Options();
    options.extra ??= {};

    return _request(
      url,
      method: POST,
      params: params,
      headers: headers,
      data: data ?? options.extra?['body'],
      options: options,
      cancelToken: cancelToken,
      onSendProgressCallback: onSendProgressCallback,
      getResponse: getResponse,
    );
  }

  Future<dynamic> delete(String url,
      {dynamic data,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgressCallback}) async {
    return _request(url,
        method: DELETE,
        params: params,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgressCallback: onSendProgressCallback);
  }

  Future<dynamic> postByOptionsJson(String url,
      {dynamic data,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgressCallback}) async {
    options ??= Options();
    options.contentType = Headers.jsonContentType;
    dio.options.contentType = Headers.jsonContentType;
    dio.options.method = POST;
    options.extra ??= {};
    headers = headers ??= {};
    return _request(url,
        method: POST,
        headers: headers,
        params: params,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgressCallback: onSendProgressCallback);
  }

  Future<dynamic> getByOptionsJson(String url,
      {dynamic data,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgressCallback}) async {
    options ??= Options();
    options.contentType = Headers.jsonContentType;

    options.extra ??= {};
    headers ??= {};

    return _request(url,
        method: GET,
        headers: headers,
        params: params,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgressCallback: onSendProgressCallback);
  }

  Future<ResponseEntity<T>> postResponseEntity<T>(
    String url,
    EntityFactory<T>? factory, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    bool getResponse = false,
    Map<String, dynamic>? headers,
  }) async {
    var res = await post(url, data: data, headers: headers, params: params, options: options, cancelToken: cancelToken);
    var responseEntity = ResponseEntity<T>.fromJson(res, factory: factory);
    return responseEntity;
  }

  Future<dynamic> patch(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    bool getResponse = false,
  }) async {
    return _request(url,
        method: PATCH, params: params, options: options, cancelToken: cancelToken, getResponse: getResponse);
  }

  Future<dynamic> _request(
    String url, {
    String? method,
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    ProgressCallback? onSendProgressCallback,
    bool getResponse = false, //返回未处理数据
  }) async {
    headers ??= {};
    headers.addAll(getDefaultHeaders());
    params ??= {};
    String errorMsg = '';
    int statusCode = -1;
    Response? response = await _getResponse(url,
        method: method,
        data: data,
        params: params,
        headers: headers,
        options: options,
        cancelToken: cancelToken,
        onSendProgressCallback: onSendProgressCallback,
        aDio: dio);
    if (getResponse == true) {
      return response;
    }
    statusCode = response?.statusCode ?? -1;
    if (statusCode < 0) {
      errorMsg = 'Network request error, code: $statusCode';
      throw WSHttpResponseNot200Exception(errorMsg);
    }
    if (response?.data is Map<String, dynamic>) {
      return response?.data;
    }
    Map<String, dynamic>? map;
    try {
      map = json.decode(response?.data);
    } catch (error) {
      try {
        map = jsonDecode(response?.data);
      } catch (error) {
        // Logger.debug('===http error===> $error');
      }
    }
    return map ?? response?.data;
  }

  Future<Response?> _getResponse(String url,
      {String? method,
      dynamic data,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgressCallback,
      Dio? aDio,
      Map<String, dynamic>? headers}) async {
    Response? response;
    // 使用新的dio
    Dio tokenDio = aDio ??
        Dio(BaseOptions(
          baseUrl: WSUrls.getBaseUrl(),
          connectTimeout: const Duration(milliseconds: 10 * 1000),
          receiveTimeout: const Duration(milliseconds: 10 * 1000),
          contentType: Headers.formUrlEncodedContentType,
        ));
    options ??= Options();
    options.headers ??= headers;
    // WSLogger.debug('>>>>>start:'
    //     '$url-----headers=${options.headers}--params=$params--------data=$data--------------------->');
    switch (method) {
      case GET:
        response =
            await tokenDio.get(url, data: data, queryParameters: params, options: options, cancelToken: cancelToken);
        break;
      case POST:
        response = await tokenDio.post(url,
            data: data,
            queryParameters: params,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgressCallback);
        break;
      case PATCH:
        response =
            await tokenDio.patch(url, data: data, queryParameters: params, options: options, cancelToken: cancelToken);
        break;
      case PUT:
        response =
            await tokenDio.put(url, data: data, queryParameters: params, options: options, cancelToken: cancelToken);
        break;
      case DELETE:
        response =
            await tokenDio.delete(url, data: data, queryParameters: params, options: options, cancelToken: cancelToken);
        break;
      default:
        throw 'error';
    }
    return response;
  }
}
