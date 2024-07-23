import 'package:flutter/material.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/util/bloc/ws_message_bloc.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/ws_conversation_views/ws_item/ws_conversation_item.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/ws_conversation_views/ws_item/ws_widget_util.dart';
import 'package:ws_flutter_app/ws_utils/ws_log/ws_logger.dart';

/// 会话列表
class WSMessageContentList extends StatefulWidget {
  MessageContentListDelegate delegate;

  List messageDataSource = [];
  bool multiSelect;
  List selectedMessageIds = [];
  late _WSMessageContentListState state;

  WSMessageContentList({
    super.key,
    required this.messageDataSource,
    required this.multiSelect,
    required this.selectedMessageIds,
    required this.delegate,
  });

  void updateData(List messageDataSource, bool multiSelect, List selectedMessageIds) {
    state.updateData(messageDataSource, multiSelect, selectedMessageIds);
  }

  /// 刷新单个消息
  void refreshItem(dynamic msg) {
    state._refrshItem(msg);
  }

  @override
  State<StatefulWidget> createState() {
    return state = _WSMessageContentListState();
  }
}

class _WSMessageContentListState extends State<WSMessageContentList> // implements ConversationItemDelegate
    implements
        ConversationItemDelegate {
  ScrollController? _scrollController;
  double mPosition = 0;
  late WSMessageBloc _bloc;
  Map conversationItems = {};
  Map burnMsgMap = {};

  void updateData(List messageDataSource, bool multiSelect, List selectedMessageIds) {
    // streamController.sink.add(messageDataSource);
    _bloc.updateMessageList(messageDataSource);
    widget.messageDataSource = messageDataSource;
    widget.multiSelect = multiSelect;
    widget.selectedMessageIds = selectedMessageIds;
  }

  @override
  void initState() {
    _bloc = WSMessageBloc();

    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _scrollController = null;
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // mPosition 不是特别准确，可能导致有偏移
    _scrollController = ScrollController(initialScrollOffset: mPosition);
    _addScroolListener();
    return StreamBuilder<MessageInfoWrapState>(
        stream: _bloc.outListData,
        builder: (ctx, AsyncSnapshot<MessageInfoWrapState> snapshot) {
          MessageInfoWrapState? messageInfoWrapState = snapshot.data;
          if (messageInfoWrapState == null) {
            return WidgetUtil.buildEmptyWidget();
          }
          List messageDataSource = messageInfoWrapState.messageList;
          return ListView.separated(
              key: UniqueKey(),
              shrinkWrap: true,
              //因为消息超过一屏，ListView 很难滚动到最底部，所以要翻转显示，同时数据源也要逆序
              reverse: true,
              controller: _scrollController,
              itemCount: messageDataSource.length,
              itemBuilder: (BuildContext context, int index) {
                if (messageDataSource.isNotEmpty) {
                  dynamic tempMessage = messageDataSource[index];
                  // bool isSelected = selectedMessageIds.contains(tempMessage.messageId);
                  int destructDuration = 0;
                  ValueNotifier<int> time = ValueNotifier<int>(destructDuration);
                  if (burnMsgMap[tempMessage.messageId] != null) {
                    time.value = burnMsgMap[tempMessage.messageId];
                  }
                  WSConversationItem item = WSConversationItem(
                      delegate: this,
                      message: tempMessage,
                      showTime: _needShowTime(index, messageDataSource),
                      multiSelect: widget.multiSelect,
                      selectedMessageIds: widget.selectedMessageIds,
                      time: time);
                  conversationItems[tempMessage.messageId] = item;
                  return item;
                } else {
                  return WidgetUtil.buildEmptyWidget();
                }
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 10,
                  width: 1,
                );
              });
        });
  }

  void _addScroolListener() {
    _scrollController?.addListener(() {
      mPosition = _scrollController?.position.pixels ?? 0;
      WSLogger.debug(
          'scroll---->>>>>>>>mPosition=$mPosition   pixels=${_scrollController?.position.pixels}  maxScrollExtent=${_scrollController?.position.maxScrollExtent}');
      //此处要用 == 而不是 >= 否则会触发多次
      if (_scrollController?.position.pixels == _scrollController?.position.maxScrollExtent) {
        widget.delegate.willpullMoreHistoryMessage();
        setState(() {});
      }
    });
  }

  bool _needShowTime(int index, List messageDataSource) {
    bool needShow = false;
    //消息是逆序的
    if (index == messageDataSource.length - 1) {
      //第一条消息一定显示时间
      needShow = true;
    } else {
      //如果满足条件，则显示时间
      // RCIMIWMessage lastMessage = messageDataSource[index + 1];
      // RCIMIWMessage curMessage = messageDataSource[index];
      // if (WSDateUtil.needShowTime(lastMessage.sentTime ?? 0, curMessage.sentTime ?? 0)) {
      //   needShow = true;
      // }
    }
    return needShow;
  }

  void _refrshItem(dynamic msg) {
    WSConversationItem? item = conversationItems[msg.messageId];
    item?.refreshUI(msg);
  }

  @override
  void didLongPressMessageItem(dynamic message, Offset tapPos) {
    widget.delegate.didLongPressMessageItem(message, tapPos);
  }

  @override
  void didLongPressUserPortrait(String userId, Offset tapPos) {
    widget.delegate.didLongPressUserPortrait(userId, tapPos);
  }

  @override
  void didSendMessageRequest(dynamic message) {
    widget.delegate.didSendMessageRequest(message);
  }

  @override
  void didTapItem(dynamic message) {
    widget.delegate.didTapItem(message);
  }

  @override
  void didTapMessageItem(dynamic message) {
    widget.delegate.didTapMessageItem(message);
  }

  @override
  void didTapMessageReadInfo(dynamic message) {
    widget.delegate.didTapMessageReadInfo(message);
  }

  @override
  void didTapUserPortrait(String userId) {
    widget.delegate.didTapUserPortrait(userId);
  }

  @override
  void didTapReSendMessage(dynamic message) {
    widget.delegate.didTapReSendMessage(message);
  }
}

abstract class MessageContentListDelegate {
  void willpullMoreHistoryMessage();

  void didLongPressMessageItem(dynamic message, Offset tapPos);

  void didLongPressUserPortrait(String userId, Offset tapPos);

  void didSendMessageRequest(dynamic message);

  void didTapItem(dynamic message);

  void didTapMessageItem(dynamic message);

  void didTapMessageReadInfo(dynamic message);

  void didTapUserPortrait(String userId);

  void didTapReSendMessage(dynamic message);
}
