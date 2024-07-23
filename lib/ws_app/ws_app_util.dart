import 'package:flutter/cupertino.dart';


class WSAppUtil {
  static void onEventTermOfUse() {
    // WSLogManger().putLog(WSLogType.clickEvent, {'page': WSLogPages.pageTerms});
    // WSDialogActor.pushRoot(WSWebView(url: WSUrls.termConditions)).transitionBuilder =
    //     RiserTransitionBuilder.slideFromRight;
  }

  static void onEventPrivacyPolicy() {
    // WSLogManger().putLog(WSLogType.clickEvent, {'page': WSLogPages.pagePrivacy});
    // WSDialogActor.showRight(WSWebView(url: WSUrls.privacyPolicy)).padding = EdgeInsets.zero;
  }

  static Widget buildEmptyWidget() {
    return Container(
      child: Center(
        child: Image.asset('assets/webp/mine_block_list_empty.webp', width: 180,),
      ),
    );
  }

  static final RouteObserver<Route<dynamic>> routeObserver = RouteObserver();
}
