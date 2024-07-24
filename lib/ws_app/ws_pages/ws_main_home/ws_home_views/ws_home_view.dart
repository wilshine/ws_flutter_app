import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../ws_base/ws_base_ui.dart';
import '../ws_home_controllers/ws_home_controller.dart';
import 'widgets/ws_home_item.dart';

class WSHomeView extends WSBaseStatefulWidget {
  WSHomeView({super.key, required super.title});

  @override
  State<WSHomeView> createState() => _WSHomeViewsState();
}

class _WSHomeViewsState extends State<WSHomeView> {
  Map<int, WSBaseStatefulWidget> pages = {};

  late WSHomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(WSHomeController());
    // controller.refresh();
  }

  @override
  void dispose() {
    Get.delete<WSHomeController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF9FCED),
              Color(0xFFFFFFFF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Obx(() {
              return getBody();
            }),
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    List<Widget> children = [];
    controller.homeDataMap.value.forEach((index, value) {
      Widget w = WSHomeItem(
        index: index,
        title: value['title'],
        price: value['price'],
        imageAssets: value['imageAssets'],
        description: value['description'],
        usrList: value['userList'] ?? [],
      );
      children.add(w);
    });

    return Column(
      children: [
        getLogoDay(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...children,
                  getLastItem(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget getLogoDay() {
    return SizedBox(
      height: 44,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4, left: 10, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 2),
              child: Text(
                'Today',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xff565656)),
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 2),
              child: Text(
                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Color(0x80000000)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getLastItem() {
    return Container(
      height: 88,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(image: AssetImage('assets/webp/home_bottom_back.webp'), fit: BoxFit.fill),
      ),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 40),
        child: const Text(
          'Stay tuned for other content!',
          style: TextStyle(
            color: Color(0xFF404040),
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
