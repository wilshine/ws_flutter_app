import 'package:common_tools/common_tools.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_find/ws_views/ws_find_detail_view.dart';

import '../../../../ws_services/ws_app_service.dart';
import '../../../ws_base/ws_base_ui.dart';
import '../../../ws_models/ws_article_model.dart';
import '../ws_controllers/ws_find_controller.dart';
import 'ws_find_post_view.dart';

class WSFindView extends WSBaseStatefulWidget {
  const WSFindView({super.key, required super.title});

  @override
  State<WSFindView> createState() => _WSFindViewState();
}

class _WSFindViewState extends State<WSFindView> {
  late WSFindController controller;
  late EasyRefreshController easyRefreshController;

  @override
  void initState() {
    controller = Get.put(WSFindController());
    controller.initArticleList();
    easyRefreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    super.initState();
  }

  @override
  void dispose() {
    // WSLogger.debug('_WSFindViewState dispose');
    easyRefreshController.dispose();
    Get.delete<WSFindController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          // 渐变背景色
          gradient: LinearGradient(
            colors: [
              Color(0xFF3D3F40),
              Color(0xFF222426),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: context.mediaQueryPadding.top.h),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 32.h,
                  alignment: Alignment.bottomLeft,
                  margin: EdgeInsets.only(left: 20.w),
                  child: SvgPicture.asset('assets/svg/find_discoveries_icon.svg'),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Get.to(() => const WSFindPostView());
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20.w),
                    width: 58.w,
                    height: 32.h,
                    child: Image.asset('assets/webp/find_list_camera.webp'),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10.h),
                child: EasyRefresh(
                  controller: easyRefreshController,
                  onRefresh: () async {
                    await Future.delayed(const Duration(seconds: 1));
                    easyRefreshController.finishRefresh(IndicatorResult.success);
                  },
                  onLoad: () async {
                    await Future.delayed(const Duration(seconds: 1));
                    easyRefreshController.finishLoad(IndicatorResult.noMore);
                  },
                  child: Container(),
                  // child: Obx(() {

                    // return ListView.builder(
                    //   padding: const EdgeInsets.only(top: 0),
                    //   itemCount: WSAppService.instance.articleList.length,
                    //   itemBuilder: (context, index) {
                    //     var item = WSAppService.instance.articleList.value.elementAt(index);
                    //     return buildItem(item);
                    //   },
                    // );
                  // }
                  ),
                ),
              ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildTypeWidget(WSArticleModel item) {
    String assetsPath = '';
    switch (item.type) {
      case WSArticleModel.typeHot:
        assetsPath = 'assets/webp/find_type_hot.webp';
        break;
      case WSArticleModel.typePreformance:
        assetsPath = 'assets/webp/find_type_preformance.webp';
        break;
      default:
        assetsPath = 'assets/webp/find_type_recommed.webp';
        break;
    }
    return Container(
      child: Image.asset(
        assetsPath,
        height: 20.h,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Widget buildItem(WSArticleModel item) {
    var child = Container(
      height: 242.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
      ),
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h, top: 10.h),
      child: Stack(
        children: [
          if (item.thumbnail != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(child: Image.asset(item.thumbnail!, fit: BoxFit.fill, width: double.infinity, height: double.infinity)),
            ),
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              child: buildTypeWidget(item),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(left: 16.w, right: 16.h, top: 10.h, bottom: 10.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: item.user?.avatar != null ? NetworkImage(item.user!.avatar!) : null,
                  ),
                  SizedBox(
                    width: 16.w,
                  ),
                  Expanded(
                    child: Text(
                      (item.user?.nickname ?? '').overflow,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  StatefulBuilder(
                    builder: (context, setState) => GestureDetector(
                      onTap: () {
                        controller.toggleLikeMe(item);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.sp),
                        ),
                        padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
                        child: Row(
                          children: [
                            Image.asset(
                              item.likedByMe ?? false ? 'assets/webp/find_article_like.webp' : 'assets/webp/find_article_unlike.webp',
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              item.followed.toString(),
                              style: const TextStyle(color: Color(0xFFCCCCCC)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );

    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Get.to(() => WSFIndDetailView(articleModel: item));
        },
        child: child);
  }
}
