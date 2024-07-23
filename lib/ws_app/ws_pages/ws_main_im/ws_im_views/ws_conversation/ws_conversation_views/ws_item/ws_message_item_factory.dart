import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/ws_media_util.dart';
import 'dart:convert';
import 'dart:typed_data';
import '../../util/ws_style.dart';
import 'dart:developer' as developer;

class WSMessageItemFactory extends StatelessWidget {
  final String pageName = "example.MessageItemFactory";
  final dynamic message;
  final bool needShow;

  const WSMessageItemFactory({Key? key, required this.message, this.needShow = true}) : super(key: key);

  ///文本消息 item
  Widget textMessageItem(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    dynamic msg = message as dynamic;
    return Container(
      constraints: BoxConstraints(
        // 屏幕宽度减去头像宽度加上间距
        maxWidth: screenWidth - 150,
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        needShow ? msg.text! : "Click to view",
        style: const TextStyle(fontSize: 14, color: Color(0xFF202020)),
      ),
    );
  }

  ///图片消息 item
  ///优先读缩略图，否则读本地路径图，否则读网络图
  Widget imageMessageItem(BuildContext context) {
    dynamic msg = message as dynamic;

    Widget widget;
    if (needShow) {
      if (msg.thumbnailBase64String != null) {
        Uint8List bytes = base64.decode(msg.thumbnailBase64String!);
        widget = Image.memory(bytes);
        if (msg.local == null) {
          // RongIMClient.downloadMediaMessage(message);
        }
      } else {
        if (msg.local != null) {
          String path = WSMediaUtil.instance.getCorrectedLocalPath(msg.local!);
          File file = File(path);
          if (file.existsSync()) {
            widget = Image.file(file);
          } else {
            // RongIMClient.downloadMediaMessage(message);
            // widget = Image.network(msg.imageUri);
            widget = CachedNetworkImage(
              progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(
                value: progress.progress,
              ),
              imageUrl: msg.remote!,
            );
          }
        } else {
          // RongIMClient.downloadMediaMessage(message);
          widget = CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(
              value: progress.progress,
            ),
            imageUrl: msg.remote!,
          );
        }
      }
    } else {
      widget = Stack(
        children: <Widget>[
          // Image.asset(
          //   message.direction == RCIMIWMessageDirection.send
          //       ? "assets/images/burnPicture.png"
          //       : "assets/images/burnPictureForm.png",
          //   width: 120,
          //   height: 126,
          // ),
          Container(
            height: 126,
            width: 120,
            alignment: Alignment.bottomCenter,
            child: const Text("Click to view"),
          )
        ],
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width - 150,
      ),
      child: widget,
    );
  }

  ///动图消息 item
  Widget gifMessageItem(BuildContext context) {
    // RCIMIWGIFMessage msg = message as RCIMIWGIFMessage;
    Widget? widget;
    // if (needShow) {
    //   if (msg.local != null) {
    //     String path = WSMediaUtil.instance.getCorrectedLocalPath(msg.local!);
    //     File file = File(path);
    //     if (file.existsSync()) {
    //       widget = Image.file(file);
    //     } else {
    //       // 没有 localPath 时下载该媒体消息，更新 localPath
    //       // RongIMClient.downloadMediaMessage(message);
    //       widget = Image.network(
    //         msg.remote!,
    //         fit: BoxFit.cover,
    //         loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    //           if (loadingProgress == null) return child;
    //           return Center(
    //             child: CircularProgressIndicator(
    //               value: loadingProgress.expectedTotalBytes != null
    //                   ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 0)
    //                   : null,
    //             ),
    //           );
    //         },
    //       );
    //     }
    //   } else if (msg.remote != null) {
    //     // RongIMClient.downloadMediaMessage(message);
    //     widget = Image.network(
    //       msg.remote!,
    //       fit: BoxFit.cover,
    //       loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    //         if (loadingProgress == null) return child;
    //         return Center(
    //           child: CircularProgressIndicator(
    //             value: loadingProgress.expectedTotalBytes != null
    //                 ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 0)
    //                 : null,
    //           ),
    //         );
    //       },
    //     );
    //   } else {
    //     developer.log("GifMessage localPath && remoteUrl is null", name: pageName);
    //   }
    //
    //   double screenWidth = MediaQuery.of(context).size.width;
    //   if (msg.width != null &&
    //       msg.height != null &&
    //       msg.width! > 0 &&
    //       msg.height! > 0 &&
    //       msg.width! > screenWidth / 3) {
    //     return Container(
    //       width: msg.width!.toDouble() / 3,
    //       height: msg.height!.toDouble() / 3,
    //       child: widget,
    //     );
    //   }
    // } else {
    //   widget = Stack(
    //     children: <Widget>[
    //       Image.asset(
    //         message.direction == RCIMIWMessageDirection.send
    //             ? "assets/images/burnPicture.png"
    //             : "assets/images/burnPictureForm.png",
    //         width: 120,
    //         height: 126,
    //       ),
    //       Container(
    //         height: 126,
    //         width: 120,
    //         alignment: Alignment.bottomCenter,
    //         child: const Text("Click to view"),
    //       )
    //     ],
    //   );
    // }
    return widget!;
  }

  ///语音消息 item
  Widget voiceMessageItem() {
    // RCIMIWVoiceMessage msg = message as RCIMIWVoiceMessage;
    // List<Widget> list = [];
    // if (message.direction == RCIMIWMessageDirection.send) {
    //   list.add(const SizedBox(width: 6));
    //   list.add(Text(
    //     msg.duration.toString() + "''",
    //     style: TextStyle(fontSize: WSRCFont.MessageTextFont),
    //   ));
    //   list.add(const SizedBox(width: 20));
    //   list.add(Container(
    //     width: 20,
    //     height: 20,
    //     child: Image.asset("assets/images/voice_icon.png"),
    //   ));
    // } else {
    //   list.add(const SizedBox(width: 6));
    //   list.add(Container(
    //     width: 20,
    //     height: 20,
    //     child: Image.asset("assets/images/voice_icon_reverse.png"),
    //   ));
    //   list.add(const SizedBox(width: 20));
    //   list.add(Text(msg.duration.toString() + "''"));
    // }

    return Container(
      width: 80,
      height: 44,
      // child: Row(children: list),
    );
  }

  //小视频消息 item
  Widget sightMessageItem() {
    return Container();
    // RCIMIWSightMessage msg = message as RCIMIWSightMessage;

    // if (needShow) {
    //   Widget previewW = Container(); //缩略图
    //   if (msg.thumbnailBase64String != null) {
    //     Uint8List bytes = base64.decode(msg.thumbnailBase64String!);
    //     previewW = Image.memory(
    //       bytes,
    //       fit: BoxFit.fill,
    //     );
    //   }
    //   Widget bgWidget = Container(
    //     width: 100,
    //     height: 150,
    //     child: previewW,
    //   );
    //   Widget continerW = Container(
    //       width: 100,
    //       height: 150,
    //       child: Container(
    //         width: 50,
    //         height: 50,
    //         alignment: Alignment.center,
    //         child: Image.asset(
    //           "assets/images/sight_message_icon.png",
    //           width: 50,
    //           height: 50,
    //         ),
    //       ));
    //   Widget timeW = Container(
    //     width: 100,
    //     height: 150,
    //     child: Container(
    //       width: 50,
    //       height: 20,
    //       alignment: Alignment.bottomLeft,
    //       child: Row(
    //         children: <Widget>[
    //           const SizedBox(width: 5),
    //           Text(
    //             "${msg.duration}'s",
    //             style: const TextStyle(color: Colors.white),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    //   return Stack(
    //     children: <Widget>[
    //       bgWidget,
    //       continerW,
    //       timeW,
    //     ],
    //   );
    // } else {
    //   return Stack(
    //     children: <Widget>[
    //       Image.asset(
    //         message.direction == RCIMIWMessageDirection.send
    //             ? "assets/images/burnPicture.png"
    //             : "assets/images/burnPictureForm.png",
    //         width: 120,
    //         height: 126,
    //       ),
    //       Container(
    //         height: 126,
    //         width: 120,
    //         alignment: Alignment.bottomCenter,
    //         child: const Text("Click to Play"),
    //       )
    //     ],
    //   );
    // }
  }

  Widget fileMessageItem(BuildContext context) {
    return Container();
    // RCIMIWFileMessage fileMessage = message as RCIMIWFileMessage;
    // double screenWidth = MediaQuery.of(context).size.width;
    // return Container(
    //     height: (screenWidth - 140) / 3,
    //     width: screenWidth - 140,
    //     child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    //       Container(
    //         margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
    //         child: Image.asset(WSFileUtil.fileTypeImagePath(fileMessage.name!), width: 50, height: 50),
    //       ),
    //       Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.end,
    //         children: <Widget>[
    //           Container(
    //             width: screenWidth - 220,
    //             child: Text(
    //               fileMessage.name ?? '',
    //               textWidthBasis: TextWidthBasis.parent,
    //               softWrap: true,
    //               overflow: TextOverflow.ellipsis,
    //               maxLines: 2,
    //               style: const TextStyle(fontSize: 16, color: Color(0xff000000)),
    //             ),
    //           ),
    //           Container(
    //               margin: const EdgeInsets.only(top: 8),
    //               width: screenWidth - 220,
    //               child: Text(
    //                 WSFileUtil.formatFileSize(fileMessage.size!),
    //                 style: const TextStyle(fontSize: 12, color: Color(0xff888888)),
    //               ))
    //         ],
    //       )
    //     ]));
  }

  ///图文消息 item
  Widget richContentMessageItem(BuildContext context) {
    return Container(
      child: Text('richContentMessageItem'),
    );
    // RichContentMessage msg = message.content;
    // double screenWidth = MediaQuery.of(context).size.width;
    // return Container(
    //   width: screenWidth - 140,
    //   child: Column(children: <Widget>[
    //     Container(
    //       padding: EdgeInsets.all(10),
    //       child: Text(
    //         msg.title,
    //         style: new TextStyle(color: Colors.black, fontSize: 15),
    //         overflow: TextOverflow.ellipsis,
    //         maxLines: 2,
    //       ),
    //     ),
    //     Container(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: <Widget>[
    //           Container(
    //             padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
    //             width: screenWidth - 200,
    //             child: Text(
    //               msg.digest,
    //               style: new TextStyle(color: Colors.black, fontSize: 13),
    //               overflow: TextOverflow.ellipsis,
    //               maxLines: 3,
    //             ),
    //           ),
    //           Container(
    //             width: RCLayout.RichMessageImageSize,
    //             height: RCLayout.RichMessageImageSize,
    //             child: msg.imageURL == null || msg.imageURL.isEmpty
    //                 ? Image.asset("assets/images/rich_content_msg_default.png")
    //                 : Image.network(msg.imageURL),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ]),
    // );
  }

  // 合并消息 item
  Widget combineMessageItem(BuildContext context) {
    // CombineMessage msg = message.content;
    // if (msg.localPath != null && msg.localPath.isNotEmpty) {
    //   String path = MediaUtil.instance.getCorrectedLocalPath(msg.localPath);
    //   File file = File(path);
    //   if (file != null && file.existsSync()) {
    //   } else {
    //     // HttpUtil.download(url, savePath, progressCallback)
    //     CombineMessageUtils().downLoadHtml(msg.mMediaUrl);
    //   }
    // } else {
    //   CombineMessageUtils().downLoadHtml(msg.mMediaUrl);
    // }
    double screenWidth = MediaQuery.of(context).size.width;
    // List<String> summaryList = msg.summaryList;
    // String title = CombineMessageUtils().getTitle(msg);
    // String summaryStr = "";
    // if (summaryList != null) {
    //   for (int i = 0; i < summaryList.length && i < 4; i++) {
    //     if (i == 0) {
    //       summaryStr = summaryList[i];
    //     } else {
    //       summaryStr += "\n" + summaryList[i];
    //     }
    //   }
    // }
    return Container(
        width: screenWidth - 200,
        child: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(10, 4, 10, 0),
            alignment: Alignment.centerLeft,
            child: const Text('title',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: WSRCFont.MessageCombineTitleFont, color: Colors.black)),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
            alignment: Alignment.centerLeft,
            child: const Text('summaryStr',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: WSRCFont.MessageCombineContentFont, color: Color(WSRCColor.ConCombineMsgContentColor))),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            width: double.infinity,
            height: 1.0,
            color: const Color(0xFFF3F3F3),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 6, 0, 10),
            alignment: Alignment.centerLeft,
            child: const Text(RCString.ChatRecord,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: WSRCFont.MessageCombineContentFont, color: Color(WSRCColor.ConCombineMsgContentColor))),
          ),
        ]));
  }

  // 引用消息 item
  Widget referenceMessageItem(BuildContext context) {
    return Container();
    // RCIMIWReferenceMessage msg = message as RCIMIWReferenceMessage;
    // double screenWidth = MediaQuery.of(context).size.width;
    // return Container(
    //     width: screenWidth - 140,
    //     child: Column(children: <Widget>[
    //       Container(
    //         padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
    //         alignment: Alignment.centerLeft,
    //         child: referenceWidget(msg),
    //       ),
    //       Container(
    //         margin: const EdgeInsets.fromLTRB(10, 4, 10, 0),
    //         width: double.infinity,
    //         height: 1.0,
    //         color: const Color(0xFFF3F3F3),
    //       ),
    //       Container(
    //         margin: const EdgeInsets.fromLTRB(10, 4, 10, 10),
    //         alignment: Alignment.centerLeft,
    //         child: Text(msg.toString(),
    //             textAlign: TextAlign.left,
    //             style: const TextStyle(fontSize: WSRCFont.MessageReferenceTitleFont, color: Colors.black)),
    //       ),
    //     ]));
  }

  // 被引用的消息 UI
  Widget referenceWidget(dynamic msg) {
    // if (msg is RCIMIWTextMessage) {
    //   RCIMIWTextMessage textMessage = msg as RCIMIWTextMessage;
    //   return Text("${msg.referenceMessage?.messageId}:\n\n${textMessage.toString()}",
    //       textAlign: TextAlign.left,
    //       style: const TextStyle(
    //           fontSize: WSRCFont.MessageReferenceContentFont, color: Color(WSRCColor.ConReferenceMsgContentColor)));
    // } else if (msg is RCIMIWImageMessage) {
    //   RCIMIWImageMessage imageMessage = msg as RCIMIWImageMessage;
    //   Widget widget;
    //   if (imageMessage.thumbnailBase64String != null) {
    //     Uint8List bytes = base64.decode(imageMessage.thumbnailBase64String!);
    //     widget = Image.memory(bytes);
    //   } else {
    //     if (imageMessage.local != null) {
    //       String path = WSMediaUtil.instance.getCorrectedLocalPath(imageMessage.local!);
    //       File file = File(path);
    //       if (file.existsSync()) {
    //         widget = Image.file(file);
    //       } else {
    //         // widget = Image.network(msg.imageUri);
    //         widget = CachedNetworkImage(
    //           progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(
    //             value: progress.progress,
    //           ),
    //           imageUrl: imageMessage.remote!,
    //         );
    //       }
    //     } else {
    //       // widget = Image.network(msg.imageUri);
    //       widget = CachedNetworkImage(
    //         progressIndicatorBuilder: (context, url, progress) => CircularProgressIndicator(
    //           value: progress.progress,
    //         ),
    //         imageUrl: imageMessage.remote!,
    //       );
    //     }
    //   }
    //   return widget;
    // } else if (msg is RCIMIWFileMessage) {
    //   RCIMIWFileMessage fileMessage = msg as RCIMIWFileMessage;
    //   return Text("${msg.referenceMessage?.messageId}:\n\n[File] ${fileMessage.name}",
    //       textAlign: TextAlign.left,
    //       style: const TextStyle(
    //           fontSize: WSRCFont.MessageReferenceContentFont, color: Color(WSRCColor.ConReferenceMsgContentColor)));
    // }
    // // else if (msg.referMsg is RichContentMessage) {
    // //   RichContentMessage richContentMessage = msg.referMsg;
    // //   return Text("${msg.referMsgUserId}:\n\n[图文] ${richContentMessage.title}",
    // //       textAlign: TextAlign.left,
    // //       style: TextStyle(
    // //           fontSize: RCFont.MessageReferenceContentFont,
    // //           color: Color(RCColor.ConReferenceMsgContentColor)));
    // // }
    return Container();
  }

  Widget messageItem(BuildContext context) {
    // if (message is RCIMIWTextMessage) {
    //   return textMessageItem(context);
    // } else if (message is RCIMIWImageMessage) {
    //   return imageMessageItem(context);
    // } else if (message is RCIMIWVoiceMessage) {
    //   return voiceMessageItem();
    // } else if (message is RCIMIWSightMessage) {
    //   return sightMessageItem();
    // } else if (message is RCIMIWFileMessage) {
    //   return fileMessageItem(context);
    // }
    // // else if (message is RichContentMessage) {
    // //   return richContentMessageItem(context);
    // // }
    // else if (message is RCIMIWGIFMessage) {
    //   return gifMessageItem(context);
    // }
    // // else if (message is CombineMessage) {
    // //   return combineMessageItem(context);
    // // }
    // else if (message is RCIMIWReferenceMessage) {
    //   return referenceMessageItem(context);
    // }
    // else if (message is RCIMIWLocationMessage) {
    //   return Text("位置消息 " + message.objectName);
    // }
    // else if (message.content is GroupNotificationMessage) {
    //   GroupNotificationMessage groupNotificationMessage = message.content;
    //   return Text(
    //       "群通知消息 ${groupNotificationMessage.operatorUserId} ${groupNotificationMessage.operation} ${groupNotificationMessage.data}");
    // }
    // else {
      return Text("Unrecognized message $message");
    // }
  }

  Color _getMessageWidgetBGColor(dynamic messageDirection) {
    Color color = const Color(WSRCColor.MessageSendBgColor);
    // if (message.direction == RCIMIWMessageDirection.receive) {
    //   color = const Color(WSRCColor.MessageReceiveBgColor);
    // }
    return color;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container();
    // return StatefulBuilder(
    //   builder: (context, setState) {
    //     void translate() async {
    //       String? txt = await WSGoogleUtil.translate((message as RCIMIWTextMessage).text!);
    //       message.extra = txt;
    //       setState(() {});
    //     }
    //
    //     bool autoTranslate = WSSharedPreferencesUtil().prefs.getBool(WSAppConst.keyAutoTranslate) ?? false;
    //     if (autoTranslate && message.direction == RCIMIWMessageDirection.receive && message is RCIMIWTextMessage) {
    //       translate();
    //     }
    //     return Row(
    //       children: [
    //         Container(
    //           color: _getMessageWidgetBGColor(message.direction!),
    //           child: (message.extra != null && message.extra!.isNotEmpty) ? translateWidget(context) : messageItem(context),
    //         ),
    //         message.direction == RCIMIWMessageDirection.receive && message is RCIMIWTextMessage
    //             ? GestureDetector(
    //                 onTap: () async {
    //                   translate();
    //                 },
    //                 child: Container(
    //                   padding: EdgeInsets.only(left: 10.w),
    //                   child: SvgPicture.asset('assets/svg/im_translate.svg'),
    //                 ),
    //               )
    //             : Container()
    //       ],
    //     );
    //   },
    // );
  }

  Widget translateWidget(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // messageItem(context),
        Container(
          constraints: BoxConstraints(
            // 屏幕宽度减去头像宽度加上间距
            maxWidth: screenWidth - 150,
          ),
          margin: const EdgeInsets.only(left: 6, right: 6),
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 8, right: 8
          ),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color(0xFFCCCCCC), // Set the color of the border
                width: 1.0, // Set the width of the border
              ),
            ),
          ),
          child: Text(
            'message.extra!',
            softWrap: true,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}
