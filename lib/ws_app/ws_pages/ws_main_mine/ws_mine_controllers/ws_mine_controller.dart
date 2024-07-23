import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_app_const.dart';
import 'package:ws_flutter_app/ws_app/ws_models/ws_article_model.dart';
import 'package:ws_flutter_app/ws_app/ws_url.dart';
import 'package:ws_flutter_app/ws_services/ws_app_service.dart';
import 'package:ws_flutter_app/ws_utils/ws_date_util.dart';
import 'package:ws_flutter_app/ws_utils/ws_http/ws_http_client.dart';
import 'package:ws_flutter_app/ws_utils/ws_log/ws_logger.dart';
import 'package:ws_flutter_app/ws_utils/ws_shared_preferences_util.dart';
import 'package:ws_flutter_app/ws_utils/ws_toast_util.dart';

class WSMineController extends GetxController {
  final currentIndex = 0.obs;

  final editInfoCanSubmit = false.obs;

  /// order list
  final ticketList = [].obs;

  final goodsList = <WSGoodsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    initTickets();
    initGoods();
  }

  Future<void> initGoods() async {
    var param = {
      'isIncludeSubscription': false,
      'payChannel': WSAppConst.payChannel,
    };
    var res = await WSHttpCore.getInstance().postByOptionsJson(WSUrls.goodsSearch, data: param);
    if (res != null && res['code'] == 0) {
      var data = res['data'];
      if (data != null) {
        goodsList.value.clear();
        for (var item in data) {
          goodsList.value.add(WSGoodsModel.fromJson(item));
        }
        goodsList.refresh();
      }
    }
  }

  void initTickets() {
    List list = WSSharedPreferencesUtil().prefs.getStringList(WSAppConst.keyTickets) ?? [];
    for (var item in list) {
      ticketList.value.add(jsonDecode(item));
      ticketList.refresh();
    }
  }

  /// add order info
  void addTicket(Map data) {
    try {
      ticketList.value.add(data);
      List<String> list = ticketList.map((e) => jsonEncode(e)).toList();
      WSSharedPreferencesUtil().prefs.setStringList(WSAppConst.keyTickets, list);
      ticketList.refresh();
      WSLogger.debug('=====>addTicket $data');
    } catch (e, s) {
      WSLogger.error('$e  $s');
    }
  }

  ///
  void updateUserInfo(String nickname, DateTime birthday, String country) async {
    try {
      EasyLoading.show();
      var param = {
        'nickname': nickname,
        'birthday': WSDateUtil.parseTimeYYMMDD(birthday),
        'country': country,
      };
      await Future.delayed(const Duration(seconds: 1));
      var res = await WSHttpCore.getInstance().postByOptionsJson(WSUrls.saveUserInfo, data: param);
      if (res != null && res['code'] == 0) {
        // WSAppService.instance.userInfo.value.nickname = nickname;
        // WSAppService.instance.userInfo.value.birthday = WSDateUtil.parseTimeYYMMDD(birthday);
        // WSAppService.instance.userInfo.value.country = country;
        WSAppService.instance.refreshUserInfo();
        WSToastUtil.show('save success');
        Get.back();
      }
    } catch (e, s) {
      WSLogger.error('updateUserInfo error: $e, $s');
      WSToastUtil.show(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  void buyGoods(WSGoodsModel goodsModel) {}
}
