import 'package:shared_preferences/shared_preferences.dart';

class WSSharedPreferencesUtil {

  //单例模式
  factory WSSharedPreferencesUtil() => getInstance();
  static WSSharedPreferencesUtil? _instance;
  static WSSharedPreferencesUtil getInstance() {
    _instance ??= WSSharedPreferencesUtil._();
    return _instance!;
  }
  WSSharedPreferencesUtil._();

  late SharedPreferences prefs;
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }



}