import 'package:flutter/cupertino.dart';
import 'package:ws_flutter_app/ws_app/ws_app_route.dart';
import 'package:ws_flutter_app/ws_app/ws_url.dart';


class WSAppUtil {
  static void onEventTermOfUse() {
    router.push('/webview', extra: {'url': WSUrls.termConditions});
    // WSLogManger().putLog(WSLogType.clickEvent, {'page': WSLogPages.pageTerms});
    // WSDialogActor.pushRoot(WSWebView(url: WSUrls.termConditions)).transitionBuilder =
    //     RiserTransitionBuilder.slideFromRight;
  }

  static void onEventPrivacyPolicy() {
    router.push('/webview', extra: {'url': WSUrls.privacyPolicy});
    // WSLogManger().putLog(WSLogType.clickEvent, {'page': WSLogPages.pagePrivacy});
    // WSDialogActor.showRight(WSWebView(url: WSUrls.privacyPolicy)).padding = EdgeInsets.zero;
  }

  static Widget buildEmptyWidget() {
    return Center(
      child: Image.asset('assets/webp/mine_block_list_empty.webp', width: 180,),
    );
  }

}
