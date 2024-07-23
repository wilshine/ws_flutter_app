import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/ws_conversation_views/ws_item/ws_widget_util.dart';
import 'package:ws_flutter_app/ws_utils/ws_file_util.dart';

class FilePreviewPage extends StatefulWidget {
  final dynamic message;

  const FilePreviewPage({Key? key, required this.message}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FilePreviewState();
  }
}

class _FilePreviewState extends State<FilePreviewPage> {
  static const int DOWNLOAD_SUCCESS = 0;
  static const int DOWNLOAD_PROGRESS = 10;
  static const int DOWNLOAD_CANCELED = 20;
  int currentStatus = -1;
  int? mProgress;

  @override
  Widget build(BuildContext context) {
    String fileStatuStr;
    if (currentStatus == DOWNLOAD_PROGRESS) {
      fileStatuStr = "Downloading...$mProgress%";
    } else {
      fileStatuStr = _isFileNeedDowload() ? "Open File" : "Start Download";
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 60),
                child: Image.asset(
                  WSFileUtil.fileTypeImagePath(widget.message.name ?? ''),
                  width: 70,
                  height: 70,
                )),
            Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(widget.message.name ?? '',
                    maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, color: const Color(0xff000000)))),
            Container(
                margin: EdgeInsets.only(top: 15),
                child: Text(WSFileUtil.formatFileSize(widget.message.size ?? 0),
                    style: TextStyle(fontSize: 12, color: const Color(0xff888888)))),
            getProgress(),
            Container(
                margin: EdgeInsets.fromLTRB(40, 50, 40, 0),
                width: double.infinity,
                height: 60,
                child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xff4876FF)),
                    ),
                    onPressed: () {
                      _fileButtonClick();
                    },
                    child: Text(fileStatuStr, style: TextStyle(fontSize: 16, color: const Color(0xFFFFFFFF))))),
          ]),
        ));
  }

  Widget getProgress() {
    if (currentStatus == DOWNLOAD_PROGRESS) {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        child: SizedBox(
          //限制进度条的高度
          height: 6.0,
          //限制进度条的宽度
          width: 300,
          child: LinearProgressIndicator(
              //0~1的浮点数，用来表示进度多少;如果 value 为 null 或空，则显示一个动画，否则显示一个定值
              value: (mProgress ?? 0) / 100,
              //背景颜色
              backgroundColor: const Color(0xff888888),
              //进度颜色
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue)),
        ),
      );
    }
    return WidgetUtil.buildEmptyWidget();
  }

  _refreshUI() {
    setState(() {});
  }

  _fileButtonClick() {
    if (!_isFileNeedDowload()) {
      _startDownload();
    } else {
      _openFile();
    }
  }

  void _startDownload() async {
    if (await Permission.storage.status == PermissionStatus.granted) {
      // WSIMManager.getInstance().engine?.downloadMediaMessage(widget.message,
      //     listener: RCIMIWDownloadMediaMessageListener(
      //       onMediaMessageDownloaded: (code, message) {
      //         WSLogger.debug('downloadMediaMessage======download code: ${message?.local}');
      //         if (widget.message.messageId == message?.messageId) {
      //           currentStatus = DOWNLOAD_SUCCESS;
      //           widget.message.local = message?.local;
      //           _refreshUI();
      //         }
      //       },
      //       onMediaMessageDownloading: (message, progress) {
      //         WSLogger.debug('downloadMediaMessage======download progress: $progress');
      //         currentStatus = DOWNLOAD_PROGRESS;
      //         mProgress = progress;
      //         _refreshUI();
      //       },
      //     ));
      // RongIMClient.downloadMediaMessage(message);
    } else {
      Permission.storage.request();
    }
  }

  void _openFile() {
    String path = handlePath(widget.message.local ?? '');
    OpenFile.open(path);
  }

  bool _isFileNeedDowload() {
    String localPath = widget.message.local ?? '';
    if (localPath.isNotEmpty) {
      File localFile = File(handlePath(localPath));
      bool isExists = localFile.existsSync();
      return isExists;
    }
    return false;
  }

  String handlePath(String path) {
    if (path.startsWith("file://")) {
      return path.replaceAll("file://", "");
    }
    return path;
  }
}
