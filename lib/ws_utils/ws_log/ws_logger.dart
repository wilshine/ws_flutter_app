import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:common_ui/common_ui.dart';

/// 日志工具
class WSLogger {
  static const int levelInfo = 1;
  static const int levelDebug = 2;
  static const int levelWarning = 3;
  static const int levelError = 4;

  /// 输出日志级别
  static int level = levelDebug;

  static List<String> logs = [];

  static void setLevel(int l) {
    level = l;
  }

  static void write(String msg, {bool isError = false}) {
    print('Logger:write---> $msg [isError=$isError]');
    // Future.microtask(() => );
  }

  /// 调试输出
  /// [msg]  日志信息
  /// [module]  模块名
  static void debug(dynamic msg, {String module = ''}) {
    _print(msg.toString());
  }

  static void _print(String msg, {String module = ''}) {
    String txt = '[$module] ${DateTime.now()}---> $msg';
    if(kDebugMode) {
      print(txt);
    }
    // logs.add(txt);
    //
    // if(logs.length > 2000) {
    //   logs.removeRange(0, 1000);
    // }
  }

  /// error级别的日志，需要做记录
  static void error(dynamic error) {
    _print(error.toString());
  }
}

class WSLoggerView extends StatefulWidget {
  const WSLoggerView({super.key});

  @override
  State<WSLoggerView> createState() => _WSLoggerViewState();
}

class _WSLoggerViewState extends State<WSLoggerView> {
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    list.add(GestureDetector(
      onTap: (){
        Clipboard.setData(ClipboardData(text: WSLogger.logs.join('\n')));
        WSToast.show('copy successfully');
      },
      child: Container(
        color: Colors.red,
        margin: const EdgeInsets.only(top: 100),
        child: const Text('<<<<<<复制>>>>>>>'),
      ),
    ));
    for (var element in WSLogger.logs) {
      list.add(Text(element));
    }
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(children: list),
        ),
      ),
    );
  }
}
