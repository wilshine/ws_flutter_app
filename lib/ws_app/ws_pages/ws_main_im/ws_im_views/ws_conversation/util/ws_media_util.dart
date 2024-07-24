import 'dart:developer' as developer;
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:audio_session/audio_session.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:permission_handler/permission_handler.dart';
import 'package:ws_flutter_app/ws_utils/ws_audio_recorder.dart';
import 'package:ws_flutter_app/ws_utils/ws_auido_player.dart';
import 'package:common_ui/common_ui.dart';

///媒体工具，负责申请权限，选照片，拍照，录音，播放语音
class WSMediaUtil {
  String pageName = "example.MediaUtil";

  factory WSMediaUtil() => _getInstance();

  static WSMediaUtil get instance => _getInstance();
  static WSMediaUtil? _instance;

  WSMediaUtil._internal();

  static WSMediaUtil _getInstance() {
    _instance ??= WSMediaUtil._internal();
    return _instance!;
  }

  //请求权限：相册，相机，麦克风
  Future<void> requestPermissions() async {
    // Map<Permission, PermissionStatus> statuses =
    //     await [Permission.photos, Permission.camera, Permission.microphone, Permission.storage].request();
    // for (var status in statuses.keys) {
    //   developer.log("$status：${statuses[status]}", name: pageName);
    // }
  }

  //拍照，成功则返回照片的本地路径，注：Android 必须要加 file:// 头
  Future<String?> takePhoto() async {
    PermissionStatus status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      WSToast.show("Grant permissions to the camera first");
      return null;
    }
    // for(var status in statuses.keys) {
    //   developer.log("$status：${statuses[status]}", name: pageName);
    //   if(statuses[status] != PermissionStatus.granted) {
    //     WSToast.show("Grant permissions to the camera first");
    //     return null;
    //   }
    // }

    XFile? imgfile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imgfile == null) {
      return null;
    }
    String imgPath = imgfile.path;
    if (TargetPlatform.android == defaultTargetPlatform) {
      imgPath = "file://${imgfile.path}";
    }
    return imgPath;
  }

  //从相册选照片，成功则返回照片的本地路径，注：Android 必须要加 file:// 头
  Future<String?> pickImage() async {
    PermissionStatus? status;
    if (Platform.isAndroid) {
      status = await Permission.accessMediaLocation.request();
    } else {
      status = await Permission.photos.request();
    }
    if (status != PermissionStatus.granted) {
      WSToast.show("Grant permissions to the photos first");
      return null;
    }

    XFile? imgfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imgfile == null) {
      return null;
    }
    String imgPath = imgfile.path;
    return imgPath;
  }

  //选择本地文件，成功返回文件信息
  Future<List<File>> pickFiles() async {
    PermissionStatus status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      WSToast.show("Grant permissions to the storage first");
      return [];
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    List<File> files = [];
    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    } else {
      // User canceled the picker
    }
    return files;
  }

  //开始录音
  void startRecordAudio() async {
    WSAudioRecorder.instance.startRecord();
  }

  //录音结束，通过 finished 返回本地路径和语音时长，注：Android 必须要加 file:// 头
  void stopRecordAudio(Function(String path, int duration) finished) async {
    WSAudioRecorder.instance.stopRecord(finished);
  }

  //播放语音
  void startPlayAudio(String path) {
    WSAudioPlayer.instance.play(path);
  }

  //停止播放语音
  void stopPlayAudio() {
    WSAudioPlayer.instance.stop();
  }

  String getCorrectedLocalPath(String localPath) {
    String path = localPath;
    //Android 本地路径需要删除 file:// 才能被 File 对象识别
    if (TargetPlatform.android == defaultTargetPlatform) {
      path = localPath.replaceFirst("file://", "");
    }
    return path;
  }
}
