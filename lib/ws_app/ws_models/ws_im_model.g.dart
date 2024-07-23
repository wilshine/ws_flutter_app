// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_im_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WSMessageItem _$WSMessageItemFromJson(Map<String, dynamic> json) =>
    WSMessageItem(
      conversation: json['conversation'],
      user: json['user'] == null
          ? null
          : WSUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WSMessageItemToJson(WSMessageItem instance) =>
    <String, dynamic>{
      'conversation': instance.conversation,
      'user': instance.user,
    };

WSFollowedItem _$WSFollowedItemFromJson(Map<String, dynamic> json) =>
    WSFollowedItem(
      isFollowed: json['isFollowed'] as bool,
      user: json['user'] == null
          ? null
          : WSUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WSFollowedItemToJson(WSFollowedItem instance) =>
    <String, dynamic>{
      'isFollowed': instance.isFollowed,
      'user': instance.user,
    };
