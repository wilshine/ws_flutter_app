import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_app_const.dart';
import 'package:ws_flutter_app/ws_app/ws_models/ws_article_model.dart';
import 'package:ws_flutter_app/ws_utils/ws_log/ws_logger.dart';
import 'package:common_ui/common_ui.dart';

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
  }

  void initTickets() {
  }

  /// add order info
  void addTicket(Map data) {
  }

  ///
  void updateUserInfo(String nickname, DateTime birthday, String country) async {
    try {
      EasyLoading.show();
    } catch (e, s) {
      WSLogger.error('updateUserInfo error: $e, $s');
      WSToast.show(e.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }

  void buyGoods(WSGoodsModel goodsModel) {}
}
