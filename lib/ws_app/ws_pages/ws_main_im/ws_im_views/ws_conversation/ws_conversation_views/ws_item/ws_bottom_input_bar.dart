import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ws_flutter_app/ws_app/ws_models/ws_user_model.dart';
import 'package:common_ui/common_ui.dart';

import '../../util/ws_style.dart';
import '../../util/ws_user_info_datesource.dart' as example;
import 'dart:developer' as developer;

/// 会话页底部输入栏
class WSBottomInputBar extends StatefulWidget {
  final WSBottomInputBarDelegate delegate;
  late _WSBottomInputBarState state;

  WSBottomInputBar({required this.delegate});

  @override
  _WSBottomInputBarState createState() => state = _WSBottomInputBarState();

  void setTextContent(String textContent) {
    state.setText(textContent);
  }

  void refreshUI() {
    state._refreshUI();
  }

  void makeReferenceMessage(dynamic message) {
    state.makeReferenceMessage(message);
  }

  dynamic getReferenceMessage() {
    return state.referenceMessage!;
  }

  void clearReferenceMessage() {
    state.clearReferenceMessage();
  }
}

class _WSBottomInputBarState extends State<WSBottomInputBar> {
  String pageName = "example.BottomInputBar";

  /// 输入框
  late ExtendedTextField textField;
  FocusNode focusNode = FocusNode();

  late InputBarStatus inputBarStatus;
  late TextEditingController textEditingController;

  dynamic message;

  dynamic referenceMessage;

  late WSUserModel referenceUserInfo;

  _WSBottomInputBarState() {
    OutlineInputBorder inputBorder = OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(
            width: 1 / Get.context!.devicePixelRatio,
            style: BorderStyle.solid,
            color: const Color.fromRGBO(49, 69, 106, 0.10)));

    inputBarStatus = InputBarStatus.Normal;
    textEditingController = TextEditingController();

