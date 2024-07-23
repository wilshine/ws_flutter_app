import 'package:json_annotation/json_annotation.dart';

part 'ws_user_model.g.dart';

/// 用户信息实体
@JsonSerializable()
class WSUserModel {
  /// 活动标签url
  String? activityTagUrl;
  int? age;
  String? avatar;

  /// 头像相对路径
  String? avatarMapPath;

  /// 通话价格
  int? callCoins;
  String? country;
  /// 关注人数
  int? followNum;
  int? gender;
  String? nickname;
  String? status;
  String? unit;
  @JsonKey(name: 'userId', defaultValue: '')
  String userId;

  // 视频相对路径集合
  List? videoMapPaths;

  int? userType;
  String? avatarUrl;
  String? birthday;
  String? language;
  String? about;
  bool? isSpecialFollow;
  String? onlineStatus;
  int? level;
  bool? isVip;

  String? registerCountry;
  String? broadcasterId; //拉黑列表用

  String? alias; // 本地别名 A-J 对应文章的author

  WSUserModel({
    this.level,
    this.onlineStatus,
    this.isSpecialFollow,
    this.about,
    this.birthday,
    this.language,
    this.avatarUrl,
    this.userType,
    this.isVip,
    this.activityTagUrl,
    this.age,
    this.avatar,
    this.avatarMapPath,
    this.callCoins,
    this.country,
    this.followNum,
    this.gender,
    this.nickname,
    this.status,
    this.unit,
    this.userId = '',
    this.videoMapPaths,
    this.registerCountry,
    this.broadcasterId,
    this.alias,
  });

  String get getUrl {
    if (avatarUrl != null && avatarUrl!.isNotEmpty) {
      return avatarUrl!;
    } else if (avatar != null && avatar!.isNotEmpty) {
      return avatar!;
    } else {
      return '';
    }
  }

  factory WSUserModel.fromJson(Map<String, dynamic> json) => _$WSUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$WSUserModelToJson(this);
}

/// 登录用户实体
@JsonSerializable()
class WSUserInfoModel {
  String? token; // 用户登录令牌
  String? isFirstRegister; // 是否为第一次注册
  String? userId; // 用户ID

  String? avatarUrl; // 头像
  String? avatarMiddleThumbUrl; // 中等大小头像
  String? avatarThumbUrl; // 头像缩略图

  int? gender; // 性别
  String? nickname; // 昵称
  int? age; // 年龄
  String? birthday; // 生日
  String? country; // 国家
  String? language;
  String? about; // 个人介绍

  bool? isVip; // 用户是否为VID
  String? vipLevel; // 用户VIP等级
  String? vipExpiryTime; // 用户VIP过期时间

  bool? isBlock; // 是否被拉黑
  bool? isFriend; // 是否是好友

  String? onlineStatus; // 在线状态

  String? rongcloudToken; // 融云Token

  List<WSMediaModel>? mediaList; // 用户照片墙列表

  // RCIMIWMessage? lastMessage; // 最后一条收到的消息

  int availableCoins; // 剩余金币个数

  WSUserInfoModel({
    this.about,
    this.age,
    this.avatarMiddleThumbUrl,
    this.avatarThumbUrl,
    this.avatarUrl,
    this.birthday,
    this.availableCoins = 0,
    this.country,
    this.language,
    this.gender,
    this.isBlock,
    this.isFirstRegister,
    this.isFriend,
    this.isVip,
    this.mediaList,
    this.nickname,
    this.onlineStatus,
    this.rongcloudToken,
    this.token,
    this.userId,
    this.vipExpiryTime,
    this.vipLevel,
  });

  factory WSUserInfoModel.empty() => WSUserInfoModel();

  factory WSUserInfoModel.fromJson(Map<String, dynamic> json) => _$WSUserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$WSUserInfoModelToJson(this);
}

/// 用户媒体信息模型
@JsonSerializable()
class WSMediaModel {
  String? mediaId; // 媒体资源ID
  String? mediaPath; // 媒体资源文件路径
  String? mediaType; // 媒体资源类型
  String? mediaUrl; // 媒体资源地址
  String? middleThumbUrl; // 中等尺寸媒体资源地址
  String? sort; // 资源排序
  String? thumbUrl; // 媒体资源缩略图地址
  String? userId;

  WSMediaModel({
    this.mediaId,
    this.mediaPath,
    this.mediaType,
    this.mediaUrl,
    this.middleThumbUrl,
    this.sort,
    this.thumbUrl,
    this.userId,
  }); // 归属的用户ID

  factory WSMediaModel.fromJson(Map<String, dynamic> json) => _$WSMediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$WSMediaModelToJson(this);
}

/// 策略信息实体
@JsonSerializable()
class WSHBStrategyModel {
  String? userServiceAccountId; // 用户客服账号id （客服账号）

  WSHBStrategyModel({this.userServiceAccountId});

  factory WSHBStrategyModel.fromJson(Map<String, dynamic> json) => _$WSHBStrategyModelFromJson(json);

  Map<String, dynamic> toJson() => _$WSHBStrategyModelToJson(this);
}
