import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_common/ws_navigation_widgets.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_home/ws_home_controllers/ws_home_controller.dart';

class WSHomePaidView extends StatefulWidget {
  const WSHomePaidView({
    super.key,
    required this.price,
  });

  final int price;

  @override
  State<WSHomePaidView> createState() => WSHomePaidViewState();
}

class WSHomePaidViewState extends State<WSHomePaidView> {
  WSHomeController controller = Get.find<WSHomeController>();

  String orderNo = Random().nextInt(999999999).toString();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ColoredBox(
          color: const Color(0xFFF6F7F8),
          child: Stack(
            children: [
              Positioned(
                top: WSNavigationWidgets.commonBackButtonTop(context),
                left: 0,
                right: 0,
                child: buildTopBar(),
              ),
              Positioned(
                top: WSNavigationWidgets.commonBackButtonTop(context),
                left: 0,
                right: 0,
                child: buildTitle(),
              ),
              buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopBar() {
    return Container(
      margin: EdgeInsets.only(top: 13.h, bottom: 6.h),
      child: Row(
        children: [
          WSNavigationWidgets.commonBackButton(color: Colors.black),
          const Spacer(),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      margin: EdgeInsets.only(top: 13.h, bottom: 6.h),
      child: Row(
        children: const [
          Spacer(),
          Text(
            'Order Notifications',
            style: TextStyle(
              color: Color(0xFF202020),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        SizedBox(height: WSNavigationWidgets.commonBackButtonTop(context) + 80),
        Container(
          margin: EdgeInsets.only(right: 20.w, left: 20.w),
          padding: const EdgeInsets.only(top: 5, bottom: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 175,
                height: 133,
                child: Image.asset('assets/images/home/home_paid_top.webp'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Thank you for your choice',
                style: TextStyle(color: Color(0xFF8A63F0), fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: Image.asset('assets/images/home/home_paid_icon.png'),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.price.toString(),
                    style: const TextStyle(color: Color(0xFF404040), fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: EdgeInsets.only(right: 20.w, left: 20.w),
          padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Order Number：',
                    style: TextStyle(color: Color(0x80000000), fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    orderNo,
                    style: const TextStyle(color: Color(0xFF404040), fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Creation time：',
                    style: TextStyle(color: Color(0x80000000), fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
                    style: const TextStyle(color: Color(0xFF404040), fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        Builder(builder: (context) {
          Rx<bool> isPressed = false.obs;
          return Obx(
            () => Listener(
              onPointerDown: (e) {
                isPressed.value = true;
              },
              onPointerUp: (e) {
                isPressed.value = false;
              },
              child: CupertinoButton(
                pressedOpacity: 1,
                padding: EdgeInsets.zero,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    gradient: isPressed.value
                        ? const LinearGradient(
                            colors: [Color(0xFFB9D506), Color(0xFFF2F385)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )
                        : const LinearGradient(
                            colors: [Color(0xFFE6FF4E), Color(0xFFFCFD55)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                  ),
                  child: Text(
                    'Define',
                    style: TextStyle(
                      color: const Color(0xFF202020),
                      fontSize: 16,
                      fontWeight: isPressed.value ? FontWeight.w400 : FontWeight.w600,
                    ),
                  ),
                ),
                onPressed: () async {
                  // var res = await WSShopPayUtil().reviewModeConsume(widget.price.toString());
                  // if (res != null && res['code'] == 0) {
                  //   WSAppService.instance.userInfo.value.availableCoins -= widget.price;
                  //   WSAppService.instance.refreshUserInfo();
                  //   var data = {
                  //     'orderNo': orderNo,
                  //   };
                  //   Get.find<WSMineController>().addTicket(data);
                  //   Get.back();
                  //   WSToastUtil.show('Buy successfully');
                  // }
                },
              ),
            ),
          );
        }),
        const Spacer(),
      ],
    );
  }
}
