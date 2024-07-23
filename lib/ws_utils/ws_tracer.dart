import 'dart:async';
import 'dart:io';

import 'package:common_tools/common_tools.dart';
import 'package:flutter/foundation.dart';
import 'package:ws_flutter_app/ws_services/ws_app_service.dart';
import 'package:ws_flutter_app/ws_utils/ws_log/ws_logger.dart';

import '../ws_app/ws_url.dart';
import 'ws_http/ws_http_client.dart';

/// 打点请求头key统一传参
class WSLogHeadersKey {
  static const String logData = "data";
  static const String logLogType = "log_type";
  static const String logSubtype = "subtype";
  static const String logBehavior = "behavior";
  static const String logDeviceId = "device-id";
  static const String logAndroidId = "android_id";
  static const String logUserId = "user_id";
  static const String logPkg = "pkg";
  static const String logChnId = "chn_id";
  static const String logVer = "ver";
  static const String logPlatform = "platform";
  static const String logModel = "model";
  static const String logPVer = "p_ver";
  static const String logLanId = "lan_id";
  static const String logSecId = "sec_id";
  static const String logUtmSource = "utm_source";
  static const String logAfAdgroupId = "af_adgroup_id";
  static const String logAfAdset = "af_adset";
  static const String logAfAdsetId = "af_adset_id";
  static const String logAfStatus = "af_status";
  static const String logAfAgency = "af_agency";
  static const String logAfChannel = "af_channel";
  static const String logAfCampaign = "campaign";
  static const String logAfCampaignId = "campaign_id";
  static const String logCountry = "country";
  static const String logsysLan = "sys_lan";
}

/// 打点中所有涉及到的页面KEY
class WSLogPages {
  // key值（字符串）参考下面的埋点事件
  static const String pageReport = 'report';
  static const String pageBlock = 'block';
  static const String pageEditAvatar = 'editavatar';
  static const String pageLogout = 'logout';
  static const String pageDeleteAccount = 'deleteaccount';
  static const String pageCustomer = 'customer';
  static const String pagePurchase = 'purchase'; //打开充值页面
  static const String pageCreateOrder = 'createorder'; //创建内购订单
  static const String pageLoginSuccess = 'loginsuccess'; //登录成功
  static const String pagePrivacy = 'privacy'; //隐私协议
  static const String pageTerms = 'terms'; //用户协议
  static const String pageAppleLogin = 'applelogin'; //苹果登录
  static const String pageQuickLogin = 'quicklogin'; //快速登录
  static const String pageLaunch = 'launch'; //快速登录
}

class WSLogPvManger {
  WSLogPvManger._();

  static const String _event = 'event';
  static const String _tm = 'tm';
  static const String _page = 'page';
  static const String _subPage = 'subPage';
  static const String _terPage = 'terPage';
  static const String _broadcasterId = 'broadcasterId';
  static const String _duration = 'duration';

  static void stat({
    String? page,
    String? subPage,
    String? terPage,
    String? broadcasterId,
  }) {
    var map = <String, dynamic>{};
    // ⚠️page传入下方的埋点事件page值
    if (page != null) {
      map[_page] = page;
    }
    if (subPage != null) {
      map[_subPage] = subPage;
    }
    if (terPage != null) {
      map[_terPage] = terPage;
    }
    if (broadcasterId != null) {
      map[_broadcasterId] = broadcasterId;
    }
    map[_duration] = 0;
    map[_event] = 'pv';
    map[_tm] = DateTime.now().millisecondsSinceEpoch;

    if (kDebugMode) {
      WSLogger.debug('$map LogPvMgr');
    }
    WSLogManger().putLog(WSLogType.globalBehavior, map);
  }
}

/// 打点类型
enum WSLogType {
  globalBehavior('event', 'global_behavior', 'event'),
  clickEvent("event", "click", "event");

  final String logType;
  final String subType;
  final String behavior;

  const WSLogType(this.logType, this.subType, this.behavior);
}

// 打点管理
class WSLogManger {
  static final WSLogManger _instance = WSLogManger._internal();

  factory WSLogManger() {
    return _instance;
  }

  WSLogManger._internal();

