import 'dart:io';

import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/util/ws_file_suffix.dart';
import 'package:ws_flutter_app/ws_utils/ws_log/ws_logger.dart';

class WSFileUtil {
  static Future<bool> copyFile(String srcPath, String destPath) async {
    try {
      File source = File(srcPath);
      File destination = File(destPath);
      await destination.create(recursive: true);
      File file = await source.copy(destination.path);
      if(file.existsSync()) {
        return true;
      }
    } catch (e, s) {
      WSLogger.error('$e  $s');
    }
    return false;
  }

  static Future<bool> isFileExists(String path) async {
    try {
      File file = File(path);
      return await file.exists();
    } catch (e) {
      WSLogger.error(e);
      return false;
    }
  }

  static int kilobyte = 1024;
  static int megabyte = 1024 * 1024;
  static int gigabyte = 1024 * 1024 * 1024;
  static String formatFileSize(int size) {
    if (size < kilobyte) {
      return "$size B";
    } else if (size < megabyte) {
      String sizeStr = (size / kilobyte).toStringAsFixed(2);
      return "$sizeStr KB";
    } else if (size < gigabyte) {
      String sizeStr = (size / megabyte).toStringAsFixed(2);
      return "$sizeStr MB";
    } else {
      String sizeStr = (size / gigabyte).toStringAsFixed(2);
      return "$sizeStr G";
    }
  }

  // 根据文件类型选择对应图片
  static String fileTypeImagePath(String fileName) {
    String imagePath;
    if (checkSuffix(fileName, WSFileSuffix.ImageFileSuffix)) {
      imagePath = "assets/images/file_message_icon_picture.png";
    } else if (checkSuffix(fileName, WSFileSuffix.FileFileSuffix)) {
      imagePath = "assets/images/file_message_icon_file.png";
    } else if (checkSuffix(fileName, WSFileSuffix.VideoFileSuffix)) {
      imagePath = "assets/images/file_message_icon_video.png";
    } else if (checkSuffix(fileName, WSFileSuffix.AudioFileSuffix)) {
      imagePath = "assets/images/file_message_icon_audio.png";
    } else {
      imagePath = "assets/images/file_message_icon_else.png";
    }
    return imagePath;
  }

  static bool checkSuffix(String fileName, List fileSuffix) {
    for (String suffix in fileSuffix) {
      if (fileName.toLowerCase().endsWith(suffix)) {
        return true;
      }
    }
    return false;
  }

  static Future<File> writeStringToFile(
      String filePath, String fileName, String content) async {
    Directory file = Directory(filePath);
    if (!file.existsSync()) {
      file.create();
    }
    return File("$filePath/$fileName").writeAsString(content);
  }

  static void remove(String path) {
    File file = File(path);
    if (file.existsSync()) {
      file.delete();
    }
  }
}
