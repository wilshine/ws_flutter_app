import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/util/ws_media_util.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/ws_conversation_views/ws_conversation_view.dart';
import 'package:ws_flutter_app/ws_utils/ws_file_util.dart';
import 'package:ws_flutter_app/ws_utils/ws_log/ws_logger.dart';

class WSConversationController extends GetxController {
  /// 是否在录音
  final isRecording = false.obs;

  /// 是否可以发送音频
  final canSendAudio = false.obs;

  WSConversationViewState? state;

  WSConversationController(this.state);

  @override
  void onClose() {
    state = null;
    WSLogger.debug('WSConversationController onClose');
    super.onClose();
  }

  void startRecord() {
    isRecording.value = true;

    WSMediaUtil.instance.startRecordAudio();
  }

  void stopRecord() {
    isRecording.value = false;

    WSMediaUtil.instance.stopRecordAudio((String path, int duration) {
      WSLogger.debug('send voice msg  $path  $duration');
      sendVoiceMessage(
        path,
        state!.widget.user.userId,
        duration,
        (code, message) {
          state!.willSendVoice(message!);
        },
      );
    });
  }

  void cancelRecord() {
    isRecording.value = false;

    WSMediaUtil.instance.stopRecordAudio((path, duration) {
      WSFileUtil.remove(path);
    });
  }

  /// 发送文件消息
  void sendFileMessage(String path, String userId, [Function(int? code, dynamic message)? onMessageSent]) async {
    // RCIMIWFileMessage? message =
    //     await WSIMManager.getInstance().engine?.createFileMessage(RCIMIWConversationType.private, userId, null, path);
    // if (message == null) {
    //   WSLogger.error('send file message failed');
    //   return;
    // }
    // sendMessage(message, onMessageSent);
  }

  /// 发送图片消息
  void sendImageMessage(String path, String userId,
      [Function(int? code, dynamic message)? onMessageSent]) async {
    // RCIMIWImageMessage? message =
    //     await WSIMManager.getInstance().engine?.createImageMessage(RCIMIWConversationType.private, userId, null, path);
    // if (message == null) {
    //   WSLogger.error('send image message failed');
    //   return;
    // }
    // sendMessage(message, onMessageSent);
  }

  void sendGifMessage(String path, String userId, [Function(int? code, dynamic message)? onMessageSent]) async {
    // RCIMIWGIFMessage? message =
    //     await WSIMManager.getInstance().engine?.createGIFMessage(RCIMIWConversationType.private, userId, null, path);
    // if (message == null) {
    //   WSLogger.error('send gif message failed');
    //   return;
    // }
    // sendMessage(message, onMessageSent);
  }

  /// 发送语音消息
  void sendVoiceMessage(String path, String userId, int duration,
      [Function(int? code, dynamic message)? onMessageSent]) async {
    // RCIMIWVoiceMessage? message = await WSIMManager.getInstance()
    //     .engine
    //     ?.createVoiceMessage(RCIMIWConversationType.private, userId, null, path, duration);
    // if (message == null) {
    //   WSLogger.error('send voice message failed');
    //   return;
    // }
    // sendMessage(message, onMessageSent);
  }

  void sendMessage(dynamic message, [Function(int? code, dynamic message)? onMessageSent]) async {
    // await WSIMManager.getInstance().engine?.sendMessage(message, callback: RCIMIWSendMessageCallback(
    //   onMessageSent: (code, message) {
    //     WSLogger.debug('onMessageSent: $code, $message');
    //     onMessageSent?.call(code, message);
    //   },
    // ));
  }

  /// 发送文本消息
  void sendTextMessage(String text, String userId, [Function(int? code, dynamic message)? onMessageSent]) async {
    // RCIMIWTextMessage? message = await WSIMManager.getInstance().engine?.createTextMessage(
    //       RCIMIWConversationType.private,
    //       userId,
    //       null,
    //       text,
    //     );
    // if (message == null) {
    //   WSLogger.error('send text message failed');
    //   return;
    // }
    // sendMessage(message, onMessageSent);
  }
}
