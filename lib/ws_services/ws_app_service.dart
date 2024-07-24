import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_flutter_app/ws_app/ws_app_const.dart';
import 'package:ws_flutter_app/ws_app/ws_app_route.dart';
import 'package:ws_flutter_app/ws_app/ws_url.dart';
import 'package:ws_flutter_app/ws_utils/ws_http/ws_http_client.dart';
import 'package:ws_flutter_app/ws_utils/ws_shared_preferences_util.dart';

class WSAppService extends GetxService {
  static WSAppService get instance => Get.find();

  // final userInfo = WSUserInfoModel().obs;

  // WSHBStrategyModel? strategyModel;

  String googleKey = '';

  /// 当前用户的文章数据
  // final articleList = <WSArticleModel>[].obs;

  /// 原始文章数据
  // List<WSArticleModel> articleOriginList = [];

  // List<WSUserModel> userList = <WSUserModel>[];

  @override
  void onInit() async {
    super.onInit();
    // WSLogger.setLevel(WSLogger.levelDebug);
  }

  Future<bool> login({String? appleToken}) async {
    int authType = 4;
    return false;
  }

  Future refreshUserInfo() async {
  }

  Future<bool> isSupportAutoLogin() async {
    String? token = WSSharedPreferencesUtil().prefs.getString(WSAppConst.keyAccessToken);
    String? string = WSSharedPreferencesUtil().prefs.getString(WSAppConst.keyUserInfo);
    bool autoLogin = WSSharedPreferencesUtil().prefs.getBool(WSAppConst.autoLogin) ?? false;
    return token != null && string != null && autoLogin;
  }

  Future<bool> loginAuto() async {
    return false;
  }

  void exitApp() {}

  void deleteAccount() async {
    try {
      EasyLoading.show();
    } finally {
      EasyLoading.dismiss();
    }
  }

  void logout() async {
    try {
      EasyLoading.show();
      router.pushReplacement('/login');
    } catch (e, s) {
      // WSLogger.error('logout  $e  $s');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// 获取用户信息，拼接数据
  Future<void> initData() async {
    String key = WSAppConst.keyArticle;
    String keyOrigin = WSAppConst.keyArticleOrigin;
  }

  Future<bool> refreshArticles() async {
    String key = WSAppConst.keyArticle;
    return false;
  }

  /// 举报某个用户
  Future<void> report(String userId, String type) async {
    var param = {
      'broadcasterId': userId, //对方id
      'complainCategory': 'Report', //业务分类 Block、Report 拉黑不需要传complainSub
      'complainSub': type, //业务子分类  'Pornographic', 'False gender', 'Fraud', 'Political sensitive', 'Other'
    };
  }

  /// 拉黑用户
  /// 拉黑列表+1
  /// 收不到用户的消息、取消对用户的关注、看不到用户的内容
  Future<void> blockUser(String userId) async {
  }

  Future<void> refreshBlockStatus() async {
  }

  /// remove block user
  Future<void> unBlockUser(String userId) async {
  }

  /// reset data when delete account
  void reset() {
    googleKey = '';
  }

  getUser(String userId) {
  }

  // final blockList = <WSUserModel>[].obs;

  Future<void> refreshBlockList() async {
  }

  bool isBlockUser(String userId) {
    return false;
  }

  // final followedList = <WSFollowedItem>[].obs;

  bool isFollowedUser(String userId) {
    return false;
  }

  Future<void> refreshFollowedList() async {
  }

  Future unFriend(String userId) async {
    var param = {
      'followUserId': userId,
    };
    EasyLoading.show();
    try {
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// follow someone
  Future<void> addFriend(String userId) async {
    var param = {
      'followUserId': userId,
    };
    var res = await WSHttpCore().postByOptionsJson(WSUrls.addFriend, data: param);
    if (res != null) {
      await refreshFollowedList();
    }
  }
}
