import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_controllers/ws_im_controller.dart';
import 'package:flutter/material.dart';
import 'package:ws_flutter_app/ws_services/ws_app_service.dart';
import 'package:common_ui/common_ui.dart';

class WSFollowedListView extends StatefulWidget {
  const WSFollowedListView({super.key});

  @override
  State<WSFollowedListView> createState() => _WSFollowedListViewState();
}

class _WSFollowedListViewState extends State<WSFollowedListView> with AutomaticKeepAliveClientMixin {
  late EasyRefreshController easyRefreshController;

  late WSIMController imController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    imController = Get.find<WSIMController>();

    easyRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      controller: easyRefreshController,
      onRefresh: () async {
        await WSAppService.instance.refreshFollowedList();
        easyRefreshController.finishRefresh();
      },
      child: Container(),
      // Obx(
      //   () {
          // if (WSAppService.instance.followedList.isEmpty) {
          //   return WSAppUtil.buildEmptyWidget();
          // }
          // return ListView.builder(
          //   padding: EdgeInsets.zero,
          //   itemCount: WSAppService.instance.followedList.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     WSFollowedItem item = WSAppService.instance.followedList.value.elementAt(index);
          //     return buildItem(item);
          //   },
          // );
        //   return Container();
        // },
      // ),
    );
  }

  Widget buildItem(item) {
    var child = Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      height: 76,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            margin: const EdgeInsets.only(left: 18, right: 10),
            child: CircleAvatar(
              radius: 22,
              backgroundImage: item.user?.avatarUrl != null ? NetworkImage(item.user!.avatarUrl!) : null,
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                (item.user?.nickname ?? '').overflow,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          FollowedButtonWidget(
            isFollowed: item.isFollowed,
            onTap: () async {
              await WSAppService.instance.unFriend(item.user!.userId);
              WSToast.show('Unfollow Successfully');
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (item.user != null) {
            // Get.to(() => WSConversationView(user: item.user!));
          } else {
            WSToast.show('unknow error');
          }
        },
        child: child);
  }
}

class FollowedButtonWidget extends StatefulWidget {
  FollowedButtonWidget({
    super.key,
    required this.isFollowed,
    required this.onTap,
  });

  bool isFollowed;
  final Function() onTap;

  @override
  State<FollowedButtonWidget> createState() => _FollowedButtonWidgetState();
}

class _FollowedButtonWidgetState extends State<FollowedButtonWidget> {
  @override
  Widget build(BuildContext context) {
    //返回一个椭圆形背景的Container
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          widget.isFollowed = !widget.isFollowed;
        });
        widget.onTap.call();
      },
      child: Container(
        width: 100,
        height: 28.h,
        decoration: BoxDecoration(
          color: widget.isFollowed ? Colors.grey : Colors.blue,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Text(
            widget.isFollowed ? 'Followed' : 'Follow',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
