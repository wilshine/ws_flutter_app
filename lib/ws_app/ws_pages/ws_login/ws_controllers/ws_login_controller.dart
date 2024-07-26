import 'dart:io';

import 'package:common_tools/common_tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_utils/ws_shared_preferences_util.dart';

class WSLoginController extends GetxController {

  RxBool isCheckedPrivacy = false.obs;

  final avatarPath = ''.obs;

  @override
  onInit() {
    super.onInit();
    avatarPath.value = XpToolPlatform.instance.getValueWithKey('avatarPath') ?? '';
  }


  Future<bool> refreshAvatar(String path) async {
    avatarPath.value = path;
    avatarPath.refresh();
    return XpToolPlatform.instance.setValueWithKey('avatarPath', path);
    // return WSSharedPreferencesUtil.getInstance().prefs.setString('avatarPath', path);
  }

  FileImage? getAvatarImage() {
    if (avatarPath.value.isNotEmpty && File(avatarPath.value).existsSync()) {
      return FileImage(File(avatarPath.value));
    }
    return null;
  }

}
