import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_flutter_app/ws_app/ws_app_const.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_login/ws_views/ws_login_view.dart';
import 'package:ws_flutter_app/ws_utils/ws_shared_preferences_util.dart';

/// 引导页
class WSSplashView extends StatefulWidget {
  const WSSplashView({super.key});

  @override
  State<WSSplashView> createState() => WSSplashViewState();
}

class WSSplashViewState extends State<WSSplashView> {
  SwiperController? swiperController;
  int swiperCount = 3;
  int swiperIndex = 0;

  // Timer? _timer;

  @override
  void initState() {
    super.initState();
    WSSharedPreferencesUtil().prefs.setBool(WSAppConst.keyDoneSplash, true);
    swiperController ??= SwiperController();

    /// 第一次给3秒，减去启动时间
    // _timer?.cancel();
    // _timer = null;
    // _timer = Timer(const Duration(seconds: 3), () {
    //   goToNextPage();
    // });
  }

  @override
  Widget build(BuildContext context) {
    Widget getPageIcon(int index) {
      return Container(
        height: 40,
        width: 40,
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/webp/splash_page_icon.webp')),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
        ),
      );
    }

    List<Widget> getChildren() {
      List<Widget> result = [];
      for (int i = 0; i < swiperCount; i++) {
        Widget w = getPageIcon(i);
        result.add(w);
        if (i != swiperCount - 1) {
          if (i == swiperIndex) {
            result.add(const SizedBox(width: 30));
          } else {
            result.add(const SizedBox(width: 10));
          }
        }
      }
      return result;
    }

    return Scaffold(
      body: Swiper(
        loop: false,
        itemCount: swiperCount,
        pagination: SwiperPagination(
          alignment: const Alignment(0.8, 0.8),
          builder: SwiperCustomPagination(
            builder: (context, config) {
              return ColoredBox(
                color: Colors.transparent,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: getChildren(),
                ),
              );
            },
          ),
        ),
        controller: swiperController,
        itemBuilder: (BuildContext context, int index) {
          return getGuidePage('assets/images/splash${index + 1}_bg.png', isLast: index == swiperCount - 1);
        },
        onIndexChanged: (index) {
          swiperIndex = index;
        },
      ),
    );
  }

  Widget getGuidePage(String assetsImageName, {bool isLast = false}) {
    Widget getPage() => Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(assetsImageName, fit: BoxFit.fill),
            ),
            Positioned(
              right: 20,
              bottom: 40,
              child: CupertinoButton(
                child: const Text('Jump To Next', style: TextStyle(color: Colors.transparent)),
                onPressed: () {
                  if (swiperIndex == swiperCount - 1) {
                    goToLoginPage();
                  } else {
                    swiperController?.next();
                  }
                },
              ),
            )
          ],
        );
    if (!isLast) {
      return getPage();
    }
    // return getPage();
    double startX = 0;
    double overX = 0;
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      child: getPage(),
      onHorizontalDragStart: (DragStartDetails details) {
        startX = details.globalPosition.dx;
      },
      onHorizontalDragUpdate: (DragUpdateDetails details) {
        overX = details.globalPosition.dx;
      },
      onHorizontalDragEnd: (DragEndDetails details) {
        if (overX - startX > -80.0 || details.velocity.pixelsPerSecond.dx < -300.0) {
          goToLoginPage();
        }
      },
    );
  }

  Future<void> goToNextPage() async {
    swiperController?.next();
  }

  Future<void> goToLoginPage() async {
    context.push('/login');

    /// 释放定时器
    // _timer?.cancel();
    // _timer = null;
  }
}
