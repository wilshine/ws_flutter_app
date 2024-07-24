import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ws_flutter_app/ws_utils/ws_file_util.dart';
import 'package:ws_flutter_app/ws_utils/ws_log/ws_logger.dart';
import 'package:common_ui/common_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

class WSAudioRecorder {
  factory WSAudioRecorder() => _getInstance();

  static WSAudioRecorder get instance => _getInstance();
  static WSAudioRecorder? _instance;

  WSAudioRecorder._internal();

  static WSAudioRecorder _getInstance() {
    _instance ??= WSAudioRecorder._internal();
    return _instance!;
  }

  FlutterSoundRecorder? _recorder;
  final Codec _codec = Codec.aacADTS;
  String _mPath = 'temp.aac';

  /// 录音时长
  Duration? duration;

  /// 初始化
  Future init() async {
    _recorder = FlutterSoundRecorder();
    await openTheRecorder();
  }

  /// 释放
  dispose() {
    _recorder?.closeRecorder();
    _recorder = null;
  }

  Future<void> openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      WSToast.show('Microphone permission not granted');
      return;
    }
    await _recorder?.openRecorder();
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth | AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy: AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _recorder?.dispositionStream()?.listen((event) {
      WSLogger.debug('debug dispositionStream：$event');
    });

    _recorder?.setSubscriptionDuration(const Duration(milliseconds: 100));
    _recorder?.onProgress?.listen((e) {
      WSLogger.debug("debug onProgress：${e.decibels} / ${e.duration}");
      duration = e.duration;
    });
    // _mRecorderIsInited = true;
  }

  void startRecord() async {
    if(_recorder == null) {
      await init();
    }
    if(_recorder?.recorderState == RecorderState.isRecording) {
      await _recorder?.stopRecorder();
      return;
    }
    WSLogger.debug("debug startRecord");
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      WSToast.show("Microphone permission not granted");
    } else {
      Directory tempDir = await getTemporaryDirectory();
      _mPath = "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.aac";
      _recorder?.startRecorder(
        toFile: _mPath,
        codec: _codec,
        audioSource: AudioSource.microphone,
      );

      WSLogger.debug("debug recording");
    }
  }

  /// 停止录音
  void stopRecord(Function(String path, int duration) finished) async {
    String? path = await _recorder?.stopRecorder();
    if (path == null) {
      WSToast.show('record failed');
      WSLogger.error('record failed  ${_recorder?.recorderState}');
      return;
    }
    if(!await WSFileUtil.isFileExists(path)) {
      WSToast.show('record failed');
      return;
    }
    if(duration != null && duration!.inSeconds < 1) {
      WSToast.show('recording can\'t be less than 1 second');
      return;
    }
    WSLogger.debug("Stop recording: path = $path，duration = ${duration?.inSeconds}");
    if (TargetPlatform.android == defaultTargetPlatform) {
      path = "file://$path";
    }
    finished(path, duration?.inSeconds ?? 0);
  }
}
