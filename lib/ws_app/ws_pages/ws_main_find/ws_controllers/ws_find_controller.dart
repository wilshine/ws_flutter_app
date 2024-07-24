import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ws_flutter_app/ws_app/ws_models/ws_article_model.dart';
import 'package:ws_flutter_app/ws_app/ws_models/ws_im_model.dart';
import 'package:common_ui/common_ui.dart';

import '../../../../ws_services/ws_app_service.dart';
import '../../../../ws_utils/ws_file_util.dart';
import '../../ws_main_im/ws_im_views/ws_conversation/util/ws_media_util.dart';

class WSFindController extends GetxController {
  final postContentLength = 0.obs;

  /// 详情页的详情翻译
  final detailDescription = ''.obs;
  final postImageList = [].obs;

  Future<void> initArticleList() async {
    // WSAppService.instance.articleList.refresh();
  }

  void addPostImage() async {
    String? imgPath = await WSMediaUtil.instance.pickImage();
    if (imgPath != null) {
      Directory directory = await getTemporaryDirectory();
      String name = imgPath.split('/').last;
      // String destPath = '${directory.path}/article/${WSAppService.instance.userInfo.value.userId!}/$name';
      // await WSFileUtil.copyFile(imgPath, destPath);
      // postImageList.add(destPath);
    }
  }

  /// 添加一篇文章
  void postArticle(String title, String description) async {
    // try {
    //   EasyLoading.show();
    //   await Future.delayed(const Duration(seconds: 2));
    //   WSArticleModel articleModel = WSArticleModel(
    //     title: title,
    //     articleType: '',
    //     description: description,
    //     author: WSAppService.instance.userInfo.value.userId!,
    //     user: WSUserModel(
    //       userId: WSAppService.instance.userInfo.value.userId!,
    //       nickname: WSAppService.instance.userInfo.value.nickname!,
    //       avatar: WSAppService.instance.userInfo.value.avatarUrl!,
    //     ),
    //     followed: 0,
    //     count: 0,
    //     thumbnail: postImageList.value.elementAt(0),
    //     content: postImageList.value,
    //     type: WSArticleModel.typePreformance,
    //     commentList: [],
    //   );
    //   WSAppService.instance.articleList.value.insert(0, articleModel);
    //   WSAppService.instance.refreshArticles();
    //   initArticleList();
    //   Get.back();
    //   WSToast.show('post successfully');
    // } catch (e, s) {
    //   WSLogger.error('$e  $s');
    // } finally {
    //   EasyLoading.dismiss();
    // }
  }

  /// 点赞、取消点赞
  void toggleLikeMe(WSArticleModel item) {
    if (item.likedByMe == true) {
      item.likedByMe = false;
      item.followed = item.followed - 1;
    } else {
      item.likedByMe = true;
      item.followed = item.followed + 1;
    }
    WSAppService.instance.refreshArticles();
    // WSAppService.instance.articleList.refresh();
  }

  void popMoreMenuDialog(String userId) {
    // List<WSFollowedItem> list = WSAppService.instance.followedList.value;
    bool isFollowed = false;
    // for (var item in list) {
    //   if (item.user?.userId == userId) {
    //     isFollowed = true;
    //   }
    // }

    List menuList = [
      {
        'title': isFollowed ? 'Unfollow' : 'Follow',
        'onPressed': () async {
          try {
            EasyLoading.show();
            if (isFollowed) {
              await WSAppService.instance.unFriend(userId);
              WSToast.show('Unfollow Successfully');
            } else {
              await WSAppService.instance.addFriend(userId);
              WSToast.show('Follow Successfully');
            }
          } catch (e, s) {
            // WSLogger.error('$e  $s');
          } finally {
            EasyLoading.dismiss();
          }
        },
      },
      {
        'title': 'Block',
        'onPressed': () async {
          try {
            EasyLoading.show();
            // WSLogManger().putLog(WSLogType.clickEvent, {'page': WSLogPages.pageBlock});
            await WSAppService.instance.blockUser(userId);
            WSToast.show('Block Successfully');
            Get.back();
          } finally {
            EasyLoading.dismiss();
          }
        },
      },
      {
        'title': 'Report',
        'onPressed': () async {
          // popReportDialog(userId);
        }
      }
    ];
    // WSDialogUtil.showSelectDialog(menuList);
  }

  void popReportDialog(String userId) async {
    List reportList = ['Pornographic', 'False gender', 'Fraud', 'Political sensitive', 'Other'];
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            ...reportList
                .map((e) => CupertinoActionSheetAction(
                      onPressed: () async {
                        // WSLogManger().putLog(WSLogType.clickEvent, {'page': WSLogPages.pageReport});
                        try {
                          EasyLoading.show();
                          await WSAppService.instance.report(userId, e);
                          await Future.delayed(const Duration(seconds: 3));
                          WSToast.show('Report Successfully');
                          Navigator.pop(context);
                        } catch (e) {
                          WSToast.show('Report Failed');
                        } finally {
                          EasyLoading.dismiss();
                        }
                      },
                      child: Container(
                        child: Text(e),
                      ),
                    ))
                .toList(),
          ],
          cancelButton: CupertinoActionSheetAction(
            //取消按钮
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }
}
