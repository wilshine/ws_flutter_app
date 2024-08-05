import 'package:common_tools/common_tools.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_flutter_app/ws_app/ws_app_route.dart';

class WsExampleBuildView extends StatefulWidget {
  const WsExampleBuildView({super.key});

  @override
  State<WsExampleBuildView> createState() => _WsExampleBuildViewState();
}

class _WsExampleBuildViewState extends State<WsExampleBuildView> with RouteAware, WidgetsBindingObserver {
  String logInfo = '';

  /// 初始化
  @override
  void initState() {
    super.initState();
    logInfo += 'initState\n';
    WidgetsBinding.instance.addObserver(this);
  }

  /// 生命周期结束
  @override
  void dispose() {
    logInfo += 'dispose\n';
    WidgetsBinding.instance.removeObserver(this);
    wsNavObserver.unsubscribe(this);
    super.dispose();
  }

  /// 路由栈上面的路由移除，显示当前路由
  @override
  void didPopNext() {
    logInfo += 'didPopNext\n';
    Logger.info('didPopNext');
  }

  /// 当前路由展示
  @override
  void didPush() {
    logInfo += 'didPush\n';
    Logger.info('didPush');
  }

  /// 当前路由移除回调
  @override
  void didPop() {
    logInfo += 'didPop\n';
    Logger.info('didPop');
  }

  /// 新的路由展示，当前路由不可见
  @override
  void didPushNext() {
    logInfo += 'didPushNext\n';
    Logger.info('didPushNext');
  }

  /// 回调时机：
  /// 1、初始化的时候
  /// 2、InheritedWidget绑定的时候（dependOnInheritedWidgetOfExactType）
  ///
  @override
  void didChangeDependencies() {
    logInfo += 'didChangeDependencies\n';
    Logger.info('didChangeDependencies');

    wsNavObserver.subscribe(this, ModalRoute.of(context)!); //of方法会进行InheritedWidget绑定

    super.didChangeDependencies();
  }

  /// 依赖的InheritedWidget改变时调用
  @override
  void didUpdateWidget(covariant WsExampleBuildView oldWidget) {
    logInfo += 'didUpdateWidget\n';
    Logger.info('didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  /// 组件被移除时调用
  @override
  void deactivate() {
    logInfo += 'deactivate\n';
    Logger.info('deactivate');
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    logInfo += 'build\n';
    Logger.info('build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('WsExampleBuildView'),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(child: Text(logInfo)),
            ),
            ElevatedButton(
              child: Text('打开新页面'),
              onPressed: () {
                context.push('/main/setting');
              },
            ),
            ElevatedButton(
              child: Text('setState'),
              onPressed: () {
                setState(() {

                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // 页面 pop
  @override
  Future<bool> didPopRoute() {
    logInfo += 'didPopRoute\n';
    Logger.info('didPopRoute');
    return didPopRoute();
  }

  // 页面 push
  @override
  Future<bool> didPushRoute(String route) {
    logInfo += 'didPushRoute\n';
    Logger.info('didPushRoute  $route');
    return super.didPushRoute(route);
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    logInfo += 'didPushRouteInformation\n';
    Logger.info('didPushRouteInformation  $routeInformation');
    return super.didPushRouteInformation(routeInformation);
  }

  // 系统窗口相关改变回调，如旋转
  @override
  void didChangeMetrics() {
    logInfo += 'didChangeMetrics\n';
    Logger.info('didChangeMetrics');
  }

  // 文本缩放系数变化
  @override
  void didChangeTextScaleFactor() {
    logInfo += 'didChangeTextScaleFactor\n';
    Logger.info('didChangeTextScaleFactor');
  }

  // 系统亮度变化
  @override
  void didChangePlatformBrightness() {
    logInfo += 'didChangePlatformBrightness\n';
    Logger.info('didChangePlatformBrightness');
  }

  // 本地化语言变化
  @override
  void didChangeLocales(List<Locale>? locales) {
    logInfo += 'didChangeLocales\n';
    Logger.info('didChangeLocales  $locales');
  }

  //App 生命周期变化
  //AppLifecycleState枚举值：
  //resumed：可见的，并能响应用户的输入。
  //inactive：处在不活动状态，无法处理用户响应。
  //paused：不可见并不能响应用户的输入，但是在后台继续活动中。
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    logInfo += 'didChangeAppLifecycleState\n';
    Logger.info('didChangeAppLifecycleState  $state');
  }

  // 内存警告回调
  @override
  void didHaveMemoryPressure() {
    logInfo += 'didHaveMemoryPressure\n';
    Logger.info('didHaveMemoryPressure');
  }

  //Accessibility 相关特性回调
  @override
  void didChangeAccessibilityFeatures() {
    logInfo += 'didChangeAccessibilityFeatures\n';
    Logger.info('didChangeAccessibilityFeatures');
  }
}
