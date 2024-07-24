import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ws_flutter_app/ws_app/ws_models/ws_user_model.dart';
import 'package:ws_flutter_app/ws_services/ws_app_service.dart';

import '../../ws_home_controllers/ws_home_controller.dart';
import '../../ws_home_paid/ws_home_paid_article.dart';
import 'ws_home_chat.dart';

class WSHomeItem extends StatefulWidget {
  const WSHomeItem({
    super.key,
    required this.index,
    required this.title,
    required this.imageAssets,
    required this.usrList,
    required this.description,
    required this.price,
  });

  final int index;
  final String title;
  final int price;
  final String description;
  final String imageAssets;
  final List<WSUserModel> usrList;

  @override
  State<WSHomeItem> createState() => WSHomeItemState();
}

class WSHomeItemState extends State<WSHomeItem> with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(duration: const Duration(milliseconds: 250), value: 0, vsync: this);
    Get.find<WSHomeController>().setAnimationController(widget.index, animationController!);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    List rankingPathList = [
      'assets/webp/ranking_first.webp',
      'assets/webp/ranking_second.webp',
      'assets/webp/ranking_third.webp',
    ];
    for (int i = 0; i < widget.usrList.length; i++) {
      WSUserModel? user = widget.usrList[i];
      if (user == null) continue;
      Widget w = WSHomeChat(
        user: user,
        rankingPath: rankingPathList[i],
      );
      children.add(w);
    }
    return Column(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          pressedOpacity: 0.8,
          onPressed: () {
            onEventClickCard(widget.title, widget.description, widget.imageAssets, widget.price);
          },
          child: getBody(),
        ),
        if (children.isNotEmpty)
          SizeTransition(
            axisAlignment: -1,
            axis: Axis.vertical,
            sizeFactor: CurvedAnimation(
              curve: Curves.fastOutSlowIn,
              parent: animationController!,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF2A2F2B),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: Column(
                  children: [...children],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget getBody() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF3D3F40),
            Color(0xFF454747),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 78,
            width: 138,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              pressedOpacity: 0.4,
              onPressed: () {
                onEventClickImage(widget.title, widget.description, widget.imageAssets, widget.price);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColoredBox(
                  color: Colors.white,
                  child: Image.asset(
                    widget.imageAssets,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  height: 78,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Color(0xFFE6FF4E),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 20,
                  child: Obx(() {
                    Get.find<WSHomeController>().currentSelectedIndex.value;
                    return CupertinoButton(
                      padding: EdgeInsets.zero,
                      pressedOpacity: 0.3,
                      onPressed: () {
                        onEventClickDownArrow();
                      },
                      child: Container(
                        height: 78,
                        padding: const EdgeInsets.only(bottom: 4),
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 44,
                          height: 25,
                          child: Image.asset(
                            isShowChats() ? 'assets/images/home/home_play_button_down.webp' : 'assets/webp/home_top_bar_btn.webp',
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isShowChats() {
    return Get.find<WSHomeController>().currentSelectedIndex.value == widget.index;
  }

  /// Events
  void onEventClickCard(String title, String description, String imageAssets, int price) {
    Get.to(() => WSHomePaidArticle(title: title, price: price, description: description, imageAssets: imageAssets));
  }

  void onEventClickImage(String title, String description, String imageAssets, int price) {
    Get.to(() => WSHomePaidArticle(title: title, price: price, description: description, imageAssets: imageAssets));
  }

  void onEventClickDownArrow() {
    Get.find<WSHomeController>().setCurrentSelectedIndex(widget.index);
    setState(() {});
  }
}
