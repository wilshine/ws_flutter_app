// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSUserModel _$WSUserModelFromJson(Map<String, dynamic> json) => WSUserModel(
      level: (json['level'] as num?)?.toInt(),
      onlineStatus: json['onlineStatus'] as String?,
      isSpecialFollow: json['isSpecialFollow'] as bool?,
      about: json['about'] as String?,
      birthday: json['birthday'] as String?,
      language: json['language'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      userType: (json['userType'] as num?)?.toInt(),
      isVip: json['isVip'] as bool?,
      activityTagUrl: json['activityTagUrl'] as String?,
      age: (json['age'] as num?)?.toInt(),
      avatar: json['avatar'] as String?,
      avatarMapPath: json['avatarMapPath'] as String?,
      callCoins: (json['callCoins'] as num?)?.toInt(),
      country: json['country'] as String?,
      followNum: (json['followNum'] as num?)?.toInt(),
      gender: (json['gender'] as num?)?.toInt(),
      nickname: json['nickname'] as String?,
      status: json['status'] as String?,
      unit: json['unit'] as String?,
      userId: json['userId'] as String? ?? '',
      videoMapPaths: json['videoMapPaths'] as List<dynamic>?,
      registerCountry: json['registerCountry'] as String?,
      broadcasterId: json['broadcasterId'] as String?,
      alias: json['alias'] as String?,
    );

Map<String, dynamic> _$WSUserModelToJson(WSUserModel instance) =>
    <String, dynamic>{
      'activityTagUrl': instance.activityTagUrl,
      'age': instance.age,
      'avatar': instance.avatar,
      'avatarMapPath': instance.avatarMapPath,
      'callCoins': instance.callCoins,
      'country': instance.country,
      'followNum': instance.followNum,
      'gender': instance.gender,
      'nickname': instance.nickname,
      'status': instance.status,
      'unit': instance.unit,
      'userId': instance.userId,
      'videoMapPaths': instance.videoMapPaths,
      'userType': instance.userType,
      'avatarUrl': instance.avatarUrl,
      'birthday': instance.birthday,
      'language': instance.language,
      'about': instance.about,
      'isSpecialFollow': instance.isSpecialFollow,
      'onlineStatus': instance.onlineStatus,
      'level': instance.level,
      'isVip': instance.isVip,
      'registerCountry': instance.registerCountry,
      'broadcasterId': instance.broadcasterId,
      'alias': instance.alias,
    };

WSUserInfoModel _$WSUserInfoModelFromJson(Map<String, dynamic> json) =>
    WSUserInfoModel(
      about: json['about'] as String?,
      age: (json['age'] as num?)?.toInt(),
      avatarMiddleThumbUrl: json['avatarMiddleThumbUrl'] as String?,
      avatarThumbUrl: json['avatarThumbUrl'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      birthday: json['birthday'] as String?,
      availableCoins: (json['availableCoins'] as num?)?.toInt() ?? 0,
      country: json['country'] as String?,
      language: json['language'] as String?,
      gender: (json['gender'] as num?)?.toInt(),
      isBlock: json['isBlock'] as bool?,
      isFirstRegister: json['isFirstRegister'] as String?,
      isFriend: json['isFriend'] as bool?,
      isVip: json['isVip'] as bool?,
      mediaList: (json['mediaList'] as List<dynamic>?)
          ?.map((e) => WSMediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nickname: json['nickname'] as String?,
      onlineStatus: json['onlineStatus'] as String?,
      rongcloudToken: json['rongcloudToken'] as String?,
      token: json['token'] as String?,
      userId: json['userId'] as String?,
      vipExpiryTime: json['vipExpiryTime'] as String?,
      vipLevel: json['vipLevel'] as String?,
    );

Map<String, dynamic> _$WSUserInfoModelToJson(WSUserInfoModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'isFirstRegister': instance.isFirstRegister,
      'userId': instance.userId,
      'avatarUrl': instance.avatarUrl,
      'avatarMiddleThumbUrl': instance.avatarMiddleThumbUrl,
      'avatarThumbUrl': instance.avatarThumbUrl,
      'gender': instance.gender,
      'nickname': instance.nickname,
      'age': instance.age,
      'birthday': instance.birthday,
      'country': instance.country,
      'language': instance.language,
      'about': instance.about,
      'isVip': instance.isVip,
      'vipLevel': instance.vipLevel,
      'vipExpiryTime': instance.vipExpiryTime,
      'isBlock': instance.isBlock,
      'isFriend': instance.isFriend,
      'onlineStatus': instance.onlineStatus,
      'rongcloudToken': instance.rongcloudToken,
      'mediaList': instance.mediaList,
      'availableCoins': instance.availableCoins,
    };

WSMediaModel _$WSMediaModelFromJson(Map<String, dynamic> json) => WSMediaModel(
      mediaId: json['mediaId'] as String?,
      mediaPath: json['mediaPath'] as String?,
      mediaType: json['mediaType'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      middleThumbUrl: json['middleThumbUrl'] as String?,
      sort: json['sort'] as String?,
      thumbUrl: json['thumbUrl'] as String?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$WSMediaModelToJson(WSMediaModel instance) =>
    <String, dynamic>{
      'mediaId': instance.mediaId,
      'mediaPath': instance.mediaPath,
      'mediaType': instance.mediaType,
      'mediaUrl': instance.mediaUrl,
      'middleThumbUrl': instance.middleThumbUrl,
      'sort': instance.sort,
      'thumbUrl': instance.thumbUrl,
      'userId': instance.userId,
    };

WSHBStrategyModel _$WSHBStrategyModelFromJson(Map<String, dynamic> json) =>
    WSHBStrategyModel(
      userServiceAccountId: json['userServiceAccountId'] as String?,
    );

Map<String, dynamic> _$WSHBStrategyModelToJson(WSHBStrategyModel instance) =>
    <String, dynamic>{
      'userServiceAccountId': instance.userServiceAccountId,
    };
