import 'package:flutter/foundation.dart';

/// 所有url写在这里
class WSUrls {
  static String getBaseUrl() {
    String url = '';
    // if (!kDebugMode) {
    //   url = ''; //生产环境
    // }
    return url;
  }

  // 埋点
  static const String tracerBaseUrl = 'https://log.heeru.xyz/';

  /// 隐私协议
  static const String privacyPolicy = 'http://h5.heeru.xyz/privacyPolicy.html';

  static const String termConditions = 'http://h5.heeru.xyz/termConditions.html';

  /// 获取app配置
  static const String getAppConfig = 'config/getAppConfig';

  ///策略接口
  static const String getStrategy = 'config/getStrategy';

  /// 融云token
  static const String rongCloudToken = 'user/rongcloud/token';

  /// 登录
  static const String oauth = 'security/oauth';

  /// token校验
  static const isValidToken = 'security/isValidToken';

  /// 退出登录
  static const String logout = 'security/logout';

  /// 删除账号
  static const String deleteAccount = 'user/deleteAccount';

  /// 主播墙接口-获取A面模拟的用户资料
  /// post
  static const String wallSearch = 'broadcaster/wall/search';

  /// 用户信息
  static const String getUserInfo = 'user/getUserInfo';

  /// 保存用户信息
  static const String saveUserInfo = 'user/saveUserInfo';

  /// 获取oss上传权限
  static const String ossPolicy = 'user/oss/policy';

  /// 更新头像
  static const String updateAvatar = 'user/updateAvatar';

  /// 添加关注
  static const String addFriend = 'user/addFriend';

  /// 取消关注
  static const String unFriend = 'user/unfriend';

  /// 举报拉黑
  static const String insertRecord = 'report/complain/insertRecord';

  /// 解除拉黑
  static const String removeBlock = 'report/complain/removeBlock';

  /// 屏蔽列表
  static const String blockList = 'report/complain/blockList';

  /// 关注列表
  static const String friendsList = 'user/getFriendsListPage';

  /// 充值商品列表
  static const String goodsSearch = 'coin/goods/search';

  /// 创建充值订单
  static const String rechargeCreate = 'coin/recharge/create';

  /// 验单
  static const String paymentIpa = 'coin/recharge/payment/ipa';

  /// 金币消耗
  static const String reviewModeConsume = 'coin/reviewModeConsume';

  /// 翻译
  static const String translate = 'https://translation.googleapis.com/language/translate/v2';
}
