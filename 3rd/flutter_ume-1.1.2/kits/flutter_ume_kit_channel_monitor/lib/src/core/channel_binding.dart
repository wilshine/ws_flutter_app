import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ume_kit_channel_monitor/src/core/ume_binary_messenger.dart';

class ChannelBinding extends WidgetsFlutterBinding {
  static WidgetsBinding? ensureInitialized() {
    // make sure init this before WidgetsFlutterBinding ensureInitialized called
    if (BindingBase.debugBindingType() == null) {
      // if (WidgetsBinding.instance == null) {
      ChannelBinding();
    }
    return WidgetsFlutterBinding.ensureInitialized();
    return WidgetsBinding.instance;
  }

  @override
  @protected
  // 替换 BinaryMessenger
  BinaryMessenger createBinaryMessenger() {
    return UmeBinaryMessenger.binaryMessenger;
  }
}
