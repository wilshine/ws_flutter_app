import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/ws_conversation_controllers/ws_conversation_controller.dart';
import 'package:ws_flutter_app/ws_utils/ws_log/ws_logger.dart';

class IMRecordingInput extends StatefulWidget {
  @override
  _IMRecordingInputState createState() => _IMRecordingInputState();
}

class _IMRecordingInputState extends State<IMRecordingInput> {
  final double _maxUpDistance = 15.0;
  double? _startDy;
  Function? _cancle;

  void _onPanUpdate(DragUpdateDetails details) {
    if (_startDy == null) {
      _startDy = details.localPosition.dy;
      setCanSendAudio(true);
    }
    final distance = _startDy! - details.localPosition.dy;
    if (distance > _maxUpDistance) {
      setCanSendAudio(false);
    } else {
      setCanSendAudio(true);
    }
  }

  /// 按下，开始录音
  void _onPanDown(DragDownDetails detail) {
    setCanSendAudio(true);
    Get.find<WSConversationController>().startRecord();
  }

  /// 松开，结束录音
  void _onPanEnd([DragEndDetails? details]) {
    if (Get.find<WSConversationController>().canSendAudio.value) {
      WSLogger.debug('IM stopRecord');
      Get.find<WSConversationController>().stopRecord();
      // Provider.of<IMAudioModel>(context, listen: false).stopRecord();
    } else {
      WSLogger.debug('IM cancelRecord');
      // Provider.of<IMAudioModel>(context, listen: false).cancleRecord();
      Get.find<WSConversationController>().cancelRecord();
    }
    _startDy = null;
    if (_cancle != null) {
      _cancle!();
      _cancle = null;
    }
    Get.find<WSConversationController>().canSendAudio.value = false;
  }

  /// 设置是否可以发送语音
  void setCanSendAudio(bool canSendAudio) {
    Get.find<WSConversationController>().canSendAudio.value = canSendAudio;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: _onPanUpdate,
        onPanDown: _onPanDown,
        onPanCancel: _onPanEnd,
        onPanEnd: _onPanEnd,
        child: Container(
          height: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: const Color.fromRGBO(49, 69, 106, 0.10), width: 1 / MediaQuery.of(context).devicePixelRatio),
            color: const Color(0xFFF1F2F4),
          ),
          alignment: Alignment.center,
          // child: const Text(RCString.BottomTapSpeak, textAlign: TextAlign.center),
          child: Obx(() {
            return Text(
              Get.find<WSConversationController>().isRecording.value ? 'Release Send' : 'Hold to talk',
              style: const TextStyle(color: Color(0xFF31456A), fontSize: 15),
            );
          }),
        ));
  }
}

/// 录音状态视图
class RecordStatusView extends StatefulWidget {
  final Function? cancle;

  RecordStatusView({this.cancle});

  @override
  _RecordStatusViewState createState() => _RecordStatusViewState();
}

class _RecordStatusViewState extends State<RecordStatusView> {
  int _second = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(milliseconds: 1000), (t) {
      if (_second == 59) {
        t.cancel(); // 定时器内部触发销毁
        widget.cancle?.call();
        _timer = null;
      } else {
        setState(() {
          _second++;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        bool canSendAudio = Get.find<WSConversationController>().canSendAudio.value;
        Widget child = Container(
          child: Center(
            child: Container(
              width: 200,
              height: 200,
              // padding: const EdgeInsets.fromLTRB(20, 27, 20, 24),
              child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                // if (canSendAudio)
                //   Text(
                //     "$_second''",
                //     style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                //   ),
                Container(
                  height: 84.h,
                  child: canSendAudio
                      ? Container(width: 128.w, child: SVGASimpleImage(assetsName: 'assets/svg/record_voice_start.svga'))
                      : Image(
                          width: 128.w,
                          image: AssetImage('assets/webp/record_voice_cancel.webp'),
                          fit: BoxFit.contain,
                        ),
                ),
                // Image(
                //   width: 128.w,
                //   image: AssetImage(
                //       canSendAudio ? 'assets/webp/record_voice_start.webp' : 'assets/webp/record_voice_cancel.webp'),
                //   fit: BoxFit.contain,
                // ),
                Container(height: 56),
                Text(
                  canSendAudio ? 'Release Send' : 'Release Cancel',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                  ),
                ),
              ]),
            ),
          ),
        );
        Widget bottomContainer = CustomPaint(
          painter: _WSArcPainter(),
          child: Container(
            alignment: Alignment.center,
            height: 158.h,
            child: Image.asset(
              !canSendAudio ? 'assets/webp/record_bottom_cancel.webp' : 'assets/webp/record_bottom_start.webp',
              width: 62.w,
              height: 62.h,
            ),
          ),
        );
        return Container(
          color: const Color(0x99000000),
          child: DefaultTextStyle(
            style: const TextStyle(inherit: false),
            child: Stack(children: [
              child,
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: bottomContainer,
              ),
              Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'hold and talk',
                        style: TextStyle(color: Colors.black),
                      ))),
            ]),
          ),
        );
      },
    );
  }
}

class _WSArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height) // Start at the bottom-left corner
      ..lineTo(0, size.height - 128.h) // Move up by 100 pixels
      ..quadraticBezierTo(
          size.width / 2, size.height - 158.h, size.width, size.height - 128.h) // Draw a quadratic bezier curve
      ..lineTo(size.width, size.height) // Draw a line to the bottom-right corner
      ..close(); // Close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