    textField = ExtendedTextField(
      onSubmitted: _clickSendMessage,
      controller: textEditingController,
      decoration: InputDecoration(
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        hintText: RCString.BottomInputTextHint,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: Color(0x9931456A),
        ),
        isDense: true,
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      ),
      focusNode: focusNode,
      autofocus: true,
      maxLines: 5,
      minLines: 1,
      cursorColor: const Color(0xFF006BE1),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.send,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF31456A),
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
    );
  }

  void setText(String textContent) {
    textEditingController.text = textEditingController.text + textContent;
    textEditingController.selection =
        TextSelection.fromPosition(TextPosition(offset: textEditingController.text.length));
    _refreshUI();
  }

  void _refreshUI() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      //获取输入的值
      widget.delegate.onTextChange(textEditingController.text);
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        _notifyInputStatusChanged(InputBarStatus.Normal);
      }
    });
  }

  void _clickSendMessage(String messageStr) {
    if (messageStr.isEmpty) {
      developer.log("clickSendMessage MessageStr not null", name: pageName);
      return;
    }
    widget.delegate.willSendText(messageStr);
    textField.controller?.text = '';
  }

  void switchPhrases() {
    developer.log("switchPhrases", name: pageName);
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    InputBarStatus status = InputBarStatus.Normal;
    _notifyInputStatusChanged(status);
  }

  void switchVoice() {
    developer.log("switchVoice", name: pageName);
    InputBarStatus status = InputBarStatus.Normal;
    if (inputBarStatus != InputBarStatus.Voice) {
      status = InputBarStatus.Voice;
    }
    _notifyInputStatusChanged(status);
  }

  switchEmoji() {
    developer.log("switchEmoji", name: pageName);
    InputBarStatus status = InputBarStatus.Normal;
    if (inputBarStatus != InputBarStatus.Emoji) {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
      status = InputBarStatus.Emoji;
    }
    _notifyInputStatusChanged(status);
  }

  void switchExtention() {
    developer.log("switchExtention", name: pageName);
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    InputBarStatus status = InputBarStatus.Normal;
    if (inputBarStatus != InputBarStatus.Extention) {
      status = InputBarStatus.Extention;
    }
    if (widget.delegate != null) {
      widget.delegate.didTapExtentionButton();
    } else {
      developer.log("no  BottomInputBarDelegate", name: pageName);
    }
    _notifyInputStatusChanged(status);
  }

  _onVoiceGesLongPress() {
    developer.log("_onVoiceGesLongPress", name: pageName);

    // MediaUtil.instance.startRecordAudio();
    widget.delegate.willStartRecordVoice();
  }

  _onVoiceGesLongPressEnd() {
    developer.log("_onVoiceGesLongPressEnd", name: pageName);

    widget.delegate.willStopRecordVoice();

    // MediaUtil.instance.stopRecordAudio((String path, int duration) {
    //   widget.delegate.willSendVoice(path, duration);
    // });
  }

  Widget _getMainInputField() {
    Widget widget = Container();
    if (inputBarStatus == InputBarStatus.Voice) {
      // widget = IMRecordingInput();
      // widget = Container(
      //   alignment: Alignment.center,
      //   color: Colors.white,
      //   child: GestureDetector(
      //     behavior: HitTestBehavior.opaque,
      //     child: const Text(RCString.BottomTapSpeak, textAlign: TextAlign.center),
      //     onLongPress: () {
      //       _onVoiceGesLongPress();
      //     },
      //     onLongPressEnd: (LongPressEndDetails details) {
      //       _onVoiceGesLongPressEnd();
      //     },
      //   ),
      // );
    } else {
      widget = Container(
        // padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.circular(4),
        // ),
        child: textField,
        // child: SingleChildScrollView(
        //   scrollDirection: Axis.vertical,
        //   reverse: true,
        //   child: textField,
        // ),
      );
    }
    return Container(
      height: 32,
      alignment: Alignment.centerLeft,
      child: widget,
    );
  }

  void _notifyInputStatusChanged(InputBarStatus status) {
    inputBarStatus = status;
    widget.delegate.inputStatusDidChange(status);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F7F8),
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          GestureDetector(
              onTap: () async {
                PermissionStatus status = await Permission.microphone.request();
                if (status != PermissionStatus.granted) {
                  WSToast.show("Grant permissions to the microphone first");
                  return;
                }
                switchVoice();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 10),
                child: SvgPicture.asset(
                  'assets/svg/mic.svg',
                  width: 32.w,
                  height: 32.h,
                ),
              )),
          Expanded(child: _getMainInputField()),
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                switchEmoji();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: SvgPicture.asset(
                  'assets/svg/mood.svg',
                  width: 32.w,
                  height: 32.h,
                ),
              )),
          GestureDetector(
            onTap: () {
              switchExtention();
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: Container(
                color: Colors.white,
                child: Image.asset(
                  'assets/webp/im_add.webp',
                  width: 32.w,
                  height: 32.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferenceWidget() {
    return IntrinsicHeight(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const VerticalDivider(
          color: Colors.grey,
          thickness: 3,
        ),
        Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          Container(
              margin: const EdgeInsets.only(top: 4, bottom: 2),
              child: Text(referenceUserInfo.userId,
                  style: const TextStyle(
                      fontSize: WSRCFont.BottomReferenceNameSize, color: Color(WSRCColor.BottomReferenceNameColor)))),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 60.0,
            ),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: false,
                child: GestureDetector(
                  child: _buildReferenceContent(),
                  onTap: () {
                    _clickContent();
                  },
                )),
          )
        ])),
        Container(
            margin: const EdgeInsets.only(right: 10),
            height: 30,
            width: 30,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                clearReferenceMessage();
              },
            ))
      ],
    ));
  }

  void _clickContent() {
    // if (referenceMessage.referMsg is ImageMessage) {
    //   // 引用的消息为图片时的点击事件
    //   Message tempMsg = message;
    //   tempMsg.content = referenceMessage.referMsg;
    //   Navigator.pushNamed(context, "/image_preview", arguments: tempMsg);
    // } else if (referenceMessage.referMsg is FileMessage) {
    //   // 引用的消息为文件时的点击事件
    //   Message tempMsg = message;
    //   tempMsg.content = referenceMessage.referMsg;
    //   Navigator.pushNamed(context, "/file_preview", arguments: tempMsg);
    // } else if (referenceMessage.referMsg is RichContentMessage) {
    //   // 引用的消息为图文时的点击事件
    //   RichContentMessage richContentMessage = referenceMessage.referMsg;
    //   Map param = {
    //     "url": richContentMessage.url,
    //     "title": richContentMessage.title
    //   };
    //   Navigator.pushNamed(context, "/webview", arguments: param);
    // } else {
    //   // 引用的消息为文本时的点击事件
    // }
  }

  Widget _buildReferenceContent() {
    return Container();
    // Widget widget = WidgetUtil.buildEmptyWidget();
    // MessageContent messageContent = referenceMessage.referMsg;
    // if (messageContent is TextMessage) {
    //   TextMessage textMessage = messageContent;
    //   widget = Text(textMessage.content,
    //       style: TextStyle(
    //           fontSize: RCFont.BottomReferenceContentSize,
    //           color: Color(RCColor.BottomReferenceContentColor)));
    // } else if (messageContent is ImageMessage) {
    //   ImageMessage imageMessage = messageContent;
    //   Widget imageWidget;
    //   if (imageMessage.content != null && imageMessage.content.length > 0) {
    //     Uint8List bytes = base64.decode(imageMessage.content);
    //     imageWidget = Image.memory(bytes);
    //   } else {
    //     if (imageMessage.localPath != null) {
    //       String path =
    //           MediaUtil.instance.getCorrectedLocalPath(imageMessage.localPath);
    //       File file = File(path);
    //       if (file != null && file.existsSync()) {
    //         imageWidget = Image.file(file);
    //       } else {
    //         imageWidget = CachedNetworkImage(
    //           progressIndicatorBuilder: (context, url, progress) =>
    //               CircularProgressIndicator(
    //             value: progress.progress,
    //           ),
    //           imageUrl: imageMessage.imageUri,
    //         );
    //       }
    //     } else {
    //       imageWidget = CachedNetworkImage(
    //         progressIndicatorBuilder: (context, url, progress) =>
    //             CircularProgressIndicator(
    //           value: progress.progress,
    //         ),
    //         imageUrl: imageMessage.imageUri,
    //       );
    //     }
    //   }
    //   widget = Container(
    //     constraints: BoxConstraints(
    //       maxWidth: MediaQuery.of(context).size.width - 150,
    //     ),
    //     child: imageWidget,
    //   );
    // } else if (messageContent is FileMessage) {
    //   FileMessage fileMessage = messageContent;
    //   widget = Text("[文件] ${fileMessage.mName}",
    //       style: TextStyle(
    //           fontSize: RCFont.BottomReferenceContentSize,
    //           color: Color(RCColor.BottomReferenceContentColorFile)));
    // } else if (messageContent is RichContentMessage) {
    //   RichContentMessage richContentMessage = messageContent;
    //   widget = Text("[图文] ${richContentMessage.title}",
    //       style: TextStyle(
    //           fontSize: RCFont.BottomReferenceContentSize,
    //           color: Color(RCColor.BottomReferenceContentColorFile)));
    // } else if (messageContent is ReferenceMessage) {
    //   ReferenceMessage referenceMessage = messageContent;
    //   widget = Text(referenceMessage.content,
    //       style: TextStyle(
    //           fontSize: RCFont.BottomReferenceContentSize,
    //           color: Color(RCColor.BottomReferenceContentColorFile)));
    // }
    // return widget;
  }

  void setInfo(String userId) {
    WSUserModel? userInfo = example.UserInfoDataSource.cachedUserMap[userId];
    if (userInfo != null) {
      referenceUserInfo = userInfo;
    } else {
      example.UserInfoDataSource.getUserInfo(userId).then((onValue) {
        setState(() {
          referenceUserInfo = onValue;
        });
      });
    }
  }

  void makeReferenceMessage(dynamic message) {
    // if (message != null) {
    //   this.message = message;
    //   referenceMessage = ReferenceMessage();
    //   referenceMessage.referMsgUserId = message.senderUserId;
    //   if (message.content is ReferenceMessage) {
    //     ReferenceMessage content = message.content;
    //     TextMessage textMessage = TextMessage.obtain(content.content);
    //     referenceMessage.referMsg = textMessage;
    //   } else {
    //     referenceMessage.referMsg = message.content;
    //   }
    //   setInfo(referenceMessage.referMsgUserId);
    // } else {
    //   referenceMessage = null;
    // }
    _refreshUI();
  }

  dynamic getReferenceMessage() {
    return referenceMessage!;
  }

  void clearReferenceMessage() {
    referenceMessage = null;
    message = null;
    _refreshUI();
  }
}

enum InputBarStatus {
  Normal, //正常
  Voice, //语音输入
  Extention, //扩展栏
  Emoji, // emoji输入
}

abstract class WSBottomInputBarDelegate {
  ///输入工具栏状态发生变更
  void inputStatusDidChange(InputBarStatus status);

  ///即将发送消息
  void willSendText(String text);

  ///即将发送语音
  void willSendVoice(dynamic message);

  ///即将开始录音
  void willStartRecordVoice();

  ///即将停止录音
  void willStopRecordVoice();

  ///点击了加号按钮
  void didTapExtentionButton();

  ///输入框内容变化监听
  void onTextChange(String text);
}
