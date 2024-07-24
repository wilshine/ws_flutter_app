import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_common/ws_navigation_widgets.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_find/ws_views/ws_find_detail_view.dart';

import '../ws_home_controllers/ws_home_controller.dart';

class WSHomePaidArticle extends StatefulWidget {
  const WSHomePaidArticle({
    super.key,
    required this.title,
    required this.description,
    required this.imageAssets,
    required this.price,
  });

  final String title;
  final String description;
  final String imageAssets;
  final int price;

  @override
  State<WSHomePaidArticle> createState() => WSHomePaidArticleState();
}

class WSHomePaidArticleState extends State<WSHomePaidArticle> {
  WSHomeController controller = Get.find<WSHomeController>();

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
        bottomNavigationBar: Container(
          height: 90.h,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: const Color(0xFFCCCCCC), // Set the color of the border
                width: 0.5.w, // Set the width of the border
              ),
            ),
          ),
          child: Center(
            child: Builder(builder: (context) {
              Rx<bool> isPressed = false.obs;
              return Obx(
                () => Listener(
                  onPointerDown: (e) {
                    isPressed.value = true;
                  },
                  onPointerUp: (e) {
                    isPressed.value = false;
                  },
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      controller.buy(widget.price);
                    },
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 208.w, maxHeight: 40.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
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
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            offset: Offset(0, -1),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      ),
                      child: Text(
                        'Buy Now',
                        style: TextStyle(color: isPressed.value ? const Color(0xFF504D4D) : const Color(0xFF202020), fontSize: 16.sp),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              height: double.infinity,
              child: SingleChildScrollView(padding: EdgeInsets.zero, child: buildBody()),
            ),
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
          ],
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
        children: [
          const Spacer(),
          Text(
            widget.title,
            style: const TextStyle(
              color: Color(0xFF202020),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: WSNavigationWidgets.commonBackButtonTop(context) + 80),
        buildTop(),
        buildBottom(),
        LayoutBuilder(
          builder: (p, p2) {
            return Container(color: Colors.white);
          },
        ),
      ],
    );
  }

  buildTop() {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(left: 32.w, right: 32.w, top: 8.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            offset: const Offset(0, 10),
            blurRadius: 32,
            spreadRadius: 10,
          ),
        ],
        color: const Color(0x66000000),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white, width: 1.w),
      ),
      height: 252.h,
      child: Stack(
        children: [
          Image.asset(widget.imageAssets, width: double.infinity, height: double.infinity, fit: BoxFit.fill),
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0x66000000),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFFFFFFF), width: 0.5.w),
              ),
              child: Row(
                children: [
                  Container(
                    child: Image.asset(
                      'assets/webp/shop_coin_icon.webp',
                      width: 22.w,
                      height: 22.w,
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Container(
                    child: Text(
                      widget.price.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildBottom() {
    return Container(
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        const ArcWidget(),
        Container(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h, bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              gradient: const LinearGradient(
                colors: [Color(0xFFBAE0F2), Color(0xFFB4FCD6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 8.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(margin: EdgeInsets.only(bottom: 16.h), alignment: Alignment.centerLeft, child: Text(widget.title)),
                Text(widget.description),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
