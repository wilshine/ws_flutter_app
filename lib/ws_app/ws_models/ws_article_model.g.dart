// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_article_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSArticleModel _$WSArticleModelFromJson(Map<String, dynamic> json) =>
    WSArticleModel(
      title: json['title'] as String,
      description: json['description'] as String,
      author: json['author'] as String,
      followed: (json['followed'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      type: json['type'] as String,
      thumbnail: json['thumbnail'] as String?,
      articleType: json['articleType'] as String,
      content: json['content'] as List<dynamic>? ?? [],
      user: json['user'] == null
          ? null
          : WSUserModel.fromJson(json['user'] as Map<String, dynamic>),
      commentList: (json['commentList'] as List<dynamic>?)
              ?.map((e) => WSComment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    )
      ..avatar = json['avatar'] as String?
      ..likedByMe = json['likedByMe'] as bool?;

Map<String, dynamic> _$WSArticleModelToJson(WSArticleModel instance) =>
    <String, dynamic>{
      'author': instance.author,
      'followed': instance.followed,
      'count': instance.count,
      'type': instance.type,
      'title': instance.title,
      'thumbnail': instance.thumbnail,
      'content': instance.content,
      'description': instance.description,
      'avatar': instance.avatar,
      'likedByMe': instance.likedByMe,
      'articleType': instance.articleType,
      'user': instance.user,
      'commentList': instance.commentList,
    };

WSComment _$WSCommentFromJson(Map<String, dynamic> json) => WSComment(
      content: json['content'] as String?,
      nickname: json['nickname'] as String?,
      avatar: json['avatar'] as String?,
      likedByMe: json['likedByMe'] as bool?,
    );

Map<String, dynamic> _$WSCommentToJson(WSComment instance) => <String, dynamic>{
      'avatar': instance.avatar,
      'nickname': instance.nickname,
      'content': instance.content,
      'likedByMe': instance.likedByMe,
    };

WSGoodsModel _$WSGoodsModelFromJson(Map<String, dynamic> json) => WSGoodsModel(
      capableRechargeNum: (json['capableRechargeNum'] as num?)?.toInt() ?? 0,
      code: json['code'] as String?,
      discount: (json['discount'] as num?)?.toDouble() ?? 0,
      exchangeCoin: (json['exchangeCoin'] as num?)?.toInt() ?? 0,
      extraCoin: (json['extraCoin'] as num?)?.toInt() ?? 0,
      extraCoinPercent: (json['extraCoinPercent'] as num?)?.toInt() ?? 0,
      goodsId: json['goodsId'] as String?,
      icon: json['icon'] as String?,
      invitationId: json['invitationId'] as String?,
      isPromotion: json['isPromotion'] as bool? ?? false,
      originalCode: json['originalCode'] as String?,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      originalPriceRupee:
          (json['originalPriceRupee'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      priceRupee: (json['priceRupee'] as num?)?.toDouble() ?? 0.0,
      rechargeNum: (json['rechargeNum'] as num?)?.toInt() ?? 0,
      remainMilliseconds: (json['remainMilliseconds'] as num?)?.toInt() ?? 0,
      surplusMillisecond: (json['surplusMillisecond'] as num?)?.toInt() ?? 0,
      tags: json['tags'] as String?,
      type: json['type'] as String?,
      validity: (json['validity'] as num?)?.toInt() ?? 0,
      validityUnit: json['validityUnit'] as String?,
    );

Map<String, dynamic> _$WSGoodsModelToJson(WSGoodsModel instance) =>
    <String, dynamic>{
      'capableRechargeNum': instance.capableRechargeNum,
      'code': instance.code,
      'discount': instance.discount,
      'exchangeCoin': instance.exchangeCoin,
      'extraCoin': instance.extraCoin,
      'extraCoinPercent': instance.extraCoinPercent,
      'goodsId': instance.goodsId,
      'icon': instance.icon,
      'invitationId': instance.invitationId,
      'isPromotion': instance.isPromotion,
      'originalCode': instance.originalCode,
      'originalPrice': instance.originalPrice,
      'originalPriceRupee': instance.originalPriceRupee,
      'price': instance.price,
      'priceRupee': instance.priceRupee,
      'rechargeNum': instance.rechargeNum,
      'remainMilliseconds': instance.remainMilliseconds,
      'surplusMillisecond': instance.surplusMillisecond,
      'tags': instance.tags,
      'type': instance.type,
      'validity': instance.validity,
      'validityUnit': instance.validityUnit,
    };
