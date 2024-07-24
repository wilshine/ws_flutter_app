import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_404/ws_404_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_login/ws_views/ws_login_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main/ws_main_views/ws_main_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_mine/ws_mine_views/ws_mine_about_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_main_mine/ws_mine_views/ws_mine_setting_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_splash/ws_views/ws_splash_view.dart';
import 'package:ws_flutter_app/ws_app/ws_pages/ws_webview/ws_web_view.dart';


GoRouter router = GoRouter(
  initialLocation: '/splash',
  routes: <RouteBase>[deskAppRoute],
  onException: (BuildContext ctx, GoRouterState state, GoRouter router) {
    router.go('/404', extra: state.uri.toString());
  },
);

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
        return WSWebView(url: (state.extra as Map)['url'],);
      },
    ),

    GoRoute(
      path: 'main',
      builder: (BuildContext context, GoRouterState state) {
        return WSMainView();
      },
      routes: [
        GoRoute(
          path: 'mine',
          builder: (BuildContext context, GoRouterState state) {
            return Container();
          },
        ),
        GoRoute(
          path: 'im',
          builder: (BuildContext context, GoRouterState state) {
            return Container();
          },
        ),
        GoRoute(
          path: 'find',
          builder: (BuildContext context, GoRouterState state) {
            return Container();
          },
        ),
        GoRoute(
          path: 'about',
          builder: (BuildContext context, GoRouterState state) {
            return const WSMineAboutView();
          },
        ),
        GoRoute(
          path: 'setting',
          builder: (BuildContext context, GoRouterState state) {
            return const WSMineSettingView();
          },
        ),
      ],
    ),

  ],
);
