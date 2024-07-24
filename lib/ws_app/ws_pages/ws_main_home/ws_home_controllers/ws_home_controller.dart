import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../../../ws_services/ws_app_service.dart';
import '../../../ws_models/ws_article_model.dart';
import '../../../ws_models/ws_user_model.dart';

class WSHomeController extends GetxController {
  Rx<int> currentSelectedIndex = (-1).obs;
  Map animationControllers = {};

  @override
  void onInit() {
    super.onInit();
  }

  final homeDataMap = {}.obs;

  Future refresh() async {
    Map map = {
      0: {
        'title': 'Fast Labyrinth',
        'price': 98,
        'description':
            "The maze in the park is one of the popular modes, and the route chosen requires you to experience it, but of course we'll help you calculate the time. The person who takes the least amount of time gets another gift from us, but of course this is limited to those who bought their tickets online. ",
        'imageAssets': 'assets/images/home_top_back_1.png',
      },
      1: {
        'title': 'VR mini-games',
        'price': 89,
        'description':
            'Welcome to experience the VR boxing game and see how long you can last. Welcome to experience offline.',
        'imageAssets': 'assets/images/home_top_back_2.png',
      },
      2: {
        'title': 'Bumper-car race',
        'price': 69,
        'description':
            'Buying tickets online is cheaper than buying tickets offline. Those who survive for a long time can also get an offline gift. Come and play together. ',
        'imageAssets': 'assets/images/home_top_back_3.png',
      },
      3: {
        'title': 'Treasure hunt',
        'price': 99,
        'description':
            'Come join us offline for a treasure hunt, after buying your ticket you will be given a map offline, the fastest to find the treasure following the route map given wins',
        'imageAssets': 'assets/images/home_top_back_4.png',
      }
    };
    // int selectedUserIndex = WSAppService.instance.userList.length - 1;
    // for (int index = 0; index < 4; index++) {
    //   List<WSUserModel> userList = [];
    //   for (WSArticleModel article in WSAppService.instance.articleOriginList) {
    //     if (article.articleType == map[index]['title']) {
    //       if (userList.firstWhereOrNull((element) => element.userId == article.user!.userId) != null) {
    //         break;
    //       }
    //       userList.add(article.user!);
    //     }
    //   }
    //   if (userList.length > 3) {
    //     userList = userList.sublist(0, 3);
    //   } else {
    //     for (int i = userList.length; i < 3; i++) {
    //       userList.add(WSAppService.instance.userList.elementAt(selectedUserIndex--));
    //     }
    //   }
    //   map[index]['userList'] = userList;
    // }
    homeDataMap.value = map;
    homeDataMap.refresh();
  }

  void setCurrentSelectedIndex(int index) {
    if (currentSelectedIndex.value == index) {
      index = -1;
    }
    currentSelectedIndex.value = index;

    for (var i = 0; i < animationControllers.length; i++) {
      if (i != index) {
        animationControllers[i.toString()].reverse();
      } else {
        animationControllers[i.toString()].forward();
      }
    }
  }

  void setAnimationController(int index, AnimationController controller) {
    animationControllers[index.toString()] = controller;
  }

  void buy(int price) {
    // if (WSAppService.instance.userInfo.value.availableCoins >= price) {
    //   Get.to(() => WSHomePaidView(price: price));
    // } else {
    //   WSDialogUtil.showPayDialog();
    // }
  }
}
