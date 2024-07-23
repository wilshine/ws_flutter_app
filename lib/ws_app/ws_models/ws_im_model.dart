import 'package:json_annotation/json_annotation.dart';

import 'ws_user_model.dart';

part 'ws_im_model.g.dart';

/// 聊天信息
@JsonSerializable()
class WSMessageItem {
  dynamic conversation;
  WSUserModel? user;

  WSMessageItem({
    this.conversation,
    this.user,
  });

  factory WSMessageItem.fromJson(Map<String, dynamic> json) => _$WSMessageItemFromJson(json);

  Map<String, dynamic> toJson() => _$WSMessageItemToJson(this);
}

/// 关注item
@JsonSerializable()
class WSFollowedItem {
  bool isFollowed;

  WSUserModel? user;

  WSFollowedItem({
    required this.isFollowed,
    this.user,
  });

  factory WSFollowedItem.fromJson(Map<String, dynamic> json) => _$WSFollowedItemFromJson(json);

  Map<String, dynamic> toJson() => _$WSFollowedItemToJson(this);
}
