import 'package:flutter/material.dart';
import 'package:ws_flutter_app/ws_app/ws_models/ws_user_model.dart';

import 'ws_message_item_factory.dart';
import 'ws_widget_util.dart';
import '../../util/ws_style.dart';
import '../../util/ws_user_info_datesource.dart' as example;

class WSConversationItem extends StatefulWidget {
  dynamic message;
  ConversationItemDelegate delegate;
  bool showTime;
  bool multiSelect = false;
  List selectedMessageIds;
  _WSConversationItemState? state;
  ValueNotifier<int> time = ValueNotifier<int>(0);

  WSConversationItem({
    required this.delegate,
    required this.message,
    required this.showTime,
    required this.multiSelect,
    required this.selectedMessageIds,
    required this.time,
  });

  @override
  _WSConversationItemState createState() {
    return state = _WSConversationItemState();
  }

  void refreshUI(dynamic message) {
    this.message = message;
    state?._refreshUI(message);
  }
}

class _WSConversationItemState extends State<WSConversationItem> {
  String pageName = "example.ConversationItem";
  WSUserModel? user;
  Offset? tapPos;
  bool isSeleceted = false;
  SelectIcon? icon;
  bool needShowMessage = true;

  void setInfo(String targetId) {
    WSUserModel? userInfo = example.UserInfoDataSource.cachedUserMap[targetId];
    if (userInfo != null) {
      user = userInfo;
    } else {
      example.UserInfoDataSource.getUserInfo(targetId).then((onValue) {
        setState(() {
          user = onValue;
        });
      });
    }
  }

  @override
  void initState() {
    setInfo(widget.message.senderUserId ?? '');
    super.initState();
    bool isSelected = widget.selectedMessageIds.contains(widget.message.messageId);
    icon = SelectIcon(isSelected);
  }

  void _refreshUI(dynamic msg) {
    setState(() {
      widget.message = msg;
      // 撤回消息的时候因为是替换之前的消息 UI ，需要整个刷新 item
      // if (msg is prefix.RCIMIWRecallNotificationMessage) {
      //   setState(() {});
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: <Widget>[
          widget.showTime ? WidgetUtil.buildMessageTimeWidget(widget.message.sentTime!) : WidgetUtil.buildEmptyWidget(),
          showMessage()
        ],
      ),
    );
  }

  Widget showMessage() {
    return Container();
    //属于通知类型的消息
    // if (widget.message is prefix.RCIMIWRecallNotificationMessage) {
    //   return ClipRRect(
    //     borderRadius: BorderRadius.circular(5),
    //     child: Container(
    //       alignment: Alignment.center,
    //       width: WSRCLayout.MessageNotifiItemWidth,
    //       height: WSRCLayout.MessageNotifiItemHeight,
    //       color: const Color(WSRCColor.MessageTimeBgColor),
    //       child: const Text(
    //         RCString.ConRecallMessageSuccess,
    //         style: TextStyle(color: Colors.white, fontSize: WSRCFont.MessageNotifiFont),
    //       ),
    //     ),
    //   );
    // } else {
    //   if (widget.multiSelect == true) {
    //     return GestureDetector(
    //       child: Row(
    //         children: <Widget>[mutiSelectContent(), subContent()],
    //       ),
    //       onTap: () {
    //         __onTapedItem();
    //       },
    //     );
    //   } else {
    //     return GestureDetector(
    //       child: Row(
    //         children: <Widget>[subContent()],
    //       ),
    //     );
    //   }
    // }
  }

