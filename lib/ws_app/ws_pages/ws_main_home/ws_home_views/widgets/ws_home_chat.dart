import 'dart:math';

import 'package:common_tools/common_tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_models/ws_user_model.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/ws_conversation_views/ws_conversation_view.dart';
import 'package:ws_flutter_app/ws_services/ws_app_service.dart';
import 'package:common_ui/common_ui.dart';

class WSHomeChat extends StatefulWidget {
  const WSHomeChat({
    super.key,
    required this.user,
    required this.rankingPath,
  });

  final WSUserModel user;

  final String rankingPath;

  @override
  State<WSHomeChat> createState() => _WSHomeChatState();
}

class _WSHomeChatState extends State<WSHomeChat> {
  String timeString = '12m26s';

  @override
  void initState() {
    super.initState();

    timeString = '${Random().nextInt(30) + 10}m${Random().nextInt(50) + 10}s';
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    String userNickName = widget.user.nickname ?? '';
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3D3F40),
            Color(0xFF454747),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Stack(children: [
            SizedBox(
              width: 78,
              height: 78,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  try {
                    EasyLoading.show();
                    await WSAppService.instance.addFriend(widget.user.userId);
                    WSToast.show('Follow Successfully');
                    setState(() {});
                  } finally {
                    EasyLoading.dismiss();
                  }
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(39)),
                    color: Color(0xFFFFE34E),
                  ),
                  padding: EdgeInsets.all(1.r),
                  child: CircleAvatar(
                    backgroundImage: widget.user.avatar?.isNotEmpty ?? true ? NetworkImage(widget.user.avatar!) : null,
                  ),
                ),
              ),
            ),
            if (!WSAppService.instance.isFollowedUser(widget.user.userId))
              Positioned(right: 0, bottom: 0, child: Image.asset('assets/webp/home_item_add_icon.webp', width: 16.w)),
            Positioned(right: 0, top: 0, child: Image.asset(widget.rankingPath, width: 22.w)),
          ]),
          const SizedBox(width: 12),
          Container(
            height: 78,
            width: 140,
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  userNickName.length > 16 ? userNickName.overflow : userNickName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.user.country ?? '',
                  style: const TextStyle(
                    color: Color(0x99FFFFFF),
                    fontSize: 11,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 78,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 6),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    onEventClickChat();
                  },
                  child: getChatIcon(),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(
                      Icons.access_alarm,
                      size: 17,
                      color: Color(0xCCFFFFFF),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      timeString,
                      style: const TextStyle(color: Color(0xCCFFFFFF), fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getChatIcon() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(13)),
        gradient: LinearGradient(
          colors: [Color(0xFFE6FF4E), Color(0xFFFCFD55)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SizedBox(
        width: 65,
        height: 28,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: Row(
              children: [
                SizedBox(width: 22, height: 22, child: Image.asset('assets/images/home/home_chat_icon.webp')),
                const Spacer(),
                const Text('Chat', style: TextStyle(color: Color(0xFF202020), fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Tap chat event
  Future<void> onEventClickChat() async {
    if (WSAppService.instance.isBlockUser(widget.user.userId)) {
      WSToast.show('This user has been hacked by you');
      return;
    }

    Get.to(() => WSConversationView(user: widget.user));
  }
}
