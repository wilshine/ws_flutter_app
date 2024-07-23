import 'package:json_annotation/json_annotation.dart';
import 'package:ws_flutter_app/ws_app/ws_app_const.dart';
import 'package:ws_flutter_app/ws_app/ws_models/ws_user_model.dart';

part 'ws_article_model.g.dart';

/// 作品
@JsonSerializable()
class WSArticleModel {
  static const String typeHot = 'Hot';
  static const String typeRecommed = 'Recommed';
  static const String typePreformance = 'Preformance';
  String author;

  /// 关注人数 5 - 20
  int followed;

  /// 作品数量
  int count;
  String type;
  String title;

  /// 封面 图片
  String? thumbnail;

  ///内容 图片
  @JsonKey(name: 'content', defaultValue: [])
  List? content;

  /// 描述
  String description;

  /// 头像
  String? avatar;

  /// 是否点赞
  bool? likedByMe;

  /// 类型 [WSAppConst.articleTypeBumperCarRace, WSAppConst.articleTypeBumperCarRace, WSAppConst.articleTypeBumperCarRace]
  String articleType;

  WSUserModel? user;

  /// 评论
  @JsonKey(name: 'commentList', defaultValue: [])
  List<WSComment> commentList = [];

  WSArticleModel({
    required this.title,
    required this.description,
    required this.author,
    required this.followed,
    required this.count,
    required this.type,
    required this.thumbnail,
    required this.articleType,
    this.content,
    this.user,
    required this.commentList,
  });

  factory WSArticleModel.fromJson(Map<String, dynamic> json) => _$WSArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$WSArticleModelToJson(this);
}

@JsonSerializable()
class WSComment {
  String? avatar;
  String? nickname;
  String? content;
  bool? likedByMe;

  WSComment({
    this.content,
    this.nickname,
    this.avatar,
    this.likedByMe,
  });

  factory WSComment.fromJson(Map<String, dynamic> json) => _$WSCommentFromJson(json);

  Map<String, dynamic> toJson() => _$WSCommentToJson(this);
}

@JsonSerializable()
class WSGoodsModel {
  @JsonKey(name: 'capableRechargeNum', defaultValue: 0)
  int? capableRechargeNum = 0; //能够充值次数
  String? code; //商品编号
  @JsonKey(name: 'discount', defaultValue: 0)
  double? discount = 0; //折扣
  @JsonKey(name: 'exchangeCoin', defaultValue: 0)
  int? exchangeCoin = 0; //兑换金币数
  @JsonKey(name: 'extraCoin', defaultValue: 0)
  int? extraCoin = 0; //额外的金币数量
  @JsonKey(name: 'extraCoinPercent', defaultValue: 0)
  int? extraCoinPercent = 0; //额外的金币比例
  String? goodsId; //商品id
  String? icon; //商品图标
  String? invitationId; //邀请链接id
  @JsonKey(name: 'isPromotion', defaultValue: false)
  bool? isPromotion = false; //是否促销
  String? originalCode; //升级消费的商品code
  @JsonKey(name: 'originalPrice', defaultValue: 0.0)
  double? originalPrice = 0.0; //原价
  @JsonKey(name: 'originalPriceRupee', defaultValue: 0.0)
  double? originalPriceRupee = 0.0; //原价(卢比)
  @JsonKey(name: 'price', defaultValue: 0.0)
  double? price = 0.0; //当前价格
  @JsonKey(name: 'priceRupee', defaultValue: 0.0)
  double? priceRupee = 0.0; //当前价格(卢比)
  @JsonKey(name: 'rechargeNum', defaultValue: 0)
  int? rechargeNum = 0; //充值次数
  @JsonKey(name: 'remainMilliseconds', defaultValue: 0)
  int? remainMilliseconds = 0; //剩余毫秒秒数
  @JsonKey(name: 'surplusMillisecond', defaultValue: 0)
  int? surplusMillisecond = 0; //剩余毫秒数
  String? tags; //商品标签
  String? type; //商品类型

  @JsonKey(name: 'validity', defaultValue: 0)
  int? validity = 0; //订阅有效期

  String? validityUnit;

  WSGoodsModel({
    this.capableRechargeNum,
    this.code,
    this.discount,
    this.exchangeCoin,
    this.extraCoin,
    this.extraCoinPercent,
    this.goodsId,
    this.icon,
    this.invitationId,
    this.isPromotion,
    this.originalCode,
    this.originalPrice,
    this.originalPriceRupee,
    this.price,
    this.priceRupee,
    this.rechargeNum,
    this.remainMilliseconds,
    this.surplusMillisecond,
    this.tags,
    this.type,
    this.validity,
    this.validityUnit,
  });

  factory WSGoodsModel.fromJson(Map<String, dynamic> json) => _$WSGoodsModelFromJson(json);

  Map<String, dynamic> toJson() => _$WSGoodsModelToJson(this);
}
