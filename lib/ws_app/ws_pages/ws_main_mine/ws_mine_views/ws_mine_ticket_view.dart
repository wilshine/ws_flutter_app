import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_app_util.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_mine/ws_mine_controllers/ws_mine_controller.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_mine/ws_mine_views/ws_mine_base_view.dart';
import 'package:ws_flutter_app/ws_utils/ws_toast_util.dart';

class WSMineTicketView extends StatefulWidget {
  const WSMineTicketView({super.key});

  @override
  State<WSMineTicketView> createState() => _WSMineTicketViewState();
}

class _WSMineTicketViewState extends WSMineBaseState<WSMineTicketView> {
  WSMineController? controller;

  @override
  void initState() {
    controller = Get.find<WSMineController>();
    super.initState();
  }

  @override
  void dispose() {
    controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: context.mediaQueryPadding.top.h),
          buildTopBar(title: 'My Tickets'),
          SizedBox(height: 18.h,),
          Expanded(
            child: Obx(() {
              if (controller?.ticketList.isEmpty == true) {
                return WSAppUtil.buildEmptyWidget();
              }
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller?.ticketList.length ?? 0,
                itemBuilder: (context, index) {
                  var goodsModel = controller?.ticketList.elementAt(index);
                  if (goodsModel != null) {
                    return buildItem(goodsModel);
                  }
                  return Container();
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildItem(Map goodsModel) {
    return Container(
      height: 68.h,
      margin: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(width: 0.5.w, color: const Color(0xFFCCCCCC)),
      ),
      child: Stack(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Order Notifications',
                    style: TextStyle(fontSize: 16.sp, color: const Color(0xFF404040)),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    goodsModel['orderNo']?.toString() ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFFFFE34E),
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Clipboard.setData(ClipboardData(text: goodsModel['orderNo']));
                WSToastUtil.show('Copy successfully');
              },
              child: Container(
                margin: EdgeInsets.only(right: 20.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(width: 1.w, color: const Color(0xFF1F1F1F)),
                ),
                width: 74.w,
                height: 28.h,
                child: Text(
                  'Copy',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.only(left: 8.w, right: 8.w),
            transform: Matrix4.skewX(-.1),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
              color: Colors.black,
              borderRadius: BorderRadius.circular(2.r),
            ),
            child: const Text("To be used", style: TextStyle(fontSize: 11, color: Color(0xFFFCFD55))),
          ),
        )
      ]),
    );
  }
}
