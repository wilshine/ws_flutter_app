import 'package:common_tools/common_tools.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_models/ws_user_model.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_mine/ws_mine_controllers/ws_mine_controller.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_mine/ws_mine_views/ws_mine_base_view.dart';
import 'package:ws_flutter_app/ws_services/ws_app_service.dart';
import 'package:ws_flutter_app/ws_utils/ws_dialog_util.dart';
import 'package:ws_flutter_app/ws_utils/ws_toast_util.dart';

/// 拉黑列表
class WSBlockListView extends StatefulWidget {
  const WSBlockListView({super.key});

  @override
  State<WSBlockListView> createState() => _WSBlockListViewState();
}

class _WSBlockListViewState extends WSMineBaseState<WSBlockListView> {
  late EasyRefreshController easyRefreshController;

  late WSMineController controller;

  @override
  void initState() {
    easyRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    controller = Get.find();

    WSAppService.instance.refreshBlockList();

    super.initState();
  }

  @override
  void dispose() {
    easyRefreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: context.mediaQueryPadding.top.h),
          buildTopBar(title: 'Block List'),
          Expanded(
            child: Container(
              child: EasyRefresh(
                controller: easyRefreshController,
                onRefresh: () async {
                  await WSAppService.instance.refreshBlockList();
                  easyRefreshController.finishRefresh();
                },
                child: Obx(
                  () {
                    // if (WSAppService.instance.blockList.isEmpty) {
                    //   return WSAppUtil.buildEmptyWidget();
                    // }
                    return Container();
                    // return ListView.builder(
                    //   padding: EdgeInsets.zero,
                    //   itemCount: WSAppService.instance.blockList.length,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     var item = WSAppService.instance.blockList.elementAt(index);
                    //     return buildItem(item);
                    //   },
                    // );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(WSUserModel item) {
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 12.h, top: 12.h),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: item.avatar != null ? NetworkImage(item.avatar!) : null,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (item.nickname ?? '').overflow,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.registerCountry ?? '',
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w,),
          GestureDetector(
            onTap: (){
              WSDialogUtil.confirm('Confirm unBlock?', () async {
                await WSAppService.instance.unBlockUser(item.broadcasterId!);
                WSToastUtil.show('Unblock successfully');
              });
            },
            child: Container(
              padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 6.h, bottom: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF454545),
                borderRadius: BorderRadius.circular(26.w),
              ),
              child: const Text('Unblock', style: TextStyle(color: Colors.white),)
            ),
          ),

        ],
      ),
    );
  }
}
