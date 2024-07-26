import 'package:common_tools/common_tools.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:rongcloud_im_wrapper_plugin/rongcloud_im_wrapper_plugin.dart';
import 'package:ws_flutter_app/ws_app/ws_app_util.dart';
import 'package:ws_flutter_app/ws_app/ws_models/ws_im_model.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_controllers/ws_im_controller.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/ws_conversation_views/ws_conversation_view.dart';
import 'package:ws_flutter_app/ws_utils/ws_date_util.dart';
import 'package:common_ui/common_ui.dart';

import '../../../ws_models/ws_user_model.dart';

class WSMessagesListView extends StatefulWidget {
  const WSMessagesListView({super.key});

  @override
  State<WSMessagesListView> createState() => _WSMessagesListViewState();
}

class _WSMessagesListViewState extends State<WSMessagesListView> with AutomaticKeepAliveClientMixin, RouteAware {
  late EasyRefreshController easyRefreshController;

  late WSIMController controller;

  @override
  void initState() {
    // WSIMManager.getInstance().refreshMessageList();

    easyRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    super.initState();
  }

  @override
  void didChangeDependencies() {
    WSAppUtil.routeObserver.subscribe(this, ModalRoute.of(context) as Route); //订阅
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    WSAppUtil.routeObserver.unsubscribe(this); //取消订阅
    super.dispose();
  }

  @override
  void didPopNext() {
    // WSIMManager.getInstance().refreshMessageList();
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WsRefreshListWidget(
        refreshOnStart: true,
        itemBuilder: (data, index) {
          return buildItem(WSMessageItem(conversation: RCIMIWConversation.fromJson({
            'unreadCount': index,
            'lastMessage': {
              'nickname': '张三',
              'messageType': 1,
              'receivedTime': DateTime.now().millisecondsSinceEpoch,
            },
          }), user: WSUserModel(
              nickname: '李四'
          )));
        },
        onRefresh: (page) {
          return Future.value(ListResult(list: List.generate(10, (index) => index), hasMore: page < 3));
        },
      ),
    );
  }

  Widget buildItem(WSMessageItem item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push('/main/conversation', extra: item.user!.toJson());
      },
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) {
                WSToast.show('ok~~~~');
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          height: 76,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    margin: const EdgeInsets.only(left: 18, right: 10),
                    child: CircleAvatar(
                      // backgroundImage: item.user?.getUrl != null ? NetworkImage(item.user?.getUrl ?? '') : null,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: getUnreadNumWidget(item),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  (item.user?.nickname ?? '').overflow,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: Text(
                                  getTime(item.conversation?.lastMessage?.receivedTime ?? 0),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(right: 110),
                          child: Text(
                            getMsgContent(item.conversation?.lastMessage),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getUnreadNumWidget(WSMessageItem item) {
    if (item.conversation?.unreadCount == 0) {
      return Container();
    }
    String num = (item.conversation?.unreadCount ?? 0) > 99 ? '99+' : item.conversation!.unreadCount.toString();

    return Container(
      padding: const EdgeInsets.only(left: 4, right: 4),
      constraints: const BoxConstraints(
        minWidth: 16,
        minHeight: 16,
      ),
      height: 16,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Center(
        child: Text(
          num,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String getTime(int time) {
    if (time > 0) {
      return WSDateUtil.parseTime(DateTime.fromMillisecondsSinceEpoch(time));
    }
    return '';
  }

  String getMsgContent(message) {
    // if (message is RCIMIWTextMessage) {
    //   return message.text ?? '';
    // } else if (message is RCIMIWMediaMessage) {
    //   return '[MediaMessage]';
    // } else if (message is RCIMIWImageMessage) {
    //   return '[ImageMessage]';
    // } else if (message is RCIMIWVoiceMessage) {
    //   return '[VoiceMessage]';
    // } else if (message is RCIMIWRecallNotificationMessage) {
    //   return '[RecallNotificationMessage]';
    // } else if (message is RCIMIWLocationMessage) {
    //   return '[LocationMessage]';
    // } else if (message is RCIMIWFileMessage) {
    //   return '[FileMessage]';
    // }
    return '[Message]';
  }

  @override
  bool get wantKeepAlive => true;
}
