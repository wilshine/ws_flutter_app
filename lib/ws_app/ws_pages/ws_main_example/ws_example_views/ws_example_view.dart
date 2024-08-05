import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../ws_base/ws_base_ui.dart';

class WsExampleView extends WSBaseStatefulWidget {
  WsExampleView({super.key, required super.title});

  @override
  State<WsExampleView> createState() => _WsExampleViewState();
}

class _WsExampleViewState extends State<WsExampleView> {
  List list = [
    {'desc': 'flutter_spinkit', 'routeName': '/main/flutter_spinkit'},
    {'desc': 'build生命周期演示', 'routeName': '/main/ws_example_build_view'},
    {'desc': '拖拽演示', 'routeName': '/main/drag_gridview'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: SliverHeaderDelegate.fixedHeight(
                  height: 100,
                  child: Container(
                    height: 100,
                    color: Colors.blue,
                    child: const Center(
                      child: Text('示例'),
                    ),
                  ))),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return buildItem(
                    list.elementAtOrNull(index)['desc'] ?? '', list.elementAtOrNull(index)['routeName'] ?? '');
              },
              childCount: list.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(String desc, String routeName) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.push(routeName);
      },
      child: Container(
        color: Colors.grey,
        child: Center(child: Text(desc)),
      ),
    );
  }
}

typedef SliverHeaderBuilder = Widget Function(BuildContext context, double shrinkOffset, bool overlapsContent);

class SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  // child 为 header
  SliverHeaderDelegate({
    required this.maxHeight,
    this.minHeight = 0,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        assert(minHeight <= maxHeight && minHeight >= 0);

  //最大和最小高度相同
  SliverHeaderDelegate.fixedHeight({
    required double height,
    required Widget child,
  })  : builder = ((a, b, c) => child),
        maxHeight = height,
        minHeight = height;

  //需要自定义builder时使用
  SliverHeaderDelegate.builder({
    required this.maxHeight,
    this.minHeight = 0,
    required this.builder,
  });

  final double maxHeight;
  final double minHeight;
  final SliverHeaderBuilder builder;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    Widget child = builder(context, shrinkOffset, overlapsContent);
    //测试代码：如果在调试模式，且子组件设置了key，则打印日志
    assert(() {
      if (child.key != null) {
        print('${child.key}: shrink: $shrinkOffset，overlaps:$overlapsContent');
      }
      return true;
    }());
    // 让 header 尽可能充满限制的空间；宽度为 Viewport 宽度，
    // 高度随着用户滑动在[minHeight,maxHeight]之间变化。
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverHeaderDelegate old) {
    return old.maxExtent != maxExtent || old.minExtent != minExtent;
  }
}
