import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:common_ui/common_ui.dart';

import '../ws_controllers/ws_find_controller.dart';

class WSFindPostView extends StatefulWidget {
  const WSFindPostView({super.key});

  @override
  State<WSFindPostView> createState() => _WSFindPostViewState();
}

class _WSFindPostViewState extends State<WSFindPostView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  int maxTitleLength = 100;
  int maxContentLength = 500;

  @override
  void initState() {
    super.initState();
    // WSDeviceUtil.dartStatusTheme();
    Get.find<WSFindController>().postImageList.value.clear();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.mediaQueryPadding.top.h),
            buildTopBar(),
            buildPicWidget(),
            Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(4.w),
                ),
                margin: EdgeInsets.only(bottom: 18.h, left: 20.w, right: 20.w),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Type your title.',
                    border: InputBorder.none,
                  ),
                  maxLines: 1,
                  controller: titleController,
                  onChanged: (value) {
                    if (value.length >= maxTitleLength) {
                      titleController.text = value.substring(0, maxTitleLength);
                      titleController.selection = TextSelection.fromPosition(TextPosition(offset: titleController.text.length));
                    }
                  },
                )),
            Container(
              margin: EdgeInsets.only(bottom: 18.h, left: 20.w, right: 20.w),
              child: Stack(children: [
                Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                    height: 132.h,
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Start your creation.',
                        border: InputBorder.none,
                      ),
                      maxLines: 10,
                      controller: contentController,
                      onChanged: (value) {
                        if (value.length >= maxContentLength) {
                          contentController.text = value.substring(0, maxContentLength);
                          contentController.selection = TextSelection.fromPosition(TextPosition(offset: contentController.text.length));
                          return;
                        }
                        Get.find<WSFindController>().postContentLength.value = value.length;
                      },
                    )),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Obx(() {
                    return Text(
                      '${Get.find<WSFindController>().postContentLength.value}/$maxContentLength',
                      style: const TextStyle(color: Color(0x4D000000)),
                    );
                  }),
                ),
              ]),
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
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: EdgeInsets.only(left: 20.w),
              child: const Icon(Icons.arrow_back),
            ),
          ),
          const Spacer(),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if(titleController.text.isEmpty) {
                WSToast.show('Please input title.');
                return;
              }
              if(contentController.text.isEmpty) {
                WSToast.show('Please input content.');
                return;
              }
              if(Get.find<WSFindController>().postImageList.isEmpty) {
                WSToast.show('Please add image.');
                return;
              }
              Get.find<WSFindController>().postArticle(
                titleController.text,
                contentController.text,
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 20.w),
              child: Image.asset(
                'assets/webp/find_post_icon.webp',
                width: 82.w,
                height: 32.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildPicWidget() {
    Widget addWidget = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        Get.find<WSFindController>().addPostImage();
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(4.w),
        ),
        margin: EdgeInsets.only(top: 12.h, bottom: 32.h, left: 20.w, right: 20.w),
        width: 104.w,
        height: 110.h,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.w),
            border: Border.all(
              color: const Color(0xFFCCCCCC),
              width: 2.w,
            ),
          ),
          child: const Icon(
            Icons.add,
            color: Color(0xFFCCCCCC),
            size: 24,
          ),
        ),
      ),
    );

    return Obx(() {
      List<Widget> children = [];
      for (var item in Get.find<WSFindController>().postImageList) {
        children.add(Container(
          margin: EdgeInsets.only(top: 12.h, bottom: 32.h, left: 20.w, right: 20.w),
          child: Stack(children: [
            Container(
              width: 104.w,
              height: 110.h,
              child: Image.file(
                File(item),
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.find<WSFindController>().postImageList.value.remove(item);
                  Get.find<WSFindController>().postImageList.refresh();
                },
                child: Container(
                  width: 30.w,
                  height: 20.h,
                  child: SvgPicture.asset('assets/svg/find_post_del.svg'),
                ),
              ),
            ),
          ]),
        ));
      }

      if (children.length < 3) {
        children.add(addWidget);
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: children,
        ),
      );
    });
  }
}
