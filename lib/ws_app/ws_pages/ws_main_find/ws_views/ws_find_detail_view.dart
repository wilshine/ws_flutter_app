import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_models/ws_article_model.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_common/ws_navigation_widgets.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_find/ws_controllers/ws_find_controller.dart';
import 'package:ws_flutter_app/ws_services/ws_app_service.dart';
import 'package:ws_flutter_app/ws_utils/ws_toast_util.dart';

class WSFIndDetailView extends StatefulWidget {
  const WSFIndDetailView({
    super.key,
    required this.articleModel,
  });

  final WSArticleModel articleModel;

  @override
  State<WSFIndDetailView> createState() => _WSFIndDetailViewState();
}

class _WSFIndDetailViewState extends State<WSFIndDetailView> {
  WSFindController controller = Get.find<WSFindController>();

  @override
  void initState() {
    controller.detailDescription.value = '';
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: buildMiddle(),
                )),
            Positioned(
              top: WSNavigationWidgets.commonBackButtonTop(context),
              left: 0,
              right: 0,
              child: buildTopBar(),
            ),
            Positioned(bottom: 0, left: 0, right: 0, child: buildInputWidget()),
          ],
        ),
      ),
    );
  }

  Widget buildMiddle() {
    return Column(children: [
      buildTopBack(),
      buildInfoWidget(),
      Container(
        height: 8.h,
        color: const Color(0xFFF6F7F8),
      ),
      Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 20.w, top: 24.h, bottom: 10.h),
          alignment: Alignment.centerLeft,
          child: Text(
            'Comment (${widget.articleModel.commentList.length})',
            style: TextStyle(color: const Color(0xFF202020), fontSize: 16.sp),
          ),
        ),
      ),
      buildCommentsWidget(),
    ]);
  }

  /// 顶部背景
  Widget buildTopBack() {
    return Container(
      height: 300.h,
      child: Swiper(
        itemCount: widget.articleModel.content?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Stack(children: [
              if (widget.articleModel.content != null)
                Image.asset(
                  widget.articleModel.content?.elementAt(index),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
              const Positioned(bottom: 0, left: 0, right: 0, child: ArcWidget()),
            ]),
          );
        },
        pagination: const SwiperPagination(),
      ),
    );
  }

  Widget buildInfoWidget() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.h, top: 10.h),
            color: Colors.white,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.articleModel.user?.avatar != null)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      try {
                        EasyLoading.show();
                        await WSAppService.instance.addFriend(widget.articleModel.user!.userId);
                        WSToastUtil.show('Follow Successfully');
                        setState(() {});
                      } finally {
                        EasyLoading.dismiss();
                      }
                    },
                    child: Stack(children: [
                      CircleAvatar(
                        radius: 20.w,
                        backgroundImage: NetworkImage(widget.articleModel.user?.avatar ?? ''),
                      ),
                      if (!WSAppService.instance.isFollowedUser(widget.articleModel.user!.userId))
                        Positioned(right: 0, bottom: 0, child: Image.asset('assets/webp/home_item_add_icon.webp', width: 16.w)),
                    ]),
                  ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(child: Text(widget.articleModel.user?.nickname ?? '')),
                StatefulBuilder(builder: (context, setState) {
                  return GestureDetector(
                    onTap: () async {
                      EasyLoading.show();
                      await Future.delayed(const Duration(milliseconds: 500));
                      controller.toggleLikeMe(widget.articleModel);
                      EasyLoading.dismiss();
                      setState(() {});
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      margin: EdgeInsets.only(left: 20.w),
                      child: Image.asset(
                        widget.articleModel.likedByMe ?? false
                            ? 'assets/webp/find_article_like.webp'
                            : 'assets/webp/find_article_unlike.webp',
                        width: 20,
                        height: 20,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: 12.h, left: 20.w),
              child: Text(
                widget.articleModel.title,
                style: TextStyle(
                  color: const Color(0xFF202020),
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 12.h, left: 20.h, right: 20.h, bottom: 30.h),
            child: Text(
              widget.articleModel.description,
              style: const TextStyle(color: Color(0xFF202020)),
            ),
          ),
          Obx(() {
            if (controller.detailDescription.value.isEmpty) {
              return Container();
            }
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20.w, right: 20.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFFCCCCCC), // Set the color of the border
                        width: 1.0, // Set the width of the border
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 12.h, left: 20.h, right: 20.h, bottom: 30.h),
                  color: Colors.white,
                  child: Text(
                    controller.detailDescription.value,
                    style: const TextStyle(color: Color(0xFF202020)),
                  ),
                ),
              ],
            );
          }),
          GestureDetector(
            onTap: () async {
              // String? txt = await WSGoogleUtil.translate(widget.articleModel.description);
              // if (txt != null) {
              //   controller.detailDescription.value = txt;
              //   controller.detailDescription.refresh();
              // } else {
              //   WSToastUtil.show('translate failed');
              // }
            },
            child: Container(
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.only(bottom: 20.h),
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.only(left: 7.w, right: 7.w, top: 4.h, bottom: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.w),
                    color: const Color(0xFF404040),
                  ),
                  margin: EdgeInsets.only(right: 20.w),
                  child: const Text(
                    'Translate',
                    style: TextStyle(color: Color(0xFFFCFD55)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopBar() {
    return Container(
      margin: EdgeInsets.only(top: 13.h, bottom: 6.h),
      child: Row(
        children: [
          WSNavigationWidgets.commonBackButton(),
          const Spacer(),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // if (WSAppService.instance.userInfo.value.userId == widget.articleModel.user?.userId) {
              //   WSToastUtil.show('can not talk with yourself');
              //   return;
              // }
              // Get.to(() => WSConversationView(
              //       user: widget.articleModel.user!,
              //     ));
            },
            child: Container(
              margin: EdgeInsets.only(right: 32.w),
              child: Image.asset(
                'assets/webp/find_detail_top_chat_icon.webp',
                width: 32.w,
                height: 32.h,
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              controller.popMoreMenuDialog(widget.articleModel.user!.userId);
            },
            child: Container(
                margin: EdgeInsets.only(right: 20.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.w),
                  color: const Color(0x4D000000),
                ),
                child: Icon(
                  Icons.more_horiz,
                  size: 32.w,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  Widget buildCommentsWidget() {
    return StatefulBuilder(
      builder: (context, setState) => Container(
        color: Colors.white,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.articleModel.commentList.length,
          itemBuilder: (context, index) {
            WSComment comment = widget.articleModel.commentList.elementAt(index);
            return Container(
              margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h, bottom: 10.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.w,
                        backgroundImage: NetworkImage(comment.avatar ?? ''),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: Text(comment.nickname ?? ''),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (comment.likedByMe == true) {
                            comment.likedByMe = false;
                          } else {
                            comment.likedByMe = true;
                          }
                          WSAppService.instance.refreshArticles();
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.only(left: 7.w, top: 4.h, bottom: 4.h),
                          child: Image.asset(
                              comment.likedByMe ?? false ? 'assets/webp/find_article_like.webp' : 'assets/webp/find_article_unlike.webp',
                              width: 16.h),
                        ),
                      ),
                    ],
                  ),
                  Container(margin: EdgeInsets.only(top: 12.h), alignment: Alignment.centerLeft, child: Text(comment.content ?? '')),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildInputWidget() {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(36.w),
              ),
              child: TextField(
                controller: _textEditingController,
                onSubmitted: (value) {
                  onClickSendBtn();
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your ideas...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 20, right: 20),
                ),
                maxLines: 1,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              onClickSendBtn();
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.w),
                color: const Color(0xFF404040),
              ),
              width: 62.w,
              height: 32.h,
              margin: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Text(
                'Send',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  final TextEditingController _textEditingController = TextEditingController();

  void onClickSendBtn() async {
    try {
      // FocusScope.of(context).unfocus();
      // EasyLoading.show();
      // await Future.delayed(Duration(milliseconds: 1000 + Random().nextInt(1000)));
      // String content = _textEditingController.text;
      // WSComment comment = WSComment(
      //   avatar: WSAppService.instance.userInfo.value.avatarUrl,
      //   nickname: WSAppService.instance.userInfo.value.nickname,
      //   content: content,
      // );
      // widget.articleModel.commentList.insert(0, comment);
      // setState(() {});
      // await WSAppService.instance.refreshArticles();
      // _textEditingController.text = '';
    } finally {
      // EasyLoading.dismiss();
    }
  }
}

class ArcWidget extends StatefulWidget {
  const ArcWidget({super.key});

  @override
  State<ArcWidget> createState() => _ArcWidgetState();
}

class _ArcWidgetState extends State<ArcWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      child: CustomPaint(
        painter: ArcPainter(),
        child: Container(),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height + 1) // Start at the bottom-left corner
      ..lineTo(0, size.height - 10.h) // Move up by 100 pixels
      ..quadraticBezierTo(size.width / 2, size.height - 48.h, size.width, size.height - 10.h) // Draw a quadratic bezier curve
      ..lineTo(size.width, size.height + 1) // Draw a line to the bottom-right corner
      ..close(); // Close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