  static const String tag = "LogManger"; // 日志标签
  static const int limitSize = 20; // 打点任务最多缓存长度
  static int _serialId = 0;
  static String launcherId =
      MD5Util.generateMD5('${DateTime.now().millisecondsSinceEpoch}${DeviceUtil().deviceId}');
  final List<Map<String, dynamic>> cacheList = [];
  bool _isWaitingForSend = false; // 是否需要延迟上报

  /// 上报日志
  void putLog(WSLogType logType, Map<String, dynamic>? event) {
    if (logType.logType.isEmpty ||
        logType.subType.isEmpty ||
        logType.behavior.isEmpty ||
        event == null ||
        event.isEmpty) {
      return;
    }
    Map<String, dynamic> itemData = _buildItemData(logType.logType, logType.subType, logType.behavior, event);
    cacheList.insert(0, itemData);
    sendDelayed();
  }

  /// 延时发送日志
  void sendDelayed() {
    if (_isWaitingForSend) {
      return;
    }
    _isWaitingForSend = true;
    Timer(const Duration(milliseconds: 2000), () {
      _isWaitingForSend = false;
      sendLog(false);
    });
  }

  /// 发日志打点
  void sendLog(bool forceUploadAll) {
    try {
      List<Map<String, dynamic>> sendList = [];
      if (cacheList.isEmpty) {
        return;
      } else if (cacheList.length >= limitSize && !forceUploadAll) {
        sendList.addAll(cacheList.sublist(0, limitSize));
        cacheList.removeRange(0, limitSize);
      } else {
        sendList.addAll(cacheList);
        cacheList.clear();
      }
      _doUpload(sendList, true);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /// 立马发送日志
  void putLogRightNow(WSLogType logType, Map<String, dynamic>? event) {
    if (logType.logType.isEmpty ||
        logType.subType.isEmpty ||
        logType.behavior.isEmpty ||
        event == null ||
        event.isEmpty) {
      return;
    }
    Map<String, dynamic> itemData = _buildItemData(logType.logType, logType.subType, logType.behavior, event);
    List<Map<String, dynamic>> list = [];
    list.add(itemData);

    _doUpload(list, false);
  }

  /// 执行上传
  Future<void> _doUpload(List<Map<String, dynamic>> sendList, bool isContinue) async {
    String url = '${WSUrls.tracerBaseUrl}log/live-chat';
    WSHttpCore.getInstance().post(url, data: sendList).then((value) {
      if (isContinue) {
        sendDelayed();
      }
    });
  }

  Map<String, dynamic> _buildItemData(String logType, String subType, String behavior, Map<String, dynamic>? event) {
    String platform = '';
    String? model = '';
    if (Platform.isAndroid) {
      platform = 'Android';
      model = DeviceUtil().androidDeviceInfo.hardware;
    } else if (Platform.isIOS) {
      platform = 'iOS';
      model = DeviceUtil().iosInfo.model;
    }
    Map<String, dynamic> itemData = {};
    itemData[WSLogHeadersKey.logData] = [event];
    itemData[WSLogHeadersKey.logLogType] = logType;
    itemData[WSLogHeadersKey.logSubtype] = subType;
    itemData[WSLogHeadersKey.logBehavior] = behavior;
    itemData[WSLogHeadersKey.logDeviceId] = DeviceUtil().deviceId;
    // itemData[WSLogHeadersKey.logUserId] = WSAppService().userInfo.value.userId;
    // itemData[WSLogHeadersKey.logPkg] = WSDeviceUtil().packageInfo.packageName;
    itemData[WSLogHeadersKey.logChnId] = '';
    // itemData[WSLogHeadersKey.logVer] = WSDeviceUtil().packageInfo.version;
    itemData[WSLogHeadersKey.logPlatform] = platform;
    itemData[WSLogHeadersKey.logModel] = model;
    // itemData[WSLogHeadersKey.logPVer] = WSDeviceUtil().packageInfo.buildNumber;
    itemData[WSLogHeadersKey.logLanId] = launcherId;
    itemData[WSLogHeadersKey.logSecId] = _serialId++;
    // itemData[WSLogHeadersKey.logsysLan] = WSDeviceUtil().getLanguageCode();
    // itemData[WSLogHeadersKey.logCountry] = WSAppService().userInfo.value.country ?? '';
    return itemData;
  }
}