  Widget subContent() {
    // if (widget.message.direction == dynamicDirection.send) {
    //   return Expanded(
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         Expanded(
    //           child: Column(
    //             children: <Widget>[
    //               // Container(
    //               //   alignment: Alignment.centerRight,
    //               //   padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
    //               //   child: Text((user == null || user?.id == null ? "" : user!.id!),
    //               //       style: const TextStyle(
    //               //           fontSize: RCFont.MessageNameFont, color: Color(RCColor.MessageNameBgColor))),
    //               // ),
    //               buildMessageWidget(),
    //               Container(
    //                 alignment: Alignment.centerRight,
    //                 padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
    //                 child: GestureDetector(
    //                   behavior: HitTestBehavior.opaque,
    //                   onTapDown: (TapDownDetails details) {
    //                     tapPos = details.globalPosition;
    //                   },
    //                   onTap: () {
    //                     __onTapedReadRequest();
    //                   },
    //                   child: buildReadInfo(),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //         GestureDetector(
    //           onTap: () {
    //             __onTapedUserPortrait();
    //           },
    //           child: WidgetUtil.buildUserPortrait(user?.avatarUrl ?? ''),
    //         ),
    //       ],
    //     ),
    //   );
    // } else if (widget.message.direction == dynamicDirection.receive) {
    //   return Expanded(
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         GestureDetector(
    //           onTap: () {
    //             __onTapedUserPortrait();
    //           },
    //           onLongPress: () {
    //             __onLongPressUserPortrait(tapPos!);
    //           },
    //           child: WidgetUtil.buildUserPortrait(user?.avatarUrl ?? ''),
    //         ),
    //         Expanded(
    //           child: Column(
    //             children: <Widget>[
    //               // Container(
    //               //   alignment: Alignment.centerLeft,
    //               //   padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
    //               //   child: Text(
    //               //     (user == null || user?.id == null ? "" : user!.id!),
    //               //     style: const TextStyle(color: Color(RCColor.MessageNameBgColor)),
    //               //   ),
    //               // ),
    //               buildMessageWidget(),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // } else {
      return WidgetUtil.buildEmptyWidget();
    // }
  }

  Widget mutiSelectContent() {
    // 消息是否添加
    // final alreadySaved = _saved.contains(message);
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: icon,
    );
  }

  void __onTapedItem() {
    widget.delegate.didTapItem(widget.message);
    bool isSelected = widget.selectedMessageIds.contains(widget.message.messageId);
    icon?.updateUI(isSelected);
  }

  void __onTapedMesssage() {
    if (widget.multiSelect == false) {
      // prefix.RongIMClient.messageBeginDestruct(message);
    }
    // return;
    if (widget.multiSelect == true) {
      //多选模式下修改为didTapItem处理
      widget.delegate.didTapItem(widget.message);
      bool isSelected = widget.selectedMessageIds.contains(widget.message.messageId);
      icon?.updateUI(isSelected);
    } else {
      if (!needShowMessage) {
        needShowMessage = true;
        setState(() {});
      }
      widget.delegate.didTapMessageItem(widget.message);
    }
  }

  void __onTapedReadRequest() {
    if (widget.message.groupReadReceiptInfo != null && (widget.message.groupReadReceiptInfo?.hasRespond ?? false)) {
      widget.delegate.didTapMessageReadInfo(widget.message);
    } else {
      widget.delegate.didSendMessageRequest(widget.message);
    }
  }

  void __onLongPressMessage(Offset tapPos) {
    widget.delegate.didLongPressMessageItem(widget.message, tapPos);
  }

  void __onTapedUserPortrait() {}

  void __onLongPressUserPortrait(Offset tapPos) {
    widget.delegate.didLongPressUserPortrait(user?.userId ?? '', tapPos);
  }

  Widget buildMessageWidget() {
    return Container();
    // return Row(
    //   children: <Widget>[
    //     Expanded(
    //       child: Container(
    //         padding: const EdgeInsets.fromLTRB(15, 6, 15, 10),
    //         alignment: widget.message.direction == dynamicDirection.send
    //             ? Alignment.centerRight
    //             : Alignment.centerLeft,
    //         child: Row(
    //             mainAxisAlignment: widget.message.direction == dynamicDirection.send
    //                 ? MainAxisAlignment.end
    //                 : MainAxisAlignment.start,
    //             children: <Widget>[
    //               widget.message.direction == dynamicDirection.send
    //                   ? ValueListenableBuilder(
    //                       builder: (BuildContext context, int value, Widget? child) {
    //                         return Row(
    //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                           children: <Widget>[
    //                             value > 0
    //                                 ? Text(
    //                                     "$value ",
    //                                     style: const TextStyle(color: Colors.red),
    //                                   )
    //                                 : Text("")
    //                           ],
    //                         );
    //                       },
    //                       valueListenable: widget.time,
    //                     )
    //                   : Text(""),
    //               // sentStatus = 20 为发送失败
    //               widget.message.direction == dynamicDirection.send && widget.message.sentStatus == prefix.RCIMIWSentStatus.failed
    //                   ? Container(
    //                       padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
    //                       child: GestureDetector(
    //                           onTap: () {
    //                             if (widget.multiSelect == true) {
    //                               //多选模式下修改为didTapItem处理
    //                               widget.delegate.didTapItem(widget.message);
    //                               bool isSelected = widget.selectedMessageIds.contains(widget.message.messageId);
    //                               icon?.updateUI(isSelected);
    //                             } else {
    //                               widget.delegate.didTapReSendMessage(widget.message);
    //                             }
    //                           },
    //                           child: Image.asset(
    //                             "assets/images/rc_ic_warning.png",
    //                             width: WSRCLayout.MessageErrorHeight,
    //                             height: WSRCLayout.MessageErrorHeight,
    //                           )))
    //                   : WidgetUtil.buildEmptyWidget(),
    //               Container(
    //                 child: GestureDetector(
    //                   behavior: HitTestBehavior.opaque,
    //                   onTapDown: (TapDownDetails details) {
    //                     tapPos = details.globalPosition;
    //                   },
    //                   onTap: () {
    //                     __onTapedMesssage();
    //                   },
    //                   onLongPress: () {
    //                     __onLongPressMessage(tapPos!);
    //                   },
    //                   child: ClipRRect(
    //                     borderRadius: BorderRadius.circular(8),
    //                     child: WSMessageItemFactory(message: widget.message, needShow: needShowMessage),
    //                   ),
    //                 ),
    //               ),
    //               widget.message.direction == dynamicDirection.receive && widget.message != null
    //                   // message.content.destructDuration != null &&
    //                   // message.content.destructDuration > 0
    //                   ? ValueListenableBuilder(
    //                       builder: (BuildContext context, int value, Widget? child) {
    //                         return Row(
    //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                           children: <Widget>[
    //                             value > 0
    //                                 ? Text(
    //                                     " $value",
    //                                     style: const TextStyle(color: Colors.red),
    //                                   )
    //                                 : Text("")
    //                           ],
    //                         );
    //                       },
    //                       valueListenable: widget.time,
    //                     )
    //                   : Text(""),
    //             ]),
    //       ),
    //     )
    //   ],
    // );
  }

  /// 显示已读状态
  Widget buildReadInfo() {
    // if (widget.message.conversationType == prefix.RCIMIWConversationType.private) {
    //   if (widget.message.sentStatus == prefix.RCIMIWSentStatus.read) {
    //     return const Text("Readed");
    //   }
    //   return Text("");
    // } else if (widget.message.conversationType == prefix.RCIMIWConversationType.group) {
    //   if (widget.message.groupReadReceiptInfo != null && (widget.message.groupReadReceiptInfo?.hasRespond ?? false)) {
    //     if (widget.message.receivedStatus != null) {
    //       return Text("${widget.message} Readed");
    //     }
    //     return const Text("0 Readed");
    //   } else {
    //     if (canSendMessageReqdRequest()) {
    //       return Text("√");
    //     }
    //     return Text("");
    //   }
    // }
    return Text('');
  }

  bool canSendMessageReqdRequest() {
    DateTime time = DateTime.now();
    int nowTime = time.millisecondsSinceEpoch;
    if (nowTime - widget.message.sentTime! < 120 * 1000) {
      return true;
    }
    return false;
  }
}

abstract class ConversationItemDelegate {
  //点击 item
  void didTapItem(dynamic message);

  //点击消息
  void didTapMessageItem(dynamic message);

  //长按消息
  void didLongPressMessageItem(dynamic message, Offset tapPos);

  //点击用户头像
  void didTapUserPortrait(String userId);

  //长按用户头像
  void didLongPressUserPortrait(String userId, Offset tapPos);

  //发送消息已读回执请求
  void didSendMessageRequest(dynamic message);

  //点击消息已读人数
  void didTapMessageReadInfo(dynamic message);

  //点击消息已读人数
  void didTapReSendMessage(dynamic message);
}

// 多选模式下 cell 显示的 Icon
class SelectIcon extends StatefulWidget {
  bool isSelected;
  _SelectIconState? state;

  SelectIcon(this.isSelected);

  @override
  _SelectIconState createState() => state = _SelectIconState();

  void updateUI(bool isSelected) {
    this.state?.refreshUI(isSelected);
  }
}

class _SelectIconState extends State<SelectIcon> {
  void refreshUI(bool isSelected) {
    setState(() {
      widget.isSelected = isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
      size: 20,
    );
  }
}
