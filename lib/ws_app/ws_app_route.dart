import 'package:common_tools/common_tools.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_404/ws_404_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_login/ws_views/ws_login_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main/ws_main_views/ws_main_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_example/ws_example_views/ws_example_build_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_example/ws_example_views/ws_example_flutter_spinkit_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_im/ws_im_views/ws_conversation/ws_conversation_views/chat_page.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_mine/ws_mine_views/ws_mine_about_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_mine/ws_mine_views/ws_mine_setting_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_splash/ws_views/ws_splash_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_webview/ws_web_view.dart';

import 'ws_pages/ws_main_example/ws_example_views/ws_example_drag_gridview_view.dart';

GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: <RouteBase>[deskAppRoute],
  observers: [wsNavObserver],
  onException: (BuildContext ctx, GoRouterState state, GoRouter router) {
    router.go('/404', extra: state.uri.toString());
  },
);

/// 路由生命周期监听
MyNavObserver wsNavObserver = MyNavObserver();

extension on Route<dynamic> {
  String get str => 'route(${settings.name}: ${settings.arguments})';
}

class MyNavObserver extends RouteObserver {
  static const tag = 'MyNavObserver';

  MyNavObserver() {
    Logger.info('MyNavObserver', tag: tag);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    Logger.info('didPush: ${route.str}, previousRoute= ${previousRoute?.str}', tag: tag);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    Logger.info('didPop: ${route.str}, previousRoute= ${previousRoute?.str}', tag: tag);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    Logger.info('didRemove: ${route.str}, previousRoute= ${previousRoute?.str}', tag: tag);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    Logger.info('didReplace: new= ${newRoute?.str}, old= ${oldRoute?.str}', tag: tag);
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    super.didStartUserGesture(route, previousRoute);
    Logger.info(
        'didStartUserGesture: ${route.str}, '
        'previousRoute= ${previousRoute?.str}',
        tag: tag);
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
    Logger.info('didStopUserGesture', tag: tag);
  }
}

/// 命名路由页面
final RouteBase deskAppRoute = GoRoute(
  path: '/',
  redirect: (_, __) => null,
  routes: [
    GoRoute(
      path: 'splash',
      builder: (BuildContext context, GoRouterState state) {
        return WSSplashView();
      },
    ),
    GoRoute(
      path: '404',
      builder: (BuildContext context, GoRouterState state) {
        return Ws404View();
      },
    ),
    GoRoute(
      path: 'login',
      builder: (BuildContext context, GoRouterState state) {
        return WSLoginView();
      },
    ),
    GoRoute(
      path: 'webview',
      builder: (BuildContext context, GoRouterState state) {
        return WSWebView(
          url: (state.extra as Map)['url'],
        );
      },
    ),
    GoRoute(
      path: 'main',
      builder: (BuildContext context, GoRouterState state) {
        return WSMainView();
      },
      routes: [
        GoRoute(
          path: 'setting',
          builder: (BuildContext context, GoRouterState state) {
            return const WSMineSettingView();
          },
          routes: [
            GoRoute(
              path: 'about',
              builder: (BuildContext context, GoRouterState state) {
                return const WSMineAboutView();
              },
            ),
          ],
        ),
        GoRoute(
          path: 'conversation',
          builder: (BuildContext context, GoRouterState state) {
            return ChatPage();
            // return WSConversationView(user: WSUserModel.fromJson(state.extra as Map<String, dynamic>));
          },
        ),
        GoRoute(
          path: 'flutter_spinkit',
          builder: (BuildContext context, GoRouterState state) {
            return WsExampleFlutterSpinkitView();
            // return WSConversationView(user: WSUserModel.fromJson(state.extra as Map<String, dynamic>));
          },
        ),
        GoRoute(
          path: 'ws_example_build_view',
          builder: (BuildContext context, GoRouterState state) {
            return WsExampleBuildView();
            // return WSConversationView(user: WSUserModel.fromJson(state.extra as Map<String, dynamic>));
          },
        ),
        GoRoute(
          path: 'drag_gridview',
          builder: (BuildContext context, GoRouterState state) {
            return GridGalleryExample();
            // return WSConversationView(user: WSUserModel.fromJson(state.extra as Map<String, dynamic>));
          },
        ),
      ],
    ),
  ],
);
