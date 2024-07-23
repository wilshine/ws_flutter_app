import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_models/ws_user_model.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/util/ws_style.dart';
import 'package:ws_flutter_app/ws_utils/ws_log/ws_logger.dart';

import '../ws_conversation_controllers/ws_conversation_controller.dart';
import '../ws_file_preview_page.dart';
import 'ws_item/ws_bottom_input_bar.dart';
import 'ws_item/ws_bottom_tool_bar.dart';
import 'ws_item/ws_message_content_list.dart';
import 'ws_item/ws_widget_util.dart';

/// 会话页
class WSConversationView extends StatefulWidget {
  WSConversationView({super.key, required this.user});

  WSUserModel user;

  @override
  State<WSConversationView> createState() => WSConversationViewState();
}

class WSConversationViewState extends State<WSConversationView>
    implements WSBottomToolBarDelegate, WSBottomInputBarDelegate, MessageContentListDelegate {
  late WSMessageContentList messageContentList;

  late WSBottomToolBar bottomToolBar;
  late WSBottomInputBar bottomInputBar;

  bool multiSelect = false; //是否是多选模式

  ConversationStatus? currentStatus; //当前输入工具栏的状态

  InputBarStatus currentInputStatus = InputBarStatus.Normal;
  List<Widget> extWidgetList = []; //加号扩展栏的 widget 列表
  ListView? phrasesListView;

  List messageDataSource = []; //消息数组
  List selectedMessageIds = []; //已经选择的所有消息Id，只有在 multiSelect 为 YES,才会有有效值

  int recordTime = 0;

  List userIdList = [];

  late WSConversationController controller;

  @override
  void initState() {
    super.initState();
    // WSMediaUtil.instance.requestPermissions();
    controller = Get.put(WSConversationController(this));

    messageContentList = WSMessageContentList(
      delegate: this,
      messageDataSource: messageDataSource,
      multiSelect: multiSelect,
      selectedMessageIds: selectedMessageIds,
    );

    bottomInputBar = WSBottomInputBar(delegate: this);
    bottomToolBar = WSBottomToolBar(delegate: this);

    setInfo();

    _addIMHandler();

    onGetHistoryMessages();

    _initExtentionWidgets();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setInfo() {
  }

  void _addIMHandler() {
    //
    // EventBus.instance.addListener(EventKeys.ReceiveReadReceipt, (map) {
    //   String tId = map["tId"];
    //   if (tId == this.targetId) {
    //     onGetHistoryMessages();
    //   }
    // });
    //
    // EventBus.instance.addListener(EventKeys.ReceiveReceiptRequest, (map) {
    //   String tId = map["targetId"];
    //   String messageUId = map["messageUId"];
    //   if (tId == this.targetId) {
    //     _sendReadReceiptResponse(messageUId);
    //   }
    // });
    //
    // EventBus.instance.addListener(EventKeys.ReceiveReceiptResponse, (map) {
    //   String tId = map["targetId"];
    //   developer.log("ReceiveReceiptResponse" + tId + this.targetId,
    //       name: pageName);
    //   if (tId == this.targetId) {
    //     onGetHistoryMessages();
    //   }
    // });
    //
    // EventBus.instance.addListener(EventKeys.ForwardMessageEnd, (arg) {
    //   developer.log("ForwardMessageEnd：" + this.targetId, name: pageName);
    //   multiSelect = false;
    //   selectedMessageIds.clear();
    //   // onGetHistoryMessages();
    //   _refreshMessageContentListUI();
    //   _refreshUI();
    // });

    // WSIMManager.getInstance().engine?.onMessageReceived =
    //     (RCIMIWMessage? message, int? left, bool? offline, bool? hasPackage) {
    //   WSLogger.debug('onMessageReceived: $message, $left, $offline, $hasPackage');
    //   if (message?.targetId == widget.user.userId) {
    //     insertOrReplaceMessage(message!);
    //   }
    // };

    // 监听输入状态
    // WSIMManager.getInstance().engine?.onUltraGroupTypingStatusChanged =
    //     (List<RCIMIWUltraGroupTypingStatusInfo>? info) {};

    // RongIMClient.onTypingStatusChanged = (int conversationType, String targetId, List typingStatus) async {
    //   if (conversationType == this.conversationType && targetId == this.targetId) {
    //     if (typingStatus.length > 0) {
    //       TypingStatus status = typingStatus[typingStatus.length - 1];
    //       if (status.typingContentType == TextMessage.objectName) {
    //         titleContent = RCString.ConTyping;
    //       } else if (status.typingContentType == VoiceMessage.objectName || status.typingContentType == 'RC:VcMsg') {
    //         titleContent = RCString.ConSpeaking;
    //       }
    //     } else {
    //       titleContent = '与 $targetId 的会话';
    //     }
    //     _refreshUI();
    //   }
    // };
  }

  Future<void> fetchMessageBefore() async {}

  Future<void> fetchMessageAfter() async {}

  /// 获取历史消息
  void onGetHistoryMessages() async {
  }

  String pageName = "example.ConversationPage";

  // String? targetId;

  void _initExtentionWidgets() {
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
              },
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: Container(
          child: Stack(
            children: [
              SafeArea(
                child: Column(
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        children: <Widget>[Flexible(child: messageContentList)],
                      ),
                    ),
                    Container(
                      child: _buildBottomInputBar(),
                    ),
                    _getExtentionWidget(),
                  ],
                ),
              ),
              Obx(
                () => _buildExtraCenterWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getExtentionWidget() {
    if (currentInputStatus == InputBarStatus.Extention) {
      return Container(
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            padding: const EdgeInsets.all(10),
            children: extWidgetList,
          ));
    } else if (currentInputStatus == InputBarStatus.Emoji) {
      return Container(height: WSRCLayout.ExtentionLayoutWidth, child: _buildEmojiList());
    } else {
      if (currentInputStatus == InputBarStatus.Voice) {
        bottomInputBar.refreshUI();
      }
      return WidgetUtil.buildEmptyWidget();
    }
  }

  List emojiList = []; // emoji 数组

  GridView _buildEmojiList() {
    return GridView(
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: MediaQuery.of(context).size.width / 8,
      ),
      children: List.generate(
        emojiList.length,
        (index) {
          return GestureDetector(
            onTap: () {
              bottomInputBar.setTextContent(emojiList[index]);
            },
            child: Center(
              widthFactor: MediaQuery.of(context).size.width / 8,
              heightFactor: MediaQuery.of(context).size.width / 8,
              child: Text(emojiList[index], style: TextStyle(fontSize: 25)),
            ),
          );
        },
      ),
    );
  }

  // 底部输入栏
  Widget _buildBottomInputBar() {
    if (multiSelect == true) {
      return bottomToolBar;
    } else {
      return bottomInputBar;
    }
  }

  @override
  void didTapDelete() {
    // 批量删除
    List<int> messageIds = List<int>.from(selectedMessageIds);
    multiSelect = false;
    // WSIMManager.getInstance().engine?.deleteMessages(messageIds, (int code) {
    //   if (code == 0) {
    //     selectedMessageIds.clear();
    //     onGetHistoryMessages();
    //     _refreshUI();
    //   }
    // });
  }

  @override
  void didTapExtentionButton() {}

  /// 消息转发
  @override
  void didTapForward() {}

  @override
  void inputStatusDidChange(InputBarStatus status) {
    currentInputStatus = status;
    bottomInputBar.refreshUI();
    _refreshUI();
  }

  /// 禁止随意调用 setState 接口刷新 UI，必须调用该接口刷新 UI
  void _refreshUI() {
    setState(() {});
  }

  void _showExtraCenterWidget(ConversationStatus status) {
    currentStatus = status;
    _refreshUI();
  }

  /// 编辑消息过程中
  @override
  void onTextChange(String text) {
    String currentType = '';
  }

  @override
  void willSendText(String text) async {
    controller.sendTextMessage(
      text,
      widget.user.userId,
      (code, message) {
        WSLogger.debug('onMessageSent: $code, $message');
      },
    );
  }

  @override
  void willSendVoice(dynamic message) {
    // insertOrReplaceMessage(message);
  }

  @override
  void willStartRecordVoice() {
    _showExtraCenterWidget(ConversationStatus.VoiceRecorder);
  }

  @override
  void willStopRecordVoice() {
    _showExtraCenterWidget(ConversationStatus.Normal);
  }

  _buildExtraCenterWidget() {
  }

  @override
  void didLongPressMessageItem(dynamic message, Offset tapPos) {
    Map<String, String> actionMap = {
      WSRCLongPressAction.DeleteKey: WSRCLongPressAction.DeleteValue,
    };
    actionMap[WSRCLongPressAction.MutiSelectKey] = WSRCLongPressAction.MutiSelectValue;

    WidgetUtil.showLongPressMenu(context, tapPos, actionMap, (String key) {
      if (key == WSRCLongPressAction.DeleteKey) {
        _deleteMessage(message);
      } else if (key == WSRCLongPressAction.RecallKey) {
        _recallMessage(message);
      } else if (key == WSRCLongPressAction.MutiSelectKey) {
        multiSelect = true;
        currentInputStatus = InputBarStatus.Normal;
        _refreshMessageContentListUI();
        _refreshUI();
      } else if (key == WSRCLongPressAction.ReferenceKey) {
        bottomInputBar.makeReferenceMessage(message);
      }
      WSLogger.debug("name: $pageName  showLongPressMenu $key");
    });
  }

  void _recallMessage(dynamic message) async {
  }

  void _insertOrReplaceMessage(dynamic message) {
    int index = -1;
    //如果数据源中相同 id 消息，那么更新对应消息，否则插入消息
    if (index >= 0) {
      messageDataSource[index] = message;
      messageContentList.refreshItem(message);
    } else {
      messageDataSource.insert(0, message);
      _refreshMessageContentListUI();
    }
  }

  void _deleteMessage(dynamic message) {
    //删除消息完成需要刷新消息数据源
  }

  bool isFirstGetHistoryMessages = true;

  /// 已读回执
  void _sendReadReceipt() async {
  }

  @override
  void didLongPressUserPortrait(String userId, Offset tapPos) {
  }

  /// 请求已读回执
  @override
  void didSendMessageRequest(dynamic message) {
    WSLogger.debug("didSendMessageRequest $message  $pageName");
    // WSIMManager().engine?.sendPrivateReadReceiptMessage(message.targetId, channelId, timestamp)
    // RongIMClient.sendReadReceiptRequest(message, (int code) {
    //   if (0 == code) {
    //     developer.log("sendReadReceiptRequest success", name: pageName);
    //     onGetHistoryMessages();
    //   } else {
    //     developer.log("sendReadReceiptRequest error", name: pageName);
    //   }
    // });
  }

  @override
  void didTapItem(dynamic message) {
    if (multiSelect) {
      final alreadySaved = selectedMessageIds.contains(message.messageId);
      if (alreadySaved) {
        selectedMessageIds.remove(message.messageId);
      } else {
        selectedMessageIds.add(message.messageId);
      }
    }
  }

  @override
  void didTapMessageItem(dynamic message) {
    WSLogger.debug('wa_conversation_view didTapMessageItem  $message');
    // 点击消息，进行不同操作
  }

  @override
  void didTapMessageReadInfo(dynamic message) {
    WSLogger.debug('didTapMessageReadInfo');
  }

  @override
  void didTapReSendMessage(dynamic message) {
  }

  @override
  void didTapUserPortrait(String userId) {
    WSLogger.debug('didTapUserPortrait');
  }

  @override
  void willpullMoreHistoryMessage() {
    _pullMoreHistoryMessage();
  }

  Future<void> _pullMoreHistoryMessage() async {
    //todo 加载更多历史消息
    int messageId = -1;
  }

  void _refreshMessageContentListUI() {
    messageContentList.updateData(messageDataSource, multiSelect, selectedMessageIds);
  }

  /// 加载历史消息
  Future onLoadMoreHistoryMessages(int messageId) async {
    // List msgs = await RongIMClient.getHistoryMessage(conversationType, targetId, messageId, 20);
    // if (msgs != null) {
    //   msgs.sort((a, b) => b.sentTime.compareTo(a.sentTime));
    //   messageDataSource += msgs;
    //   if (msgs.length < 20) {
    //     RCIMIWMessage tempMessage = messageDataSource.last;
    //     recordTime = tempMessage.sentTime;
    //     onLoadRemoteHistoryMessages();
    //   }
    // }
    // _refreshMessageContentListUI();
  }
}

enum ConversationStatus {
  Normal, //正常
  VoiceRecorder, //语音输入，页面中间回弹出录音的 gif
}
