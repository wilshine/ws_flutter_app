import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/util/ws_media_util.dart';

class ImagePreviewPage extends StatefulWidget {
  final dynamic message;

  const ImagePreviewPage({Key? key, required this.message}) : super(key: key);

  @override
  State<ImagePreviewPage> createState() {
    return _ImagePreviewPageState();
  }
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  _ImagePreviewPageState();

  //优先加载本地路径图片，否则加载网络图片
  Widget getImageWidget() {
    String? localPath;
    String? remoteUrl;
    // if (widget.message is RCIMIWGIFMessage) {
    //   RCIMIWGIFMessage msg = (widget.message as RCIMIWGIFMessage);
    //   localPath = msg.local;
    //   remoteUrl = msg.remote;
    // } else {
    //   RCIMIWImageMessage msg = (widget.message as RCIMIWImageMessage);
    //   localPath = msg.local;
    //   remoteUrl = msg.remote;
    // }

    Widget _widget;
    if (localPath != null) {
      String path = WSMediaUtil.instance.getCorrectedLocalPath(localPath);
      File file = File(path);
      if (file.existsSync()) {
        _widget = Image.file(file);
      } else {
        _widget = Image.network(
          remoteUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              ),
            );
          },
        );
      }
    } else {
      _widget = Image.network(
        remoteUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            ),
          );
        },
      );
    }
    return _widget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: const Text(
            "Image Preview",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              getImageWidget(),
              Container(
                  margin: const EdgeInsets.fromLTRB(40, 50, 40, 0),
                  width: double.infinity,
                  height: 60,
                  child: TextButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFFE6FF4E))),
                      onPressed: () {
                        // OpenFile.open((widget.message a).local);
                      },
                      child: const Text('Open', style: TextStyle(fontSize: 16, color: Color(0xFF202020))))),
            ],
          ),
        ));
  }
}
