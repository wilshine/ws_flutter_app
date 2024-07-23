import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/util/ws_user_info_datesource.dart';

class WSDbManager {
  factory WSDbManager() => _getInstance();
  static WSDbManager get instance => _getInstance();
  static WSDbManager? _instance;
  static Database? database;
  static String dbName = 'UserInfoCache.db';
  static String userTableName = 'users';
  static String groupTableName = 'groups';

  WSDbManager._internal() {
    // 初始化
  }

  static WSDbManager _getInstance() {
    if (_instance == null) {
      _instance = new WSDbManager._internal();
    }
    return _instance!;
  }

  Future<void> openDb() async {
    database = await openDatabase(join(await getDatabasesPath(), dbName),
        onCreate: (db, version) {
      db.execute(
          "CREATE TABLE $userTableName(userId TEXT PRIMARY KEY, name TEXT, portraitUrl TEXT) ");
      db.execute(
          "CREATE TABLE $groupTableName(groupId TEXT PRIMARY KEY, name TEXT, portraitUrl TEXT)");
    }, version: 1);
  }

  Future<void> setUserInfo(UserInfo info) async {
    // if (database == null) {
    //   await openDb();
    // }
    // await database?.insert(userTableName, info.toMap(),
    //     conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<UserInfo>> getUserInfo({required String userId}) async {
    List<Map<String, dynamic>>? maps = [];
    if (database == null) {
      await openDb();
    }
    if (userId == null || userId.isEmpty) {
      maps = await database?.query(userTableName);
    } else {
      maps = await database
          ?.query(userTableName, where: 'userId = ?', whereArgs: [userId]);
    }
    List<UserInfo> infoList = [];
    if (maps != null && maps.length > 0) {
      infoList = List.generate(maps.length, (i) {
        UserInfo info = UserInfo();
        info.id = maps?[i]['userId'];
        info.name = maps?[i]['name'];
        info.portraitUrl = maps?[i]['portraitUrl'];
        return info;
      });
    }
    return infoList;
  }

  Future<void> setGroupInfo(GroupInfo info) async {
    if (database == null) {
      await openDb();
    }
    await database?.insert(groupTableName, info.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<GroupInfo>> getGroupInfo({required String groupId}) async {
    List<Map<String, dynamic>>? maps = [];
    if (database == null) {
      await openDb();
    }
    if (groupId == null || groupId.isEmpty) {
      maps = await database?.query(groupTableName);
    } else {
      maps = await database
          ?.query(groupTableName, where: 'groupId = ?', whereArgs: [groupId]);
    }
    List<GroupInfo> infoList = [];
    if (maps != null && maps.length > 0) {
      infoList = List.generate(maps.length, (i) {
        GroupInfo info = GroupInfo();
        info.id = maps?[i]['groupId'];
        info.name = maps?[i]['name'];
        info.portraitUrl = maps?[i]['portraitUrl'];
        return info;
      });
    }
    return infoList;
  }
}
